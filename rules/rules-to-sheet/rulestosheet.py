import json
import requests
import logging
import pandas as pd 
import re
import os

# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']
headers = {'X-API-KEY': cse_api_key}

## custom HTTP REQUESTS that logs errors
def make_request(url, headers):
    r = requests.get(url, headers=headers)
    if r.status_code != 200 and r.status_code != 201:
        status_code = r.status_code
        logging.error(f'{url} failed with status code {status_code}')
    else:
        return r

## this grabs the rules and sends them to the HTTP endpoint one at a time
def get_rules():
    hasNextPage = True
    offset = 0
    df = pd.DataFrame(columns=['RuleName', 'RuleDescription', 'RuleLogic'])
    while hasNextPage:
        url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/rules?&offset={offset}&limit=100'
        r = make_request(url, headers)
        for rule in r.json()['data']['objects']:
            row = dict()
            row['RuleName'] = rule.get('name', 'N/A')   
            row['RuleLogic'] = rule.get('expression', 'N/A')
            if 'expressionsAndLimits' in rule:
                row['RuleLogic'] = rule.get('expressionsAndLimits')[0].get('expression', 'N/A')
            if 'matchExpression' in rule:
                row['RuleLogic'] = rule.get('matchExpression', 'N/A')
            row['RuleDescription'] = rule.get('description', 'N/A')
            row['RuleDescription'] = rule.get('descriptionExpression', row['RuleDescription'])
            df = df.append(row, ignore_index=True) 
                     

        if (r.json()['data']['hasNextPage'] == True):
            hasNextPage = True
            offset += 100
        else:
            hasNextPage = False    
    
    df.to_csv('./rules.csv')                

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO,
                        filename='./rules_to_sheet.log')
    get_rules()