# TL;DR
- This script pulls and prints Insights with record attributes

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

* add fields
1. Add all schema attributes in a comma separates list to the field variable 
2. All fields available listed here -> https://help.sumologic.com/Cloud_SIEM_Enterprise/CSE_Schema/01_Schema_Attributes