# TL;DR
- These scripts will all enrich Signals based on specific attributes in Signal/Record data
- filename indicates which attribute it will enrich based off of ex. http_url_rootDomain will look for 'http_url_rootDomain' + enrich when it exists

# Required environment variables
1. CSE_API_KEY
2. CSE_TENANT_NAME
3. VT_API_KEY 
4. HONEY_DB_ID
5. HONEY_DB_KEY

# Script Prerequisites 
* Hashes+http_url_rootDomain -> VirusTotal API Key - NOTE: you will want to use a premium key in production because the free key is limited to 4 API calls a minute 
* ip -> HoneyDB API Key 