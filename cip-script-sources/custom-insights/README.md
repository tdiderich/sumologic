# TL;DR
- This script grabs the CSE Custom Insights information and can be used as a CIP Script Source in order to ingest it into CIP 

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
        "created": "2020-10-26T22:28:37.572Z",
        "description": "string",
        "enabled": true,
        "id": "string",
        "lastUpdated": "2020-10-26T22:28:37.572Z",
        "name": "string",
        "ordered": true,
        "ruleIds": [
          "string"
        ],
        "severity": "HIGH",
        "tags": [
          "string"
        ]
      }
    ],
    "total": 0
  }
}
```