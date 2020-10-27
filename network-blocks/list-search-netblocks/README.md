# TL;DR
- This script can be used to list and search your network blocks

# Required environment variables
1. CSE_API_KEY
2. CSE_TENANT_NAME

# Script Prerequisites 
* In order to search, you need to update a couple of variables
1. Search - set to True
2. cidr_list - set to list of cidr blocks you'd like to search on
3. label_list - set to list of labels you'd like to search for

* You can disable the "LIST OF NETBLOCKS" option as by setting list_blocks to False

# Sample Output
```
SEARCH RESULTS
Found matching CIDR block for sf: 10.152.0.0/22
No netblocks with the label: foo
Found matching label for 10.152.0.0/22: sf
No netblocks with the CIDR block: 127.0.0.1
END SEARCH RESULTS

LIST OF NETBLOCKS
10.1.1.0/24 - SpecOps Analysis Lab - Management Net
10.1.10.0/24 - SpecOps Analysis Lab - VPN Client Address Pool
10.99.17.0/24 - SpecOps Analysis Lab - Sandnet-Public Net
10.99.18.0/24 - SpecOps Analysis Lab - Sandnet Net
10.99.19.0/24 - SpecOps Analysis Lab - Brain Lab Net
```