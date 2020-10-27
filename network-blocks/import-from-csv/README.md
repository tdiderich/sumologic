# TL;DR
- This script imports a CSV of network blocks into CSE for tagging IP address location

# Required environment variables
1. CSE_API_KEY
2. CSE_TENANT_NAME

# Script Prerequisites 
* CSV with proper headers (see sample.csv)
1. The script expects a CSV with "label" and "address_block" headers
2. The "label" is your description of the network block
3. The "address_block" is the CIDR block for the IP range

* There are 2 extra parameters you can change but are both set to False by default
1. Suppress - this will suppress all Signals in CSE where there is a match on the netblock. Use with caution as this is only needed in special cases like with a vulnerability scanning netblock. 
2. Dry - this will invoke a dry run that just prints the payload that would be uploaded. 
```
suppress = False
dry = False
```