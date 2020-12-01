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

# other variables
fields_url = 'https://api.us2.sumologic.com/api/v1/fields'
fer_url = 'https://api.us2.sumologic.com/api/v1/extractionRules'
tracker = dict()
used_fields = dict()
unused_fields = dict()

def main():
    fields = requests.get(fields_url,auth=HTTPBasicAuth(cip_access_id, cip_access_key))
    fields = fields.json()['data']
    fers = requests.get(fer_url, auth=HTTPBasicAuth(cip_access_id, cip_access_key))
    fers = fers.json()['data']
    
    for field in fields:
        # get actual field name
        field = field['fieldName']

        # setup dict for trackng 
        tracker[field] = dict()
        tracker[field]['count'] = 0
        tracker[field]['fers'] = []

        for fer in fers:
            if field in fer['fieldNames']:
                tracker[field]['count'] += 1
                tracker[field]['fers'].append(fer['name'])

    for field in fields:
        field = field['fieldName']
        if tracker[field]['count'] == 0:
            unused_fields[field] = tracker[field]
        else:
            used_fields[field] = tracker[field]   
    
    # create JSON blobs for all/used/unused fields 
    all_fields_json = json.dumps(tracker)
    used_fields_json = json.dumps(used_fields)
    unused_fields_json = json.dumps(unused_fields)

    # write to files 
    f = open('results_all_fields.json', 'w')
    f.write(all_fields_json)
    f.close()  
    f = open('results_used_fields.json', 'w')
    f.write(used_fields_json)
    f.close() 
    f = open('results_unused_fields.json', 'w')
    f.write(unused_fields_json)
    f.close()     


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, filename='./fields.log')
    main()