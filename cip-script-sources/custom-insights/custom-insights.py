#!/usr/bin/env python3
import json
import requests
import logging


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
    while hasNextPage:
        try:
            url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/custom-insights?offset=' + str(offset) + '&limit=100'
            r = requests.get(url, headers=headers)
        except Exception as e:
            logging.critical("{{\"error\": \"{}\"}}".format(e))
            exit()
        if r.status_code != 200:
            logging.critical("{{\"error\": \"{}\"}}".format(r.status_code))
            exit()
        rules = r.json()

        for rule in rules['data']['objects']:
            logging.info(json.dumps(rule))

        if rules['data']['hasNextPage'] != True:
            hasNextPage = False
        else:
            offset += 100    


if __name__ == "__main__":
    main()
