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
query = '_sourcecategory=* | count'
lookback = 15 # minutes
query_type = 'agg' # agg OR raw 

# variables to not touch 
query_url = f'https://api.{cip_deployment}.sumologic.com/api/v1/search/jobs'
check_base_url = f'https://api.{cip_deployment}.sumologic.com/api/v1/search/jobs/'

def start():
    start = (datetime.now() - timedelta(minutes=lookback)).strftime('%Y-%m-%dT%H:%M:%S')
    end = datetime.now().strftime('%Y-%m-%dT%H:%M:%S')
    search = {
        'query': query,
        'from': start,
        'to': end,
        'timeZone': 'GMT',
        'byReceiptTime': False
        }
    search = requests.post(query_url,auth=(cip_access_id, cip_access_key), json=search)
    if search is not None and search.status_code < 300:
        search_id = search.json()['id']
    elif search.status_code == 429:
        # max concurrent searches is 200
        # so, this is sketchy rate limit handling
        # it assumes at least 1 search will clear from the queue in the 60 seconds given
        time.sleep(60)
        search = requests.post(query_url,auth=(cip_access_id, cip_access_key), json=search)
    else:
        print(search.text)
        print('There was an error while creating a search job.')    
    return search_id

def check(search_id):
    search_status = 'STARTED'
    gathering = True
    while gathering:
        if search_status != 'DONE GATHERING RESULTS':
            check_url = check_base_url + search_id
            check = requests.get(check_url, auth=(cip_access_id, cip_access_key))
            search_status = check.json()['state']
        else:
            limit = 100
            offset = 0
            total_records = check.json()['recordCount']
            total_messages = check.json()['messageCount']
            if query_type == 'agg':
                while offset < total_records:
                    results_url = check_base_url + search_id + f'/records?offset={offset}&limit={limit}'
                    results = requests.get(results_url, auth=(cip_access_id, cip_access_key))
                    for r in results.json()['records']:
                        print(r['map'])
                    offset += 100    
            else:
                while offset < total_messages:
                    results_url = check_base_url + search_id + f'/messages?offset={offset}&limit={limit}'
                    results = requests.get(results_url, auth=(cip_access_id, cip_access_key))
                    for m in results.json()['messages']:
                        print(m['map']['_raw'])
                            
                    offset += 100
            
            gathering = False       

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, filename='./query.log')
    search_id = start()
    check(search_id)  