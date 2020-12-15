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
1. Clone this repository
```
git clone https://github.com/tdiderich/sumologic.git
```
2. Clone .env_sample to .env under the same directory
```
cp .env_sample .env
```
3. Update all of the secrets needed based on the script you'd like to run (NOTE: you need to rerun pipenv shell anytime you update these values to reload them)
```
# SUMO CONFIG PARAMETERS 
cse_api_key = 'ADD_ME'
cse_tenant_name = 'ADD_ME'
cip_access_id 'ADD_ME'
cip_access_key = 'ADD_ME'

# THIRD PARTY CONFIG PARAMETERS
vt_api_key = 'ADD_ME'
```
4. Create pip environment
```
pipenv --three
```
5. Install dependancies
```
pipenv install
```
6. Enter pipenv
```
pipenv shell
```
7. Run scripts
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
1. SOC Funnel Metrics

### Entities

### Signals

### Insights

### CIP Script Sources
1. CSE Audit Log
2. CSE Rules
3. CSE Custom Insights

### CSE and CIP Sync

### Rules

### Threat Intelligence
1. Import from CSV

### Match Lists

### Network Blocks
1. Import from CSV
2. List and Search Netblocks
