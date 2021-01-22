#!/usr/bin/env python3
import requests
import os
from requests.auth import HTTPBasicAuth
import pandas as pd 

# environment variables
cip_access_id = os.environ['CIP_ACCESS_ID']
cip_access_key = os.environ['CIP_ACCESS_KEY']
cip_deployment = os.environ['CIP_DEPLOYMENT']

# do not touch me
users_url = f'https://api.{cip_deployment}.sumologic.com/api/v1/users'
role_base_url = f'https://api.{cip_deployment}.sumologic.com/api/v1/roles/'
hasNextPage = True
token = None
role_cache = dict()
df = pd.DataFrame(columns=['First', 'Last', 'Email', 'Created_At', 'Is_Active', 'Last_Login', 'Roles', 'Capabilities'])

def handleRole(role):
    name = role['name']
    capabilities = role['capabilities']
    if name not in user_roles:
        user_roles.append(name)
    for c in capabilities:
        if c not in user_capabilities:
            user_capabilities.append(c)

while hasNextPage:
    # first request
    users = requests.get(users_url,auth=HTTPBasicAuth(cip_access_id, cip_access_key), params={'token': token})
    user_list = users.json()['data']
    print(users.json()['next'])

    # iterate on users
    for u in user_list:
        row = dict()
        role_names = list()
        capabilities = list()
        
        # set values for user 
        row['First'] = u['firstName']
        row['Last'] = u['lastName']
        row['Email'] = u['email']
        row['Created_At'] = u['createdAt']
        row['Is_Active'] = u['isActive']
        row['Last_Login'] = u['lastLoginTimestamp']

        # get info on user's roles 
        roles = u['roleIds']
        user_roles = list()
        user_capabilities = list()

        for r in roles:
            if r in role_cache:
                handleRole(role_cache[r])
                
            else:    
                role = requests.get(role_base_url+r, auth=HTTPBasicAuth(cip_access_id, cip_access_key))
                role = role.json()
                role_cache[r] = role
                handleRole(role)
        row['Roles'] = user_roles
        row['Capabilities'] = user_capabilities
        df = df.append(row, ignore_index=True)         

    if users.json()['next']:
        token = users.json()['next']
    else:
        hasNextPage = False
        df.to_csv('users.csv')