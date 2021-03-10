import os
import requests
from ratelimit import limits, sleep_and_retry
import datetime

# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_headers = {'X-API-KEY': cse_api_key}
cse_tenant_name = os.environ['CSE_TENANT_NAME']
headers = {'X-API-KEY': cse_api_key}
       
## haveibeenpwned config 
hibp_key = os.environ['HIBP_API_KEY']
hibp_headers = {'hibp-api-key': hibp_key}
days_back = 180 

# don't touch 
hasNextPage = True
offset = 0

def days_between(date):
    now = datetime.datetime.now()
    breach_date = datetime.datetime.strptime(date[0:-1], "%Y-%m-%dT%H:%M:%S")
    return abs((now - breach_date).days)

@sleep_and_retry
@limits(calls=1, period=1)
def full_report(name):
    more = requests.get(f'https://haveibeenpwned.com/api/v3/breach/{name}', headers=hibp_headers)
    if more.status_code == 200: 
        date = more.json()['AddedDate']
        diff = days_between(date)
        if diff < days_back:
            return more.json()
        else:
            return None    

@sleep_and_retry
@limits(calls=1, period=1)
def enrich(record):
    account = record['user_username_raw']
    report = requests.get(f'https://haveibeenpwned.com/api/v3/breachedaccount/{account}', headers=hibp_headers)
    if report.status_code == 200 and report:
        report = report.json()
        for pwn in report:
            name = pwn['Name']
            more = full_report(name)
            if more: 
                enrichment = {'detail': more, 'raw': name}
                enrich = requests.put(cse_enrichment_url + name, headers=cse_headers, json=enrichment)
                return enrich
            else:
                return None    
    else:
        return None


while hasNextPage:
    cse_signals= f'https://{cse_tenant_name}.portal.jask.ai/api/v1/signals?offset={offset}&limit=100&q=suppressed%3A"false"%20timestamp%3ANOW-15m..NOW'
    r = requests.get(cse_signals, headers=cse_headers)
    signals = r.json()['data']['objects']
    for signal in signals:
        signal_id = signal['id']
        cse_enrichment_url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/signals/{signal_id}/enrichments/'
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