#!/usr/bin/env python3
import requests
import os
from ratelimit import limits, sleep_and_retry


# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']
headers = {'X-API-KEY': cse_api_key}
       
## honey db enrichment config
honey_key = os.environ['HONEY_DB_KEY']
honey_id = os.environ['HONEY_DB_ID']
honey_headers = {'X-HoneyDb-ApiId': honey_id, 'X-HoneyDb-ApiKey': honey_key}

hasNextPage = True
offset = 0

def handle_ip(ip, ip_type):
    honey_url = f'https://honeydb.io/api/ipinfo/{ip}'
    try:
        report = requests.get(honey_url, headers=honey_headers)
    except:
        print('failed to query honey db')
    if report.status_code == 200 and report.json():
        report = report.json()
        print(report)
        enrichment = {"detail": report, "raw": f'HoneyDB {ip_type} Enrichment'}
        cse_enrichment_url = cse_enrichment_url_base + ip_type
        enrich = requests.put(cse_enrichment_url, headers=headers, json=enrichment)
        if enrich.status_code == 200:
            print('Signal Enriched') 
            print(signal_link)  
        else:
            print('Err enriching Signal') 
               
    else:
        response = report.text
        print('HoneyDB API Call Failure: ' + response)  

while hasNextPage:
    if offset > 9999:
        hasNextPage = False
        print('Hit max offset of 10k')
    else:
        cse_signals= f'https://{cse_tenant_name}.portal.jask.ai/api/v1/signals?offset={offset}&limit=100&q=suppressed%3A"false"%20timestamp%3ANOW-7D..NOW'
        r = requests.get(cse_signals, headers=headers)
        signals = r.json()['data']['objects']
        for signal in signals:
            signal_id = signal['id']
            cse_enrichment_url_base = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/signals/{signal_id}/enrichments/'
            signal_link = f'https://{cse_tenant_name}.portal.jask.ai/signal/{signal_id}/enrichments'
                
            ## RECORD LEVEL ENRICHMENTS BASED ON ATTRIBUTES 
            for record in signal['allRecords']:

                device_ip = None
                srcDevice_ip = None
                dstDevice_ip = None

                ## ENRICHMENTS BASED ON IPS SEEN
                if 'device_ip' in record:
                    device_ip = record['device_ip']
                    handle_ip(device_ip, 'device_ip') 
                
                if 'srcDevice_ip' in record: 
                    srcDevice_ip = record['srcDevice_ip']
                    handle_ip(srcDevice_ip, 'srcDevice_ip') 
                
                if 'dstDevice_ip' in record:
                    dstDevice_ip = record['dstDevice_ip']
                         

        if r.json()['data']['hasNextPage'] != True:
            hasNextPage = False
        else:
            offset += 100                       
