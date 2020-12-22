# TL;DR
- This script checks which fields are being used in FERs in CIP

# Required environment variables
1. CSE_API_KEY
2. CSE_TENANT_NAME
3. CIP_DEPLOYMENT

# Details 
* This script can be used to help you find unused Custom Fields in CIP, it works like this...
1. Grabs all Custom Fields
2. Grabs all FERs
3. Checks which Custom Fields are in which FERs
4. Creates 3 JSON blobs are writes them to separate files
    - results_all_fields.json - ALL fields - tracks a count of FERs each field is used in + creates a list of the FER names
    - results_used_fields.json - USED fields -  tracks a count of FERs each field is used in + creates a list of the FER names
    - results_unused_fields.json - UNUSED fields - count will always be 0 + FER list empty