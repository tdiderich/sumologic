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
comment = 'Comment to add to Insight after closing'

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
    for insights in initial_request.json()['data']['objects']:
        # add comment
        insight_comment = {
            'body': comment
        }
        insight_id = insights['id']
        comment_url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/insights/{insight_id}/comments'
        r = requests.post(comment_url, headers=headers, json=insight_comment)
        if r.status_code > 201:
            error = r.status_code
            print(f'[{error} ERROR] Failed to add comment on {insight_id}')
        else:
            print(f'Added comment on https://{cse_tenant_name}.portal.jask.ai/insight/{insight_id}')

        # close insight
        status = {'status': 'closed'}
        delete_url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/insights/{insight_id}/status'
        r = requests.put(delete_url, headers=headers, json=status)
        if r.status_code > 201:
            error = r.status_code
            print(f'Closed {insight_id}')
        else:
            print(f'Closed https://{cse_tenant_name}.portal.jask.ai/insight/{insight_id}')

    # checks if there is a next page
    # if True, returns to the top
    if (initial_request.json()['data']['hasNextPage'] == True):
        hasNextPage = True
    else:
        hasNextPage = False
