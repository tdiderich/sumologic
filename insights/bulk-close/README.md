# TL;DR
- This script closes all Insights based on a query and adds a comment for reasoning

# Required environment variables
1. CSE_API_KEY
2. CSE_TENANT_NAME

# Script Prerequisites 
* Create query
1. Go to the Insights page in CSE
2. Use the UI to create the filter you'd like to use to close Insights 
3. Copy the section of the URI between the q= and &sorts
- Ex. https://content.portal.jask.ai/insights?offset=0&q=-status%3A%22closed%22%20assignee%3Anull&sorts=-timestamp&view=list
- You would take this -> -status%3A%22closed%22%20assignee%3Anull

* Update comment 
1. Update the stock comment to better explain why you're closing the Insights