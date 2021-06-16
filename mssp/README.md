# TL;DR
- This script syncs content to 1 or many Cloud SIEM tenants

# Script Prerequisites 
* config.json file
1. Clone the config_sample.json file and call it config.json
2. Add credentials for each tenant you'd like to keep in sync

* rules folder
1. Add rules to the rules folder that you would like to sync
2. Tag the org ids that you'd like each rule to sync to OR use global to sync to all

# Details on what happens
* Loops through each tenant in the config.json and does this...
1. Grabs all files under the rules folder and loops throught them
2. Uses the orgIds field to determine if that rule should be uploaded for the current tenant 
3. Checks if the rule already exists - if yes, updates the existing rule, if no, creates the rule 
4. Disbles all custom rules that are not in the folder to avoid duplication