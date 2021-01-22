#!/usr/bin/env python3
import requests
import os
from templates import awesome_user_dash

# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']
headers = {'X-API-KEY': cse_api_key}
cip_access_id = os.environ['CIP_ACCESS_ID']
cip_access_key = os.environ['CIP_ACCESS_KEY']
cip_deployment = os.environ['CIP_DEPLOYMENT']

# folder id
folder_id = '000000000102E4F6'

# do not touch variables
hasNextPage = True
offset = 0

while hasNextPage:
    cse_signals= f'https://{cse_tenant_name}.portal.jask.ai/api/v1/insights?offset={offset}&limit=1&q=-status%3A%22closed%22%20entity.type%3A%22username%22'
    r = requests.get(cse_signals, headers=headers)
    insights = r.json()['data']['objects']
    for i in insights:
        entity = i['entity']
        insight_id = i['readableId']
        insight_uid = i['id']
        if 'username' in entity:
            user_username = entity['username']
            folder = {
                "name": f"{insight_id}",
                "description": f"Investigation for Insight that can be found at -> https://{cse_tenant_name}.portal.jask.ai/insights/{insight_id}",
                "parentId": folder_id
                }
            create_folder = requests.post(f'https://api.{cip_deployment}.sumologic.com/api/v2/content/folders', auth=(cip_access_id, cip_access_key), json=folder)
            dashboard_folder_id = create_folder.json()['id']
            dashboard = awesome_user_dash(user_username, insight_id, dashboard_folder_id)
            print(dashboard)
            if create_folder.status_code == 200:
                pass
            else:
                print('errrrrrr on folder creation')
                print(create_folder.text)
            create_dashboard = requests.post(f'https://api.{cip_deployment}.sumologic.com/api/v2/dashboards', auth=(cip_access_id, cip_access_key), json=dashboard)
            if create_dashboard.status_code == 200:
                print('success')
                pass
            else:
                print('errrrrr on dashboard creation')
                print(create_dashboard.text)

    if r.json()['data']['hasNextPage'] != True:
        hasNextPage = False
    else:
        hasNextPage = False
        offset += 10                    
