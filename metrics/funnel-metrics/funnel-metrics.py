#!/usr/bin/env python3
import requests
import json
import logging
import os

# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']

# request headers
headers = {'X-API-KEY': cse_api_key}

# set times range
# can be changed but format needs to stay the same
startTimestamp = '2020-09-01T00'
endTimestamp = '2020-09-30T00'  # can be changed but format needs to stay the same
timezone = 'America/New_York'  # can be changed but format needs to stay the same

# create URLS based on the portal values + time ranges
event_url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/records/counts?startTimestamp={startTimestamp}&endTimestamp={endTimestamp}&bucketDuration=86400&timezone={timezone}'
signal_url =  f'https://{cse_tenant_name}.portal.jask.ai/api/v1/signals/counts?startTimestamp={startTimestamp}&endTimestamp={endTimestamp}&bucketDuration=86400&timezone={timezone}'
insight_url =  f'https://{cse_tenant_name}.portal.jask.ai/api/v1/insights/counts?startTimestamp={startTimestamp}&endTimestamp={endTimestamp}&bucketDuration=86400&timezone={timezone}'

# get record count
def get_record_sum(url, headers):
    initial_response = requests.get(url, headers=headers)
    event_sum = 0
    for count in initial_response.json()['data']:
        event_sum = event_sum + int(count['value'])

    print('Record count: ' + str(event_sum))

# get signal count
def get_signal_sum(url, headers):
    initial_response = requests.get(url, headers=headers)
    signal_sum = 0
    for count in initial_response.json()['data']:
        signal_sum = signal_sum + int(count['value'])

    print('Signal count: ' + str(signal_sum))

# get insight count
def get_insight_sum(url, headers):
    initial_response = requests.get(url, headers=headers)
    insight_sum = 0
    for count in initial_response.json()['data']:
        insight_sum = insight_sum + int(count['value'])

    print('Insight count: ' + str(insight_sum))

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO,
                        filename='./funnel_metrics.log')
    # print counts
    print('Getting funnel metrics for: ' + cse_tenant_name)
    print('Date Range: ' + startTimestamp + '-' + endTimestamp)
    get_record_sum(event_url, headers)
    get_signal_sum(signal_url, headers)
    get_insight_sum(insight_url, headers)