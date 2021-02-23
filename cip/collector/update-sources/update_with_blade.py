#!/usr/bin/env python3
import os
from os import walk
import requests
import json
from requests.auth import HTTPBasicAuth

# environment variables
cip_access_id = os.environ['CIP_ACCESS_ID']
cip_access_key = os.environ['CIP_ACCESS_KEY']
cip_deployment = os.environ['CIP_DEPLOYMENT']

# update this to a list of collecto ids 
collector_list = []

# directory of blade.json files to list of file names 
base = 'path/to/directory/of/blade.json/files'
_, _, filenames = next(walk(base))

for collector in collector_list:
    source_url = f'https://api.{cip_deployment}.sumologic.com/api/v1/collectors/{collector}/sources'
    for file in filenames:
        with open(base + '/' + file, 'r') as f:
            blob = json.load(f)
            if blob['blade.type'] == 'Alert':
                cmd_list = []
                for k, v in blob.items():
                    if 'command' in k:
                        cmd_list.append(v)
                source = {
                    "name": blob['blade.name'],
                    "description": '',
                    "category": blob.get('blade.sourceCategory', ''),
                    "hostName": blob.get('blade.sourceHostName', ''),
                    "automaticDateParsing": False,
                    "multilineProcessingEnabled": blob.get('multilineProcessingEnabled', True),
                    "useAutolineMatching": True,
                    "forceTimeZone": False,
                    "filters":[],
                    "cutoffTimestamp":0,
                    "encoding":"UTF-8",
                    "fields":{},
                    "file": blob.get('file', ''),
                    "script": blob.get('script', ''),
                    "cronExpression": blob.get('cronExpression', ''),
                    "timeout":0,
                    "workingDir": '',
                    "commands": cmd_list,
                    "extension": blob.get('extension', ''),
                    "sourceType": blob.get('blade.type', '')
                }
                r = requests.post(source_url, auth=HTTPBasicAuth(cip_access_id, cip_access_key), json={"source": source})
                print(r.status_code)
            else:
                print('Skipping ' + blob['blade.type']) 