#!/usr/bin/env python3
import requests
import os
from ratelimit import limits, sleep_and_retry


# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']
headers = {'X-API-KEY': cse_api_key}
       
## VT enrichment config
vt_key = os.environ['VT_API_KEY']

hasNextPage = True
offset = 0

@sleep_and_retry
@limits(calls=3, period=60)
def handle_hash(file_hash):
    ## ENRICHMENT - Virus Total File Hash
    params = {'apikey': vt_key,'resource': file_hash}
    try:
        report = requests.get('https://www.virustotal.com/vtapi/v2/file/report', params=params)
    except:
        print('failed to query VT')
    if report.status_code == 200 and report.json():
        if 'positives' in report.json():
            report = report.json()
            enrichment = {"detail": report, "raw": "VirusTotal Enrichment"}
            cse_enrichment_url = cse_enrichment_url_base + 'vt_file_hash_enrichment'
            enrich = requests.put(cse_enrichment_url, headers=headers, json=enrichment)
            if enrich.status_code == 200:
                print('VT Enriched') 
                print(signal_link)  
            else:
                print('Err enriching Signal')    
            if report['positives'] > 0:
                ## insert logic here for positive hits 
                ## just passing it for now 
                pass
    else:
        response = report.text
        print('VirusTotal API Call Failure: ' + response)  

while hasNextPage:
    if offset > 9999:
        hasNextPage = False
        print('Hit max offset of 10k')
    else:
        cse_signals= f'https://{cse_tenant_name}.portal.jask.ai/api/v1/signals?offset={offset}&limit=100&q=suppressed%3A"false"%20timestamp%3ANOW-14D..NOW'
        r = requests.get(cse_signals, headers=headers)
        signals = r.json()['data']['objects']
        for signal in signals:
            signal_id = signal['id']
            cse_enrichment_url_base = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/signals/{signal_id}/enrichments/'
            signal_link = f'https://{cse_tenant_name}.portal.jask.ai/signal/{signal_id}/enrichments'
                
            ## RECORD LEVEL ENRICHMENTS BASED ON ATTRIBUTES 
            for record in signal['allRecords']:
                file_hash = None
                ## ENRICHMENTS BASED ON FILE HASHES  
                if 'file_hash_md5' in record:
                    file_hash = record['file_hash_md5']
                elif 'file_hash_sha1' in record: 
                    file_hash = record['file_hash_sha1']
                elif 'file_hash_sha256' in record:
                    file_hash = record['file_hash_sha256']

                if file_hash:
                    handle_hash(file_hash)   

        if r.json()['data']['hasNextPage'] != True:
            hasNextPage = False
        else:
            offset += 100                       
