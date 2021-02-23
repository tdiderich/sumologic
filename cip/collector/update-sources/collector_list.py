#!/usr/bin/env python3
import os
from os import walk
import requests
import json
from requests.auth import HTTPBasicAuth

# environment variables
cip_access_id = os.environ['CIP_ACCESS_ID']
cip_access_key = os.environ['CIP_ACCESS_KEY']
cip_deployment = os.environ['CIP_DEPLOYMENT']

# update these
collector_list = []

# get JSON from UI
sources = {
  "api.version":"v1",
  "sources":[]
}

for collector in collector_list:
    source_url = f'https://api.{cip_deployment}.sumologic.com/api/v1/collectors/{collector}/sources'
    for source in sources['sources']:
        source = {"source": source}
        r = requests.post(source_url, auth=HTTPBasicAuth(cip_access_id, cip_access_key), json=source)
        print(r.text)