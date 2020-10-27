#!/usr/bin/env python
import requests
import json
import logging
import csv
from datetime import date, time, datetime, timedelta
import os

# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']

# other variables 
headers = {"X-API-KEY": cse_api_key}
suppress = False
dry = False
netblocks = []

### gets IPs from CSV ###
def get_netblock_list():
    # update this to be the name of your csv
    with open('./sample.csv') as netblock:
        netblock_csv = csv.DictReader(netblock)
        for row in netblock_csv:
            # csv headers MUST be "label" and "address_block"
            netblocks.append((row.get('label'), row.get('address_block')))

### uploads IPs from list ###
def upload_netblocks(dry, suppress):
    for block in netblocks:
        url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/network-blocks'
        payload = {
            "fields": {
                "addressBlock": str(block[1]).replace(' ', ''),
                "internal": True,
                "label": str(block[0]),
                "suppressesSignals": suppress
            }
        }
        if dry:
            print(payload)
        else:
            try:
                r = requests.post(url, headers=headers, json=payload)
                if r.status_code == 200:
                    logging.info(
                        block[0] + " added to match list with status code: " + str(r.status_code))
                else:
                    logging.error("Request to " + url +
                            " failed with status code: " + str(r.status_code) + " - Netblock/IP Range: " + block[1] + "|" + block[0])
            except requests.exceptions.RequestException as e:
                logging.error("Request to " + url +
                            " failed with status code: " + str(e) + "Netblock/IP Range: " + block[1] + "|" + block[0])            


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO,
                        filename='./netblock_import.log')
    get_netblock_list()
    upload_netblocks(dry, suppress)
