# TL;DR
- This script grabs the CSE Audit Log data and can be used as a CIP Script Source in order to ingest it into CIP 
- You should run this HOURLY as it will grab an hour's worth of audit logs at a time

# Required environment variables
1. CSE_API_KEY
2. CSE_TENANT_NAME

# Sample Log
```
{
  "data": {
    "hasNextPage": true,
    "objects": [
      {
        "actingUsername": "string",
        "actionType": "string",
        "authMethod": "API_KEY_IN_AUTH_HEADER",
        "data": {},
        "httpMethod": "string",
        "path": "string",
        "statusCode": 0,
        "targetType": "string",
        "targets": {},
        "timestamp": "2020-10-26T22:26:59.304Z"
      }
    ],
    "total": 0
  }
}
```