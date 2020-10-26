# Sumo Logic Script HUB

## Background
* Configuration Explained
- There is a sample config file called sample_config.py under the root folder of this project
- You will clone this file and create one called config.py where you actually input all of your secrets (API Keys + Access Key Pairs)
* Parameters - explainations of what you see in sample_config.py
- cse_api_key - Sumo Logic Cloud SIEM Enterprise API Key
- cse_tenant_name - Sumo Logic Cloud SIEM Enterprise Tenant Name (https://{YOUR_TENANT_NAME}.jask.portal.ai)
- cip_access_id - Sumo Logic Continuous Intelligence Platform Access ID
- cip_access_key - Sumo Logic Continuous Intelligence Platform Access Key
- vt_api_key - VirusTotal API Key. Enterprise is recommended since these scripts DO NOT monitor for API call limitations with the persomal key. 
* Requirements (Global)
- Python 3.8+
- pipenv - https://pypi.org/project/pipenv/

## Getting Started
1. Clone sample_config.py to config.py under the same directory
2. Update all of the secrets needed based on the script you'd like to run
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

### Entities

### Signals

### Insights

### CIP Script Sources

### CSE and CIP Sync

### Rules

### Threat Intelligence

### Match Lists

### Network Blocks
