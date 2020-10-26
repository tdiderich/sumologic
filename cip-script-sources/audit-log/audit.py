#!/usr/bin/env python3
import json
import requests
import logging
import datetime
from datetime import date, time, timedelta, datetime


logging.basicConfig(
    level=logging.INFO,
    format='%(message)s'
)

# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']

# request headers
headers = {'X-API-KEY': cse_api_key}


def main():
    hasNextPage = True
    offset = 0
    start_date = (datetime.utcnow() - timedelta(hours=1)
                  ).strftime('%Y-%m-%dT%H:%M:%SZ')
    now = (datetime.utcnow()).strftime('%Y-%m-%dT%H:%M:%SZ')
    while hasNextPage:
        try:
            url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/audit-logs?startTimestamp={start_date}&endTimestamp={now}&offset={offset}&limit=100'
            r = requests.get(url, headers=headers)
        except Exception as e:
            logging.critical("{{\"error\": \"{}\"}}".format(e))
            exit()
        if r.status_code != 200:
            logging.critical("{{\"error\": \"{}\"}}".format(r.status_code))
            exit()
        audit = r.json()

        for log in audit['data']['objects']:
            if log['path'] != '/internal/alert':
                if log['actingUsername'] is not None and log['actionType'] != 'post_items':
                    # logging.info(json.dumps(rule))
                    print(json.dumps(log))

        if audit['data']['hasNextPage'] != True:
            hasNextPage = False
        else:
            offset += 100    


if __name__ == '__main__':
    main()
