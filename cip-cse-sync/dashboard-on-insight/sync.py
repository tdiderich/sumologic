#!/usr/bin/env python3
import requests
import os
import json
from templates import pub_user_dash

# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']
headers = {'X-API-KEY': cse_api_key}
cip_access_id = os.environ['CIP_ACCESS_ID']
cip_access_key = os.environ['CIP_ACCESS_KEY']
cip_deployment = os.environ['CIP_DEPLOYMENT']

# folder id
folder_id = '0000000001042CF2'

# do not touch variables
hasNextPage = True
offset = 0

while hasNextPage:
    cse_signals= f'https://{cse_tenant_name}.portal.jask.ai/api/v1/insights?offset={offset}&limit=10&q=entity.type%3A"username"%20created%3ANOW-7D..NOW'
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
            dashboard = pub_user_dash(user_username, insight_id, dashboard_folder_id)
            if create_folder.status_code == 200:
                pass
            else:
                print('errrrrrr on folder creation')
                print(create_folder.text)
            create_dashboard = requests.post(f'https://api.{cip_deployment}.sumologic.com/api/v2/dashboards', auth=(cip_access_id, cip_access_key), json=dashboard)
            if create_dashboard.status_code == 200:
                print(f'successfully created investigation for {insight_id} on user {user_username}')
                pass
            else:
                print('errrrrr on dashboard creation')
                print(create_dashboard.text)

    if r.json()['data']['hasNextPage'] == True:
        offset += 10 
    else:
        hasNextPage = False                   
