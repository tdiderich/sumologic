import os
import requests
import logging
from requests.auth import HTTPBasicAuth
from datetime import date, time, datetime, timedelta


# environment variables
cip_access_id = os.environ['CIP_ACCESS_ID']
cip_access_key = os.environ['CIP_ACCESS_KEY']
cip_deployment = os.environ['CIP_DEPLOYMENT']

# variables to update
DAYS_BACK = 10
query = '_sourceCategory=foo | timeslice 1d | count by _timeslice | save view foo_view'

# variables to not touch 
query_url = f'https://api.{cip_deployment}.sumologic.com/api/v1/search/jobs'
check_base_url = f'https://api.{cip_deployment}.sumologic.com/api/v1/search/jobs/'
search_ids = dict()

def start(days_back):
    day = (datetime.now() - timedelta(days=days_back)).strftime('%Y-%m-%d')
    start = day + 'T00:00:00'
    end = day + 'T23:59:59'
    search = {
        'query': query,
        'from': start,
        'to': end,
        'timeZone': 'GMT',
        'byReceiptTime': False
        }
    search = requests.post(query_url,auth=(cip_access_id, cip_access_key), json=search)
    search_ids[search.json()['id']] = 'STARTED'
    return search_ids

def check(search_ids):
    gathering = True
    while gathering:
        for key, value in search_ids.items():
            count = 0
            if value != 'DONE GATHERING RESULTS':
                count += 1
                check_url = check_base_url + key
                check = requests.get(check_url, auth=(cip_access_id, cip_access_key))
                search_ids[key] = check.json()['state']
            if count == 0:
                gathering = False
            else:
                if count == 1:
                    print('1 search still running...')
                else:    
                    print(f'{count} searches still running...')    

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, filename='./load_view.log')
    for x in range(DAYS_BACK):
        search_ids = start(x)
    check(search_ids)    

