# TL;DR
- This script grabs the Rules from your CSE portal and can be used as a CIP Script Source in order to ingest it into CIP 

# Required environment variables
1. CSE_API_KEY
2. CSE_TENANT_NAME

# Sample Logs
```
{
  "data": {
    "hasNextPage": true,
    "objects": [
      {
        "assetField": "string",
        "category": "string",
        "contentType": "ANOMALY",
        "created": "2020-10-26T22:27:50.066Z",
        "createdBy": "string",
        "deleted": true,
        "description": "string",
        "enabled": true,
        "expression": "string",
        "id": "string",
        "isPrototype": true,
        "lastUpdated": "2020-10-26T22:27:50.066Z",
        "lastUpdatedBy": "string",
        "name": "string",
        "parentJaskId": "string",
        "ruleId": 0,
        "ruleSource": "string",
        "ruleType": "string",
        "score": 0,
        "signalCount07d": 0,
        "signalCount24h": 0,
        "status": {
          "message": "string",
          "status": "ACTIVE"
        },
        "stream": "string"
      },
      {},
      {
        "assetField": "string",
        "category": "string",
        "contentType": "ANOMALY",
        "countDistinct": true,
        "countField": "string",
        "created": "2020-10-26T22:27:50.066Z",
        "createdBy": "string",
        "deleted": true,
        "description": "string",
        "enabled": true,
        "expression": "string",
        "id": "string",
        "isPrototype": true,
        "lastUpdated": "2020-10-26T22:27:50.066Z",
        "lastUpdatedBy": "string",
        "limit": 0,
        "name": "string",
        "parentJaskId": "string",
        "ruleId": 0,
        "ruleSource": "string",
        "ruleType": "string",
        "score": 0,
        "signalCount07d": 0,
        "signalCount24h": 0,
        "status": {
          "message": "string",
          "status": "ACTIVE"
        },
        "stream": "string",
        "version": 0,
        "windowSize": 0
      },
      {
        "assetField": "string",
        "category": "string",
        "contentType": "ANOMALY",
        "created": "2020-10-26T22:27:50.066Z",
        "createdBy": "string",
        "deleted": true,
        "descriptionExpression": "string",
        "enabled": true,
        "expression": "string",
        "id": "string",
        "isPrototype": true,
        "lastUpdated": "2020-10-26T22:27:50.066Z",
        "lastUpdatedBy": "string",
        "name": "string",
        "nameExpression": "string",
        "parentJaskId": "string",
        "ruleId": 0,
        "ruleSource": "string",
        "ruleType": "string",
        "scoreMapping": {
          "default": 0,
          "field": "string",
          "mapping": [
            {
              "from": "string",
              "to": 0,
              "type": "string"
            }
          ],
          "type": "string"
        },
        "signalCount07d": 0,
        "signalCount24h": 0,
        "status": {
          "message": "string",
          "status": "ACTIVE"
        },
        "stream": "string"
      },
      {
        "assetField": "string",
        "category": "string",
        "contentType": "ANOMALY",
        "created": "2020-10-26T22:27:50.066Z",
        "createdBy": "string",
        "deleted": true,
        "description": "string",
        "enabled": true,
        "expressionsAndLimits": [
          {
            "expression": "string",
            "limit": 0
          }
        ],
        "id": "string",
        "isPrototype": true,
        "lastUpdated": "2020-10-26T22:27:50.066Z",
        "lastUpdatedBy": "string",
        "name": "string",
        "parentJaskId": "string",
        "ruleId": 0,
        "ruleSource": "string",
        "ruleType": "string",
        "score": 0,
        "signalCount07d": 0,
        "signalCount24h": 0,
        "status": {
          "message": "string",
          "status": "ACTIVE"
        },
        "stream": "string",
        "windowSize": 0
      },
      {},
      {}
    ],
    "total": 0
  }
}
```