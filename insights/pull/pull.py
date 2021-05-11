#!/usr/bin/env python
import requests
import json
import os

# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']
headers = {'X-API-KEY': cse_api_key}

# update 
query = '-status%3A"closed"'
fields = '&recordSummaryFields=device_ip,device_hostname,user_username'

# do not touch
url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/insights?q={query}'
api_key = 'KEY'
headers = {'X-API-KEY': cse_api_key}

# for while loop
hasNextPage = True

# loop goes until there are no pages left
while hasNextPage:
    initial_request = requests.get(url, headers=headers)
    # closes all Insights from the pull
    for insight in initial_request.json()['data']['objects']:
        for f in insight['recordSummaryFields']:
            field_name = f['fieldName']
            field_value = f['fieldValue']
            record_count = f['recordCount']
            print(f'{field_name} {field_value} was seen in {record_count} records.')

    # checks if there is a next page
    # if True, returns to the top
    if (initial_request.json()['data']['hasNextPage'] == True):
        hasNextPage = True
    else:
        hasNextPage = False
