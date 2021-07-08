# TL;DR
- This script provides tuning recommendations using the noisy entity and log reduce methods 

1. Noisy Entity - simple count on entity per rule where the Entity had > 1000 hits
2. Log Reduce - uses Sumo Logic's Log Reduce operator to identify outliers based on common tuning fields 

# Required environment variables
1. CIP_ACCESS_KEY
2. CIP_ACCESS_ID
3. CIP_DEPLOYMENT

# Script Prerequisites 
* CSE Signals must be in CIP under the asoc/SIGNAL/* _sourceCategory
1. This is a hard coded _sourceCategory when the Signals are forwarded to CIP, so you just need to make sure forwarding is enabled

# Sample Output
```
$ python3 get_recommendations.py 

--- Gathering Tuning Recommendations for neha-p2-content-cse-long ---

--- Top Entities ---

{'_count': '50400', 'entity': 'my-host'}

--- Top Clusters ---

action = null : (50,400, 100.0%)
entity = my-host : (50,400, 100.0%)
listmatches = [] : (50,400, 100.0%)
http_url_rootdomain = null : (50,400, 100.0%)
user_username = null : (50,400, 100.0%)
device_hostname = my-host : (50,400, 100.0%)
commandline = null : (50,400, 100.0%)
parentbaseimage = null : (50,400, 100.0%)
device_ip = null : (50,400, 100.0%)
baseimage = null : (50,400, 100.0%)


--- Gathering Tuning Recommendations for Search ---

--- Top Entities ---

{'_count': '3360', 'entity': 'my-host'}

--- Top Clusters ---

action = null : (3,360, 100.0%)
entity = my-host : (3,360, 100.0%)
listmatches = [] : (3,360, 100.0%)
http_url_rootdomain = null : (3,360, 100.0%)
user_username = null : (3,360, 100.0%)
device_hostname = my-host : (3,360, 100.0%)
commandline = null : (3,360, 100.0%)
parentbaseimage = null : (3,360, 100.0%)
device_ip = null : (3,360, 100.0%)
baseimage = null : (3,360, 100.0%)
```