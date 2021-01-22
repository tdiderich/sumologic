#!/usr/bin/env python3

def awesome_user_dash(user_username, insight_id, folder_id):
    dashboard = {
        "type": "DashboardV2SyncDefinition",
        "folderId": f"{folder_id}",
        "name": f"AWESOME DASHBOARD - {insight_id}",
        "description": "",
        "title": f"AWESOME DASHBOARD - {insight_id}",
        "rootPanel": None,
        "theme": "dark",
        "topologyLabelMap": {
            "data": {}
        },
        "refreshInterval": 0,
        "timeRange": {
            "type": "BeginBoundedTimeRange",
            "from": {
                "type": "RelativeTimeRangeBoundary",
                "relativeTime": "-15m"
            },
            "to": None
        },
        "layout": {
            "layoutType": "Grid",
            "layoutStructures": [
                {
                    "key": "panelPANE-6B1C649EB1E79847",
                    "structure": "{\"height\":6,\"width\":12,\"x\":0,\"y\":0,\"minHeight\":3,\"minWidth\":3}"
                }
            ]
        },
        "panels": [
            {
                "id": "6B1C649EB1E79847",
                "key": "panelPANE-6B1C649EB1E79847",
                "title": "User Search",
                "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":14},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"title\":\"\",\"titleFontSize\":12,\"labelFontSize\":12,\"logarithmic\":false}},\"legend\":{\"enabled\":True,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":True},\"color\":{\"family\":\"Categorical Default\"},\"series\":{}}",
                "keepVisualSettingsConsistentWithParent": True,
                "panelType": "SumoSearchPanel",
                "queries": [
                    {
                        "queryString": f"_sourceCategory=foobar\n| \"user\" as user_username\n| where user_username matches \"{user_username}\"\n| count by _sourceCategory",
                        "queryType": "Logs",
                        "queryKey": "A",
                        "metricsQueryMode": None,
                        "metricsQueryData": None
                    }
                ],
                "description": "",
                "timeRange": None,
                "coloringRules": None,
                "linkedDashboards": []
            }
        ],
        "variables": [],
        "coloringRules": []
    }
    return dashboard 

    