import os
import requests

# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']

# other variables 
headers = {"X-API-KEY": cse_api_key}
nextPage = True
blocks = dict()
offset = 0

# seach for block(s) that exist 
list_blocks = True
search = True
cidr_list = ['10.152.0.0/22', '127.0.0.1']
label_list = ['sf', 'foo']

while nextPage:
    url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/network-blocks?offset={offset}&limit=100'
    r = requests.get(url, headers=headers)

    for block in r.json()['data']['objects']:
        blocks[block['addressBlock']] = block['label']

    if (r.json()['data']['hasNextPage'] == True):
            hasNextPage = True
            offset += 100
    else:
        nextPage = False

if search:
    print('SEARCH RESULTS')
    for label in label_list:
        found = False
        for existing_cidr, existing_label in blocks.items():
            if label == existing_label:
                found = True
                print(f'Found matching CIDR block for {label}: {existing_cidr}')
        if found == False:
            print(f'No netblocks with the label: {label}')        
    for cidr in cidr_list:
        found = False
        for existing_cidr, existing_label in blocks.items():
            if cidr == existing_cidr:
                found = True
                print(f'Found matching label for {cidr}: {existing_label}') 
        if found == False:
            print(f'No netblocks with the CIDR block: {cidr}')
    print('END SEARCH RESULTS')

if list_blocks:
    print('LIST OF NETBLOCKS')
    for cidr, label in blocks.items():    
        print(f'{cidr} - {label}')    