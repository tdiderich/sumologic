#!/usr/bin/env python3
import os
import json
import requests
import logging
import base64
from requests.auth import HTTPBasicAuth

# environment variables
cip_access_id = os.environ['CIP_ACCESS_ID']
cip_access_key = os.environ['CIP_ACCESS_KEY']
cip_deployment = os.environ['CIP_DEPLOYMENT']

# variables to update
fer_id = '000000000000CD58'
cidr_list = ['10.10.10.0/32', '255.255.255.0/32', '192.1.0.0/16']
name = 'akamai'
scope = '_sourceCategory=*akamai*'
enabled = True

# do not touch variables
fer_url = f'https://api.{cip_deployment}.sumologic.com/api/v1/extractionRules/{fer_id}'

def make_parse_expression(cidr_list):
    cidr_ranges = dict()
    for cidr in cidr_list:
        cidr_ip = cidr.split('/')[0]
        cidr_range = cidr.split('/')[1]
        cidr_ranges[cidr_ip] = cidr_range
    return cidr_ranges

def make_fer(name, scope, parse_expression, enabled=True):
    fer = {
        'name': name,
        'scope': scope,
        'parseExpression': parse_expression,
        'enabled': enabled
        }
    return fer    

def main():
    parse_expression = '| json field=_raw "attackData.clientIP" as ip\n| "continuous" as partition\n'
    cidr_ranges = make_parse_expression(cidr_list)

    for k, v in cidr_ranges.items():
        parse_expression = parse_expression + f'| if(compareCIDRPrefix("{k}", ip, "{v}"), "infrequent", partition) as partition\n'

    fer = make_fer(name, scope, parse_expression, enabled)    
    
    r = requests.put(fer_url, auth=HTTPBasicAuth(cip_access_id, cip_access_key), json=fer)   
    if r.status_code != 200:
        logging.error(r.text)
    else:
        logging.info('successfully updated FER')      

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, filename='./fer_updates.log')
    main()
