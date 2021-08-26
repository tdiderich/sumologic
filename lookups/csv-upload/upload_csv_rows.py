#!/usr/bin/env python3
import os
import requests
import logging
from requests.auth import HTTPBasicAuth
import pandas

# environment variables
cip_access_id = os.environ["CIP_ACCESS_ID"]
cip_access_key = os.environ["CIP_ACCESS_KEY"]
cip_deployment = os.environ["CIP_DEPLOYMENT"]

# other variables
file = "/Users/tdiderich/repos/sumologic/lookups/csv-upload/sample.csv"
file_data = pandas.read_csv(file)
lookup_id = "00000000015C1E88"
url = f"https://api.{cip_deployment}.sumologic.com/api/v1/lookupTables/{lookup_id}/row"


def main():
    for row in range(len(file_data)):
        upload = {
            "row": [
                {"columnName": "domain", "columnValue": file_data["domain"][row]},
                {"columnName": "ip", "columnValue": file_data["ip"][row]},
            ]
        }
        r = requests.put(
            url, auth=HTTPBasicAuth(cip_access_id, cip_access_key), json=upload
        )
        print(r.status_code, r.text)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, filename="./fields.log")
    main()
