#!/usr/bin/env python3
import requests
import os


# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']
headers = {'X-API-KEY': cse_api_key}
       
## VT enrichment config
vt_key = os.environ['VT_API_KEY']

hasNextPage = True
offset = 0

while hasNextPage:
    cse_signals= f'https://{cse_tenant_name}.portal.jask.ai/api/v1/signals?offset={offset}&limit=100&q=suppressed%3A"false"%20timestamp%3ANOW-7D..NOW'
    r = requests.get(cse_signals, headers=headers)
    signals = r.json()['data']['objects']
    for signal in signals:
        signal_id = signal['id']
        cse_enrichment_url_base = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/signals/{signal_id}/enrichments/'
        signal_link = f'https://{cse_tenant_name}.portal.jask.ai/signal/{signal_id}/enrichments'
            
        ## RECORD LEVEL ENRICHMENTS BASED ON ATTRIBUTES 
        for record in signal['allRecords']:

            ## ENRICHMENTS BASED ON ROOT DOMAIN 
            if 'http_url_rootDomain' in record:

                ## ENRICHMENT - Virus Total Domains
                domain = record['http_url_rootDomain']
                params = {'apikey': vt_key,'domain': domain}
                report = requests.get('https://www.virustotal.com/vtapi/v2/domain/report', params=params)
                if report.status_code >= 200 and report:
                    report = report.json()
                    enrichment = {"detail": report, "raw": "VirusTotal Enrichment"}
                    cse_enrichment_url = cse_enrichment_url_base + 'vt_domain_enrichment'
                    enrich = requests.put(cse_enrichment_url, headers=headers, json=enrichment)
                    print('VT Enriched') 
                    print(signal_link)    
                else:
                    response = report.text
                    print('VirusTotal API Call Failure: ' + response)     




    if r.json()['data']['hasNextPage'] != True:
        hasNextPage = False
    else:
        offset += 100                       
