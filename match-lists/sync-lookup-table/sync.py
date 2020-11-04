#!/usr/bin/env python3
'''
This script will run a CIP query using the search job API + update a match list in CSE with those results. 
'''
import os
import json
import requests
import time
import datetime
import logging
from sumologic import SumoLogic 

# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']
cip_access_id = os.environ['CIP_ACCESS_ID']
cip_access_key = os.environ['CIP_ACCESS_KEY']

# other variables
cse_list_id = '<cse_list_id>'
cip_query = '<cip_query>'
field_for_matchlist = '<field_for_matchlist>'

# only change if your region is not us2
sumo_api_url = 'https://api.us2.sumologic.com/api/v1/'

# do not touch
delay = 5
cse_url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/match-lists/{cse_list_id}/items'
cse_headers = {'X-API-KEY': cse_api_key}


def main():
    timezone        = 'America/New_York'

    # Flag to use the by receipt time (_receiptTime), instead of the by message time (_messageTime) [default: 'false']
    byReceiptTime   = 'false'

    # Getting the current timestamp, in epoch format
    date_to =	 datetime.datetime.now().strftime('%s')

    # Getting the current timestamp, minus the delta hours, in epoch format
    date_from =  datetime.datetime.now() - datetime.timedelta(hours = 24)
    date_from =  date_from.strftime('%s')
    
    # Defining new Sumo Logic search job object
    sumo = SumoLogic(cip_access_id, cip_access_key)
   
    # Creating the search job
    search = sumo.search_job(cip_query, date_from, date_to, timezone, byReceiptTime)

    # Verifying the status of the search job
    status = sumo.search_job_status(search)

    while status['state'] != 'DONE GATHERING RESULTS':
        if status['state'] == 'CANCELLED':
            break
        time.sleep(delay)
        status = sumo.search_job_status(search)

        '''
        Section to handle messages
        '''
        if status['state'] == 'DONE GATHERING RESULTS':

            # get results of cat on lookup table
            count = status['messageCount']
            limit = count if count < 1000 and count != 0 else 1000 # compensate bad limit check
            results = sumo.search_job_messages(search, limit=limit)
            messages = results['messages']

            # set parameters for uploading to CSE
            batch_size = 25
            expiration = (datetime.datetime.now() + datetime.timedelta(days=30)
                      ).strftime('%Y-%m-%dT%H:%M:%SZ')

            # uploading to CSE in batches of 25
            for i in range(0, len(messages), batch_size):
                batch = messages[i:i+batch_size]
                items = {'items': []}
                for message in batch:
                    record = message['map']
                    items['items'].append({
                                            'active': True,
                                            'description': 'Automated update.',
                                            'expiration': expiration,
                                            'value': record[field_for_matchlist]
                                            }) 
                r = requests.post(url=cse_url, headers=cse_headers, json=items)                                        
                if r.status_code > 201:
                    error = r.text
                    status_code = r.status_code
                    logging.error(f'Status Code: {status_code}')
                    logging.error(f'Error uploading items: {error}')
                else:
                    logging.info('Submitted 25 match list values.')
                    pass


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, filename='./match_list_sync.log')
    main()