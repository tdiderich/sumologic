#!/usr/bin/env python3

def awesome_user_dash(user_username, insight_id, folder_id):

    dashboard = {
            "type": "DashboardV2SyncDefinition",
            "name": f"{insight_id} - User Info",
            "title": f"{insight_id} - User Info",
            "description": "Blah blah blah",
            "folderId": folder_id,
            "theme": "Dark",
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
                        "key": "panelPANE-1481F4598BB8A843",
                        "structure": "{\"height\":6,\"width\":12,\"x\":0,\"y\":0,\"minHeight\":3,\"minWidth\":3}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "B4EF0BE4C8A6B4C6",
                    "key": "panelPANE-1481F4598BB8A843",
                    "title": "Blah",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":14},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"title\":\"\",\"titleFontSize\":12,\"labelFontSize\":12,\"logarithmic\":false}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"Categorical Default\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": True,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": f"_sourceCategory=*\n| \"foo\" as user_username\n| where user_username matches \"{user_username}\"\n| count by user_username",
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

    