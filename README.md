# Sumo Logic Script HUB

## Background
**Requirements (Global)**
1. Python 3.8+
2. pipenv - https://pypi.org/project/pipenv/

**Configuration Explained**
1. There is a sample environment variables file called .env_sample under the root folder of this project
2. You will clone this file and create one called .env where you actually input all of your secrets (API Keys + Access Key Pairs)

**Parameters - explainations of what you see in .env_sample**
1. CSE_API_KEY - Sumo Logic Cloud SIEM Enterprise API Key
2. CSE_TENANT_NAME - Sumo Logic Cloud SIEM Enterprise Tenant Name (https://{YOUR_TENANT_NAME}.jask.portal.ai)
3. CIP_ACCESS_ID - Sumo Logic Continuous Intelligence Platform Access ID
4. CIP_ACCESS_KEY - Sumo Logic Continuous Intelligence Platform Access Key
5. VT_API_KEY - VirusTotal API Key. Enterprise is recommended since these scripts DO NOT monitor for API call limitations with the persomal key. 

## Getting Started
1. Clone .env_sample to .env under the same directory
```
cp .env_sample .env
```
2. Update all of the secrets needed based on the script you'd like to run (NOTE: you need to rerun pipenv shell anytime you update these values to reload them)
```
# SUMO CONFIG PARAMETERS 
cse_api_key = 'ADD_ME'
cse_tenant_name = 'ADD_ME'
cip_access_id 'ADD_ME'
cip_access_key = 'ADD_ME'

# THIRD PARTY CONFIG PARAMETERS
vt_api_key = 'ADD_ME'
```
3. Create pip environment
```
pipenv --three
```
4. Install dependancies
```
pipenv install
```
5. Enter pipenv
```
pipenv shell
```
6. Run scripts
```
python3 foo/bar.py
```

## Script Sections
1. [Metrics](#metrics)
2. [Entities](#entities)
3. [Signals](#signals)
4. [Insights](#insights)
5. [CIP Script Sources](#cip-script-sources)
6. [CSE and CIP Sync](#cse-and-and-cip-sync)
7. [Rules](#rules)
8. [Threat Intelligence](#hreat-intelligence)
9. [Match Lists](#match-lists)
10. [Network Blocks](#network-blocks)

### Metrics
1. Funnel Metrics
- This script gives you funnel metrics for your data flow (Records, Signals, and Insights)
- Your output will look something like this
```
Getting funnel metrics for: content
Date Range: 2020-09-01T00-2020-09-30T00
Record count: 1655022
Signal count: 83531
Insight count: 7
```

### Entities

### Signals

### Insights

### CIP Script Sources

### CSE and CIP Sync

### Rules

### Threat Intelligence
1. Import From CSV
- This is a simple script that imports IOCs from a CSV file. It uploads the data in batches of 25 and will take a couple seconds per upload. 

### Match Lists

### Network Blocks
