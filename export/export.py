import requests
from datetime import date, time, datetime, timedelta
import os
from os import path
import json

# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']
headers = {'X-API-KEY': cse_api_key}

# other variables 
DAYS_BACK = 10

def get_insights(days_back):
    if not path.exists('insights'):
        os.mkdir('insights')
    hasNextPage = True
    first = True
    next_page_token = str()
    insight_count = 0
    query_day = (datetime.now() - timedelta(days=days_back)).strftime("%Y-%m-%d")
    insights = []
    while hasNextPage:
        if first:
            url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/insights/all?q=created%3A{query_day}%3A00'
            r = requests.get(url, headers=headers)
            first = False
        else:
            url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/insights/all?nextPageToken={next_page_token}'
            r = requests.get(url, headers=headers)
        if r.json()['data']['objects'] is not None:
            for insight in r.json()['data']['objects']:
                insights.append(insight)
                insight_count += 1
            if r.json()['data']['nextPageToken']:
                hasNextPage = True
                next_page_token = r.json()['data']['nextPageToken']
            else:
                hasNextPage = False
                filename = f'insights/{query_day}.json'
                with open(filename, 'w') as outfile:
                    json.dump(insights, outfile)
                print(f'Wrote {insight_count} Insights to {filename}...')   

def get_signals(days_back):
    if not path.exists('signals'):
        os.mkdir('signals')
    hasNextPage = True
    first = True
    next_page_token = str()
    signal_count = 0
    query_day = (datetime.now() - timedelta(days=days_back)).strftime("%Y-%m-%d")
    signals = []
    while hasNextPage:
        if first:
            url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/signals/all?q=suppressed%3A"false"%20created%3A{query_day}%3A00'
            r = requests.get(url, headers=headers)
            first = False
        else:
            url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/signals/all?nextPageToken={next_page_token}'
            r = requests.get(url, headers=headers)
        if r.json()['data']['objects'] is not None:
            for signal in r.json()['data']['objects']:
                signals.append(signal)
                signal_count += 1
            if r.json()['data']['nextPageToken']:
                hasNextPage = True
                next_page_token = r.json()['data']['nextPageToken']
            else:
                hasNextPage = False
                filename = f'signals/{query_day}.json'
                with open(filename, 'w') as outfile:
                    json.dump(signals, outfile)
                print(f'Wrote {signal_count} Signals to {filename}...')

if __name__ =='__main__':
    for x in range(DAYS_BACK):
        get_signals(x)
        get_insights(x)