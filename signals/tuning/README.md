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