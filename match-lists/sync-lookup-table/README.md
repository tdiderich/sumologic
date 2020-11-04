# TL;DR
- This script syncs a CIP lookup table with a CSE match list

# Required environment variables
1. CSE_API_KEY
2. CSE_TENANT_NAME
3. CIP_ACCESS_ID
4. CIP_ACCESS_KEY

# Script Prerequisites 
* Create CIP lookup table
1. Documentation: https://help.sumologic.com/05Search/Lookup_Tables/01_Create_a_Lookup_Table
2. You will also need the path to the lookup table to create a query ex. cat shared/supicious_countries
3. Input this value into the script ex. cip_query = 'cat shared/supicious_countries'

* Create CSE Match List: https://help.sumologic.com/Cloud_SIEM_Enterprise/Match_Lists/Create_a_Match_List
1. You will then need the list id from the url after you click into the match list ex. The listId=67 attribute is what we want here: https://[tenant].portal.jask.ai/content/match-lists?listId=67&offset=0&sorts=value
2. Input this value into the script ex. cse_list_id = '67'

* Set field to use as the value for your matchlist 
1. You query will return the results, and you need to set which field should be used for the match list value
2. Input this value into the script ex. field_for_matchlist = 'country'