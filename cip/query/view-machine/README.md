# TL;DR
- This script will load a view efficiently up to X number of days back

# Required environment variables
1. CSE_API_KEY
2. CSE_TENANT_NAME
3. CIP_DEPLOYMENT

# Script Prerequisites 
* days_back variable
1. How many days back do you want to load this view for?

* query variable
1. This query needs to have a _timeslice in it to properly create the view
```
_sourceCategory-"foo"
| timeslice 1d
| count
| save view foo_view
```

# Limitations
1. There is essentially no error handling in this script, so beware of rate limiting and other issues 