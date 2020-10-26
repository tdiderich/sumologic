import requests
import csv
import logging
import datetime
from datetime import date, time, timedelta, datetime
import json
import os
import itertools

# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']


# see README for explaination of this variable
source_id = '39'
expiration = (datetime.now() + timedelta(days=7)
                      ).strftime('%Y-%m-%dT%H:%M:%SZ') 

url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/threat-intel-sources/{source_id}/items'
headers = {'X-API-KEY': cse_api_key}

def chunked(it, size):
    it = iter(it)
    while True:
        p = tuple(itertools.islice(it, size))
        if not p:
            break
        yield p

def import_intel(filename):
    with open(filename, 'r') as iocs:
        iocs = csv.DictReader(iocs)
        iocs_dict = dict()
        for row in iocs:
            iocs_dict[row.get('value')] = row.get('description')    
        for chunk in chunked(iocs_dict.items(), 50):
            payload = dict()
            payload['indicators'] = []
            for key, value in chunk:
                payload["indicators"].append({
                            "active": True,
                            "description": value,
                            "expiration": expiration,
                            "value": key
                            })            
            r = requests.post(url, headers=headers, json=payload)
            if r.status_code > 201:
                error = r.text
                status_code = r.status_code
                logging.error(f'Status Code: {status_code}')
                logging.error(f'Error uploading IOCs: {error}')
            else:
                logging.info('Submitted 50 indicators.')
                pass
            
                


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO,
                        filename='./import_iocs.log')
    import_intel('./iocs.csv')
