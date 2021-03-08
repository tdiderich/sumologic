import os
import requests
from ratelimit import limits, sleep_and_retry

# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_headers = {'X-API-KEY': cse_api_key}
cse_tenant_name = os.environ['CSE_TENANT_NAME']
headers = {'X-API-KEY': cse_api_key}
       
## VT enrichment config
hibp_key = os.environ['HIBP_API_KEY']
hibp_headers = {'hibp-api-key': hibp_key}

hasNextPage = True
offset = 0

@sleep_and_retry
@limits(calls=1, period=2)
def enrich(record):
    account = record['user_username_raw']
    report = requests.get(f'https://haveibeenpwned.com/api/v3/breachedaccount/{account}', headers=hibp_headers)
    if report.status_code == 200 and report:
        report = report.json()
        enrichment = {'detail': report, 'raw': 'haveibeenpwned'}
        enrich = requests.put(cse_enrichment_url, headers=cse_headers, json=enrichment)
        return enrich
    else:
        return None


while hasNextPage:
    cse_signals= f'https://{cse_tenant_name}.portal.jask.ai/api/v1/signals?offset={offset}&limit=100&q=suppressed%3A"false"%20timestamp%3ANOW-100m..NOW'
    r = requests.get(cse_signals, headers=cse_headers)
    signals = r.json()['data']['objects']
    for signal in signals:
        signal_id = signal['id']
        cse_enrichment_url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/signals/{signal_id}/enrichments/haveibeenpwned'
        signal_link = f'https://{cse_tenant_name}.portal.jask.ai/signal/{signal_id}'
        for record in signal['allRecords']:
            if 'user_username_raw' in record:
                enriched = enrich(record)
                if enriched and enriched.status_code == 200:
                    print('Enriched: ', signal_link)
                elif enriched:
                    print('Failed to enrich Signal. Status code: ', enriched.status_code)    
                else:
                    print('Nothing found in the haveibeenpwned database for: ', record['user_username_raw'])    

    if r.json()['data']['hasNextPage'] != True:
        hasNextPage = False
    else:
        offset += 100