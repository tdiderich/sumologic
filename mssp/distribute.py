import requests
from requests.auth import HTTPBasicAuth
import json
import glob

def get_rule_uri(f):
    if 'triggerExpression' in f['fields'].keys():
        uri = 'rules/aggregation'
        return uri
    elif 'expressionsAndLimits' in f['fields'].keys():
        uri = 'rules/chain'
        return uri
    elif 'limit' in f['fields'].keys():
        uri = 'rules/threshold'
        return uri
    else:
        uri = 'rules/templated'
        return uri

def handle_deletes(rules, deployment, org_id, access_id, access_key):
    base_url = f'https://api.{deployment}.sumologic.com/api/sec/v1/'
    custom_rules_url = base_url + 'rules?q=ruleSource%3A"user"'
    get_custom_rules = requests.get(custom_rules_url, auth=HTTPBasicAuth(access_id, access_key))
    all_custom_rules = get_custom_rules.json()['data']['objects']
    for rule in all_custom_rules:
        if rule['name'] not in rules:
            id = rule['id']
            delete_url = base_url + f'rules/{id}'
            delete_rule = requests.delete(delete_url, auth=HTTPBasicAuth(access_id, access_key))
            if delete_rule.status_code > 202:
                print(delete_rule.text)
            else:
                print('deleted rule -> ', rule['name'])

def handle_rules(files, deployment, org_id, access_id, access_key):
    base_url = f'https://api.{deployment}.sumologic.com/api/sec/v1/'
    rules = list()
    for file in files:
        f=open(file, 'r')
        f=json.loads(f.read())
        rule_name = f['fields']['name']
        rules.append(rule_name)
        org_ids = f['orgIds']
        uri = get_rule_uri(f)
        for org in org_ids:
            if org == 'global' or org == org_id:
                check_url = base_url + f'rules?q=name%3A"{rule_name}"'
                r = requests.get(check_url, auth=HTTPBasicAuth(access_id, access_key))
                if r.status_code < 400:
                    total = r.json()['data']['total']
                    matches = r.json()['data']
                    payload = f
                    del payload['orgIds']
                    if total > 0:
                        id = matches['objects'][0]['id']
                        update_url = base_url + uri + f'/{id}'
                        del payload['fields']['enabled']
                        update = requests.put(update_url, auth=HTTPBasicAuth(access_id, access_key), json=payload)
                        if update.status_code > 202:
                            print(update.text)
                        else:
                            print(f'updated {id} on {org_id}')
                    else:
                        add_url = base_url + uri
                        add = requests.post(add_url, auth=HTTPBasicAuth(access_id, access_key), json=payload)
                        if add.status_code > 202:
                            print(add.status_code)
                        else:
                            print(f'added {uri} to {org_id}')

                else:
                    print(r.text)
    return rules

if __name__ == '__main__':
    path = './rules/*.json'   
    files=glob.glob(path)  
    with open('./config.json') as f:
        config = json.load(f)
    for customer in config:
        rules = handle_rules(files, customer['deployment'], customer['orgId'], customer['accessId'], customer['accessKey'])
        handle_deletes(rules, customer['deployment'], customer['orgId'], customer['accessId'], customer['accessKey'])