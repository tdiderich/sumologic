import os
import requests
import logging
from requests.auth import HTTPBasicAuth
from datetime import date, time, datetime, timedelta
import json

# environment variables
cip_access_id = os.environ['CIP_ACCESS_ID']
cip_access_key = os.environ['CIP_ACCESS_KEY']
cip_deployment = os.environ['CIP_DEPLOYMENT']

# variables to not touch 
query_url = f'https://api.{cip_deployment}.sumologic.com/api/v1/search/jobs'
check_base_url = f'https://api.{cip_deployment}.sumologic.com/api/v1/search/jobs/'

def start(query, lookback):
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

def check(search_id, query_type):
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
            check = requests.get(check_url, auth=(cip_access_id, cip_access_key))
            total_records = check.json()['recordCount']
            total_messages = check.json()['messageCount']
            if query_type == 'agg':
                records = list()
                while offset < total_records:
                    results_url = check_base_url + search_id + f'/records?offset={offset}&limit={limit}'
                    results = requests.get(results_url, auth=(cip_access_id, cip_access_key))
                    for r in results.json()['records']:
                        records.append(r['map'])
                    offset += 100 
                return records   
            else:
                messages = list()
                while offset < total_messages:
                    results_url = check_base_url + search_id + f'/messages?offset={offset}&limit={limit}'
                    results = requests.get(results_url, auth=(cip_access_id, cip_access_key))
                    for m in results.json()['messages']:
                        messages.append(m['map']['_raw'])
                    offset += 100
                return messages
            
            gathering = False    


if __name__ == '__main__':

    # variables to update
    top_10_query='_sourceCategory=asoc/SIGNAL/* | json field=_raw "rule_name" | count by rule_name | order by _count | limit 10'
    lookback = 10080 # minutes in week
    query_type = 'agg' # agg OR raw 
    
    # get top 10
    search_id = start(top_10_query, lookback)
    top_10_rules = check(search_id, query_type)

    # loop through top ten to get top ten entities + tuning clusters 
    for rule in top_10_rules:
        rule_name = rule['rule_name']
        print(f'\n--- Gathering Tuning Recommendations for {rule_name} ---')

        # get top entities 
        ## must have >1000 hits 
        tuning_entities_query = f'_sourceCategory=asoc/SIGNAL/* "{rule_name}" | json field=_raw "rule_name" nodrop | where rule_name = "{rule_name}" | json field=_raw "asset.name" as entity nodrop | count entity | where _count > 1000 | order by _count | limit 10'
        entities_search_id = start(tuning_entities_query, lookback)
        top_entities = check(entities_search_id, query_type)
        if len(top_entities) > 0:
            print(f'\n--- Top Entities ---\n')
            for e in top_entities:
                print(e)
        else:
            print(f'\n--- No Entities Found with Over 1000 Hits ---\n')
        
        # get clusters
        ### clusters look for patterns with the logreduce based on common fields used for tuning 
        ### fields used -> entity, baseImage, parentBaseImage, action, commandLine, listMatches, user_username, device_hostname, device_ip, http_url_rootDomain
        tuning_clusters_query = f'_sourceCategory=asoc/SIGNAL/* {rule_name} | json field=_raw "rule_name" nodrop | where rule_name = "{rule_name}" | json field=_raw "asset.name" as entity nodrop | json field=_raw "full_records[0].baseImage" as baseImage nodrop | json field=_raw "full_records[0].parentBaseImage" as parentBaseImage nodrop | json field=_raw "full_records[0].action" as action nodrop | json field=_raw "full_records[0].commandLine" as commandLine nodrop | json field=_raw "full_records[0].listMatches" as listMatches nodrop | json field=_raw "full_records[0].user_username" as user_username nodrop | json field=_raw "full_records[0].device_hostname" as device_hostname nodrop | json field=_raw "full_records[0].device_ip" as device_ip nodrop | json field=_raw "full_records[0].http_url_rootDomain" as http_url_rootDomain nodrop | logreduce values on entity, action, listMatches, baseImage, parentBaseImage, commandLine, user_username, device_hostname, device_ip, http_url_rootDomain | order by _count | limit 10'
        clusters_search_id = start(tuning_clusters_query, lookback)
        clusters = check(clusters_search_id, query_type)
        if len(clusters) > 0:
            print(f'\n--- Top Clusters ---\n')
            for c in clusters:
                print(c['_signature'])
        else:
            print(f'\n--- No Relevant Clusters Found ---\n')