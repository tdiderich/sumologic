#!/usr/bin/env python3
import os
import json
import requests
import logging
import base64
from requests.api import request
from requests.auth import HTTPBasicAuth

# environment variables
cip_access_id = os.environ['CIP_ACCESS_ID']
cip_access_key = os.environ['CIP_ACCESS_KEY']
cip_deployment = os.environ['CIP_DEPLOYMENT']
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']
headers = {'X-API-KEY': cse_api_key}

# do not touch
match_list_url_base = f'https://api.{cip_deployment}.sumologic.com/api/sec/v1/match-lists'

def add_values(list_name, list_id):
    hasNextPage = True
    offset = 0
    limit = 100
    while hasNextPage:
        values_url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/match-list-items?&q=listName%3A{list_name}&offset={offset}&limit={limit}'
        r = requests.get(values_url, headers=headers)
        values = r.json()['data']['objects']
        if len(values) > 0:
            payload = {'items': []}
            for value in values:
                upload_value = {
                                    "active": value['active'],
                                    "description": value['meta']['description'],
                                    "expiration": value['expiration'],
                                    "value": value['value']
                                }
                payload['items'].append(upload_value)
                upload_url = f'{match_list_url_base}/{list_id}/items'
                r = requests.post(upload_url, auth=HTTPBasicAuth(cip_access_id, cip_access_key), json=payload)
                if r.status_code > 202:
                    print(r.text)
                else:
                    return
            if r.json()['data']['hasNextPage']:
                offset += 100
            else:
                return
                
        else:
            print(f'{list_name} = empty list')
            return


def handle_lists():
    r = requests.get(match_list_url_base, auth=HTTPBasicAuth(cip_access_id, cip_access_key))
    lists = r.json()['data']['objects']
    for l in lists:
        list_name = l['name']
        list_id = l['id']
        add_values(list_name, list_id)

def main():
    handle_lists()


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, filename='./cse_setup.log')
    main()