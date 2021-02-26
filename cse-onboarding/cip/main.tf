terraform {
  required_providers {
    sumologic = {
      source = "sumologic/sumologic"
    }
  }
}

provider "sumologic" { }

### CSE ROLE ###
resource "sumologic_role" "cse_access" {
  name        = "CSE Access"
  description = "Gives users access to CSE as an Analyst. This role gives no search scope unless you have a source category called XXXYYYZZZ"
  filter_predicate = "_sourceCategory=XXXYYYZZZ"
  capabilities = [
    "viewCse"
  ]
}

### SIEM FIELDS ###
resource "sumologic_field" "siemforward" {
  field_name = "_siemforward"
  data_type = "String"
}

resource "sumologic_field" "siemeventid" {
  field_name = "_siemeventid"
  data_type = "String"
}

resource "sumologic_field" "siemsensortype" {
  field_name = "_siemsensortype"
  data_type = "String"
}

resource "sumologic_field" "siemformat" {
  field_name = "_siemformat"
  data_type = "String"
}

resource "sumologic_field" "siemvendor" {
  field_name = "_siemvendor"
  data_type = "String"
}

resource "sumologic_field" "siemproduct" {
  field_name = "_siemproduct"
  data_type = "String"
}

resource "sumologic_field" "siemsensoruploadtime" {
  field_name = "_siemsensoruploadtime"
  data_type = "String"
}

resource "sumologic_field" "siemsensorname" {
  field_name = "_siemsensorname"
  data_type = "String"
}

resource "sumologic_field" "siemsensorzone" {
  field_name = "_siemsensorzone"
  data_type = "String"
}

resource "sumologic_field" "sumodeployment" {
  field_name = "_sumodeployment"
  data_type = "String"
}


resource "sumologic_field" "snarfenabled" {
  field_name = "_snarfenabled"
  data_type = "String"
}

resource "sumologic_field" "snarftier" {
  field_name = "_snarftier"
  data_type = "String"
}

resource "sumologic_field" "snarfwithraw" {
  field_name = "_snarfwithraw"
  data_type = "String"
}

resource "sumologic_field" "siemsource" {
  field_name = "_siemsource"
  data_type = "String"
}

### HTTP SOURCES ###

resource "sumologic_collector" "cse_internal" {
  name        = "cse_internal"
  description = "Collector for all CSE Records, Signals, and Insights."
}

resource "sumologic_collector" "cnc_connections" {
  name        = "cnc_connections"
  description = "Collector for all cloud to cloud sources."
}

resource "sumologic_http_source" "cse_records" {
  name                = "cse_records"
  description         = "CSE Records"
  category            = "asoc/RECORD/records"
  collector_id        = sumologic_collector.cse_internal.id
}

resource "sumologic_http_source" "cse_signals" {
  name                = "cse_signals"
  description         = "CSE Signals"
  category            = "asoc/SIGNAL/signals"
  collector_id        = sumologic_collector.cse_internal.id
}

resource "sumologic_http_source" "cse_insights" {
  name                = "cse_insights"
  description         = "CSE Insights"
  category            = "asoc/INSIGHT/insights"
  collector_id        = sumologic_collector.cse_internal.id
}

### PARTITIONS ###
resource "sumologic_partition" "cse_records" {
  name = "cse_records"
  routing_expression = "_sourcecategory=asoc/RECORD/records"
}

resource "sumologic_partition" "cse_signals" {
  name = "cse_signals"
  routing_expression = "_sourcecategory=asoc/SIGNAL/signals"
}

resource "sumologic_partition" "cse_insights" {
  name = "cse_insights"
  routing_expression = "_sourcecategory=asoc/INSIGHT/insights"
}


### CONTENT ###

data "sumologic_personal_folder" "personalFolder" {}

resource "sumologic_content" "insight_metrics" {
    parent_id = data.sumologic_personal_folder.personalFolder.id
    config = jsonencode({
    "type": "FolderSyncDefinition",
    "name": "Insight Metrics",
    "description": "",
    "children": [
        {
            "type": "DashboardV2SyncDefinition",
            "name": "Insights",
            "description": "",
            "title": "Insights",
            "rootPanel": null,
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
                "to": null
            },
            "layout": {
                "layoutType": "Grid",
                "layoutStructures": [
                    {
                        "key": "panelDF37382E88D0694C",
                        "structure": "{\"height\":7,\"width\":24,\"x\":0,\"y\":20}"
                    },
                    {
                        "key": "panel6BAFF8A6BA8DFA4F",
                        "structure": "{\"height\":6,\"width\":8,\"x\":8,\"y\":8}"
                    },
                    {
                        "key": "panelA258868193588844",
                        "structure": "{\"height\":6,\"width\":8,\"x\":16,\"y\":9}"
                    },
                    {
                        "key": "panel237EE73894F29948",
                        "structure": "{\"height\":6,\"width\":8,\"x\":0,\"y\":8}"
                    },
                    {
                        "key": "panel22BEEA8788F84B4D",
                        "structure": "{\"height\":9,\"width\":24,\"x\":0,\"y\":38}"
                    },
                    {
                        "key": "panelPANE-D83C9C4E9F1FE949",
                        "structure": "{\"height\":6,\"width\":8,\"x\":0,\"y\":14}"
                    },
                    {
                        "key": "panelE3B06DB29BD06A46",
                        "structure": "{\"height\":8,\"width\":24,\"x\":0,\"y\":0}"
                    },
                    {
                        "key": "panel9BAE2300B9D66A40",
                        "structure": "{\"height\":6,\"width\":8,\"x\":8,\"y\":14}"
                    },
                    {
                        "key": "panelAE0BC836ADD18A48",
                        "structure": "{\"height\":6,\"width\":8,\"x\":16,\"y\":13}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "885E40CBD917DF82",
                    "key": "panelDF37382E88D0694C",
                    "title": "Insight Resolution Statuses",
                    "visualSettings": "{\"general\":{\"mode\":\"distribution\",\"type\":\"bar\"},\"color\":{\"family\":\"scheme1\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| toInt(\"{{lookback}}\") as lookback\n| toLong(realtimeslice) as log_time\n| where log_time > (now() - 86400000*lookback)\n| count by resolution",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "6509C1261C2D70BE",
                    "key": "panel6BAFF8A6BA8DFA4F",
                    "title": "Average Hours To Response",
                    "visualSettings": "{\"general\":{\"mode\":\"singleValueMetrics\",\"type\":\"svp\"},\"svp\":{\"label\":\"\",\"thresholds\":[{\"from\":0,\"to\":3,\"color\":\"#16943E\"},{\"from\":3,\"to\":12,\"color\":\"#DFBE2E\"},{\"from\":12,\"to\":24,\"color\":\"#BF2121\"}],\"gauge\":{\"show\":true,\"max\":24},\"sparkline\":{\"show\":false},\"hideData\":false},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toInt(\"{{lookback}}\") as lookback\n| toLong(realtimeslice) as log_time\n| where log_time > (now() - 86400000*lookback)\n| avg(avg_time_to_response)\n| round(_avg / 3600) as _avg",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "7D761F1959349218",
                    "key": "panelA258868193588844",
                    "title": "Average Hours to Remediation",
                    "visualSettings": "{\"general\":{\"mode\":\"singleValueMetrics\",\"type\":\"svp\"},\"svp\":{\"label\":\"\",\"thresholds\":[{\"from\":0,\"to\":3,\"color\":\"#16943E\"},{\"from\":3,\"to\":12,\"color\":\"#DFBE2E\"},{\"from\":12,\"to\":24,\"color\":\"#BF2121\"}],\"gauge\":{\"show\":true,\"max\":24},\"sparkline\":{\"show\":false}},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toInt(\"{{lookback}}\") as lookback\n| toLong(realtimeslice) as log_time\n| where log_time > (now() - 86400000*lookback)\n| avg(avg_time_to_remediation)\n| round(_avg / 3600) as _avg",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "DC2B125175D9302B",
                    "key": "panel237EE73894F29948",
                    "title": "Average Hours to Detection",
                    "visualSettings": "{\"general\":{\"mode\":\"singleValueMetrics\",\"type\":\"svp\"},\"svp\":{\"label\":\"\",\"thresholds\":[{\"from\":0,\"to\":24,\"color\":\"#16943E\"},{\"from\":24,\"to\":96,\"color\":\"#DFBE2E\"},{\"from\":96,\"to\":168,\"color\":\"#BF2121\"}],\"gauge\":{\"show\":true,\"max\":168},\"sparkline\":{\"show\":false}},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toInt(\"{{lookback}}\") as lookback\n| toLong(realtimeslice) as log_time\n| where log_time > (now() - 86400000*lookback)\n| avg(avg_time_to_detection)\n| round(_avg / 3600) as _avg",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "0089C356734B7109",
                    "key": "panel22BEEA8788F84B4D",
                    "title": "Insights Closed by User",
                    "visualSettings": "{\"general\":{\"mode\":\"distribution\",\"type\":\"column\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toInt(\"{{lookback}}\") as lookback\n| toLong(realtimeslice) as log_time\n| where log_time > (now() - 86400000*lookback)\n| count by closed_by\n| order by _count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "51BD3B0F3222E357",
                    "key": "panelPANE-D83C9C4E9F1FE949",
                    "title": "Average Hours to Detection",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[{\"series\":[\"_avg_high\"],\"queries\":[],\"properties\":{\"color\":\"#bf2121\",\"displayType\":\"smooth\",\"name\":\"High Severity\"}},{\"series\":[\"_avg_low\"],\"queries\":[],\"properties\":{\"color\":\"#116b25\",\"displayType\":\"smooth\",\"name\":\"Low Severity\"}},{\"series\":[\"_avg_med\"],\"queries\":[],\"properties\":{\"color\":\"#dfbe2e\",\"displayType\":\"smooth\",\"name\":\"Medium Severity\"}}]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _messageTime\n| timeslice 1d\n| toInt(\"{{lookback}}\") as lookback\n| where _messageTime > (now() - 86400000*lookback)\n| where severity = \"HIGH\"\n| avg(avg_time_to_response) by _timeslice\n| round(_avg / 60) as _avg_high\n| fields - _avg\n| order by _timeslice asc",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _messageTime\n| timeslice 1d\n| toInt(\"{{lookback}}\") as lookback\n| where _messageTime > (now() - 86400000*lookback)\n| where severity = \"MEDIUM\"\n| avg(avg_time_to_response) by _timeslice\n| round(_avg / 3600) as _avg_med\n| fields - _avg\n| order by _timeslice asc",
                            "queryType": "Logs",
                            "queryKey": "B",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _messageTime\n| timeslice 1d\n| toInt(\"{{lookback}}\") as lookback\n| where _messageTime > (now() - 86400000*lookback)\n| where severity = \"LOW\"\n| avg(avg_time_to_response) by _timeslice\n| round(_avg / 3600) as _avg_low\n| fields - _avg\n| order by _timeslice asc",
                            "queryType": "Logs",
                            "queryKey": "C",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "1257EC1E34319FCA",
                    "key": "panelE3B06DB29BD06A46",
                    "title": "Insights Closed by Day and Severity",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\"},\"series\":{},\"overrides\":[{\"series\":[\"HIGH\"],\"queries\":[],\"properties\":{\"color\":\"#933c03\",\"name\":\"High Severity\"}},{\"series\":[\"LOW\"],\"queries\":[],\"properties\":{\"color\":\"#116b25\",\"name\":\"Low Severity\"}},{\"series\":[\"MEDIUM\"],\"queries\":[],\"properties\":{\"color\":\"#dfbe2e\",\"name\":\"Medium Severity\"}}]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| toInt(\"{{lookback}}\") as lookback\n| toLong(realtimeslice) as log_time\n| where log_time > (now() - 86400000*lookback)\n| formatDate(_timeslice, \"yyyy-MM-dd\") as day\n| count by day, severity\n| order by day asc\n| transpose row day column severity",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "80AE728048BE69AD",
                    "key": "panel9BAE2300B9D66A40",
                    "title": "Average Minutes to Response",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[{\"series\":[\"_avg_high\"],\"queries\":[],\"properties\":{\"color\":\"#bf2121\",\"displayType\":\"smooth\",\"name\":\"High Severity\"}},{\"series\":[\"_avg_low\"],\"queries\":[],\"properties\":{\"color\":\"#116b25\",\"displayType\":\"smooth\",\"name\":\"Low Severity\"}},{\"series\":[\"_avg_med\"],\"queries\":[],\"properties\":{\"color\":\"#dfbe2e\",\"displayType\":\"smooth\",\"name\":\"Medium Severity\"}}]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _messageTime\n| timeslice 1d\n| toInt(\"{{lookback}}\") as lookback\n| where _messageTime > (now() - 86400000*lookback)\n| where severity = \"MEDIUM\"\n| avg(avg_time_to_response) by _timeslice\n| round(_avg / 60) as _avg_med\n| fields - _avg\n| order by _timeslice asc",
                            "queryType": "Logs",
                            "queryKey": "B",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _messageTime\n| timeslice 1d\n| toInt(\"{{lookback}}\") as lookback\n| where _messageTime > (now() - 86400000*lookback)\n| where severity = \"LOW\"\n| avg(avg_time_to_response) by _timeslice\n| round(_avg / 60) as _avg_low\n| fields - _avg\n| order by _timeslice asc",
                            "queryType": "Logs",
                            "queryKey": "C",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _messageTime\n| timeslice 1d\n| toInt(\"{{lookback}}\") as lookback\n| where _messageTime > (now() - 86400000*lookback)\n| where severity = \"HIGH\"\n| avg(avg_time_to_response) by _timeslice\n| round(_avg / 60) as _avg_high\n| fields - _avg\n| order by _timeslice asc",
                            "queryType": "Logs",
                            "queryKey": "D",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "A77388E0B99EC516",
                    "key": "panelAE0BC836ADD18A48",
                    "title": "Average Minutes to Remediation",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[{\"series\":[\"_avg_high\"],\"queries\":[],\"properties\":{\"color\":\"#bf2121\",\"displayType\":\"smooth\",\"name\":\"High Severity\"}},{\"series\":[\"_avg_low\"],\"queries\":[],\"properties\":{\"color\":\"#116b25\",\"displayType\":\"smooth\",\"name\":\"Low Severity\"}},{\"series\":[\"_avg_med\"],\"queries\":[],\"properties\":{\"color\":\"#dfbe2e\",\"displayType\":\"smooth\",\"name\":\"Medium Severity\"}}]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _messageTime\n| timeslice 1d\n| toInt(\"{{lookback}}\") as lookback\n| where _messageTime > (now() - 86400000*lookback)\n| where severity = \"HIGH\"\n| avg(avg_time_to_remediation) by _timeslice\n| round(_avg / 3600) as _avg_high\n| fields - _avg\n| order by _timeslice asc",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _messageTime\n| timeslice 1d\n| toInt(\"{{lookback}}\") as lookback\n| where _messageTime > (now() - 86400000*lookback)\n| where severity = \"MEDIUM\"\n| avg(avg_time_to_remediation) by _timeslice\n| round(_avg / 3600) as _avg_med\n| fields - _avg\n| order by _timeslice asc",
                            "queryType": "Logs",
                            "queryKey": "B",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _messageTime\n| timeslice 1d\n| toInt(\"{{lookback}}\") as lookback\n| where _messageTime > (now() - 86400000*lookback)\n| where severity = \"LOW\"\n| avg(avg_time_to_remediation) by _timeslice\n| round(_avg / 3600) as _avg_low\n| fields - _avg\n| order by _timeslice asc",
                            "queryType": "Logs",
                            "queryKey": "C",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                }
            ],
            "variables": [
                {
                    "id": "8221A3F0C1094569",
                    "name": "lookback",
                    "displayName": null,
                    "defaultValue": "7",
                    "sourceDefinition": {
                        "variableSourceType": "LogQueryVariableSourceDefinition",
                        "query": "| toInt(7) as lookback",
                        "field": "lookback"
                    },
                    "allowMultiSelect": false,
                    "includeAllOption": false,
                    "hideFromUI": false
                }
            ],
            "coloringRules": []
        },
        {
            "type": "DashboardV2SyncDefinition",
            "name": "Insights - Executive View",
            "description": "",
            "title": "Insights - Executive View",
            "rootPanel": null,
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
                "to": null
            },
            "layout": {
                "layoutType": "Grid",
                "layoutStructures": [
                    {
                        "key": "panelPANE-C1BDF30092898A47",
                        "structure": "{\"height\":7,\"width\":6,\"x\":11,\"y\":6}"
                    },
                    {
                        "key": "panel33E9A247A017F949",
                        "structure": "{\"height\":7,\"width\":5,\"x\":17,\"y\":6}"
                    },
                    {
                        "key": "panel0C2A7B4DADA7DB43",
                        "structure": "{\"height\":6,\"width\":5,\"x\":17,\"y\":0}"
                    },
                    {
                        "key": "panel6C8018C8B7F2D846",
                        "structure": "{\"height\":6,\"width\":6,\"x\":11,\"y\":0}"
                    },
                    {
                        "key": "panel1A24A38788909948",
                        "structure": "{\"height\":13,\"width\":11,\"x\":0,\"y\":0}"
                    },
                    {
                        "key": "panelPANE-71A277598932AB4B",
                        "structure": "{\"height\":9,\"width\":22,\"x\":0,\"y\":13}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "17334215A8C9878F",
                    "key": "panelPANE-C1BDF30092898A47",
                    "title": "Insights by Month and Severity",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"column\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"fillOpacity\":1,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[{\"series\":[\"HIGH\"],\"queries\":[],\"properties\":{\"color\":\"#bf2121\",\"displayType\":\"stacked\",\"name\":\"High Severity\"}},{\"series\":[\"MEDIUM\"],\"queries\":[],\"properties\":{\"color\":\"#dfbe2e\",\"displayType\":\"stacked\",\"name\":\"Medium Severity\"}},{\"series\":[\"LOW\"],\"queries\":[],\"properties\":{\"displayType\":\"stacked\",\"color\":\"#116b25\",\"name\":\"Low Severity\"}}]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"YYYY-MM\") as month\n| count by month, severity\n| order by month asc\n| transpose row month column severity ",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "2A0BA8D3E8740704",
                    "key": "panel33E9A247A017F949",
                    "title": "Averge Minutes To Remediation",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[{\"series\":[\"_avg_high\"],\"queries\":[],\"properties\":{\"color\":\"#933c03\",\"displayType\":\"smooth\",\"name\":\"High Severity\"}},{\"series\":[\"_avg_low\"],\"queries\":[],\"properties\":{\"color\":\"#116b25\",\"displayType\":\"smooth\",\"name\":\"Low Severity\"}},{\"series\":[\"_avg_med\"],\"queries\":[],\"properties\":{\"color\":\"#dfbe2e\",\"displayType\":\"smooth\",\"name\":\"Medium Severity\"}},{\"series\":[\"_avg_ctc\"],\"queries\":[],\"properties\":{\"color\":\"#005982\",\"displayType\":\"smooth\",\"name\":\"CTC\"}}]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"YY-MM\") as month\n| where severity = \"HIGH\"\n| avg(avg_time_to_remediation) by month\n| round(_avg / 60) as _avg_high\n| fields - _avg\n| order by month asc",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"YY-MM\") as month\n| where severity = \"MEDIUM\"\n| avg(avg_time_to_remediation) by month\n| round(_avg / 60) as _avg_med\n| fields - _avg\n| order by month asc",
                            "queryType": "Logs",
                            "queryKey": "B",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"YY-MM\") as month\n| where severity = \"LOW\"\n| avg(avg_time_to_remediation) by month\n| round(_avg / 60) as _avg_low\n| fields - _avg\n| order by month asc",
                            "queryType": "Logs",
                            "queryKey": "C",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"YY-MM\") as month\n| where name matches \"*CTC*\"\n| avg(avg_time_to_remediation) by month\n| round(_avg / 60) as _avg_ctc\n| fields - _avg\n| order by month asc",
                            "queryType": "Logs",
                            "queryKey": "D",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "D45C146BBA7D3F4F",
                    "key": "panel0C2A7B4DADA7DB43",
                    "title": "Averge Minutes To Response",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[{\"series\":[\"_avg_high\"],\"queries\":[],\"properties\":{\"color\":\"#933c03\",\"displayType\":\"smooth\",\"name\":\"High Severity\"}},{\"series\":[\"_avg_low\"],\"queries\":[],\"properties\":{\"color\":\"#116b25\",\"displayType\":\"smooth\",\"name\":\"Low Severity\"}},{\"series\":[\"_avg_med\"],\"queries\":[],\"properties\":{\"color\":\"#dfbe2e\",\"displayType\":\"smooth\",\"name\":\"Medium Severity\"}},{\"series\":[\"_avg_ctc\"],\"queries\":[],\"properties\":{\"color\":\"#005982\",\"displayType\":\"smooth\",\"name\":\"CTC\"}}]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"YY-MM\") as month\n| where severity = \"HIGH\"\n| avg(avg_time_to_response) by month\n| round(_avg / 60) as _avg_high\n| fields - _avg\n| order by month asc",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"YY-MM\") as month\n| where severity = \"MEDIUM\"\n| avg(avg_time_to_response) by month\n| round(_avg / 60) as _avg_med\n| fields - _avg\n| order by month asc",
                            "queryType": "Logs",
                            "queryKey": "B",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"YY-MM\") as month\n| where severity = \"LOW\"\n| avg(avg_time_to_response) by month\n| round(_avg / 60) as _avg_low\n| fields - _avg\n| order by month asc",
                            "queryType": "Logs",
                            "queryKey": "C",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"YY-MM\") as month\n| where name matches \"*CTC*\"\n| avg(avg_time_to_response) by month\n| round(_avg / 60) as _avg_ctc\n| fields - _avg\n| order by month asc",
                            "queryType": "Logs",
                            "queryKey": "D",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "EE5272B4DDAC546A",
                    "key": "panel6C8018C8B7F2D846",
                    "title": "Averge Hours To Detection",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[{\"series\":[\"_avg_high\"],\"queries\":[],\"properties\":{\"color\":\"#933c03\",\"displayType\":\"smooth\",\"name\":\"High Severity\"}},{\"series\":[\"_avg_low\"],\"queries\":[],\"properties\":{\"color\":\"#116b25\",\"displayType\":\"smooth\",\"name\":\"Low Severity\"}},{\"series\":[\"_avg_med\"],\"queries\":[],\"properties\":{\"color\":\"#dfbe2e\",\"displayType\":\"smooth\",\"name\":\"Medium Severity\"}},{\"series\":[\"_avg_ctc\"],\"queries\":[],\"properties\":{\"displayType\":\"smooth\",\"color\":\"#005982\",\"name\":\"CTC\"}}]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"YY-MM\") as month\n| where severity = \"HIGH\"\n| avg(avg_time_to_detection) by month\n| round(_avg / 3600) as _avg_high\n| fields - _avg\n| order by month asc",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"YY-MM\") as month\n| where severity = \"MEDIUM\"\n| avg(avg_time_to_detection) by month\n| round(_avg / 3600) as _avg_med\n| fields - _avg\n| order by month asc",
                            "queryType": "Logs",
                            "queryKey": "B",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"YY-MM\") as month\n| where severity = \"LOW\"\n| avg(avg_time_to_detection) by month\n| round(_avg / 3600) as _avg_low\n| fields - _avg\n| order by month asc",
                            "queryType": "Logs",
                            "queryKey": "C",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"YY-MM\") as month\n| where name matches \"*CTC*\"\n| avg(avg_time_to_detection) by month\n| round(_avg / 3600) as _avg_ctc\n| fields - _avg\n| order by month asc",
                            "queryType": "Logs",
                            "queryKey": "D",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "AD72837C84A33992",
                    "key": "panel1A24A38788909948",
                    "title": "Insights by Hour",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"overrides\":[{\"series\":[\"this_month_hour\"],\"queries\":[],\"properties\":{\"displayType\":\"smooth\",\"name\":\"This Month\"}},{\"series\":[\"last_month_hour\"],\"queries\":[],\"properties\":{\"displayType\":\"smooth\",\"name\":\"Last Month\"}},{\"series\":[\"two_months_ago\"],\"queries\":[],\"properties\":{\"displayType\":\"smooth\",\"name\":\"Two Months Ago\"}}],\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"MM\") as month\n| formatDate(_timeslice, \"HH\") as hour\n| formatDate(now(), \"MM\") as this_month\n| where month = this_month\n| count as this_month_hour by hour\n| fillmissing values(\"00\", \"01\", \"02\", \"03\", \"04\", \"05\", \"06\", \"07\", \"08\", \"09\", \"10\", \"11\", \"12\", \"13\", \"14\", \"15\", \"16\", \"17\", \"18\", \"19\", \"20\", \"21\", \"22\", \"23\") in hour with 0 for this_month_hour\n| order by hour asc",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"MM\") as month\n| formatDate(_timeslice, \"HH\") as hour\n| formatDate(now(), \"MM\") as this_month\n| if(this_month = 1, 12, this_month - 1) as last_month\n| where month = last_month\n| count as last_month_hour by hour\n| fillmissing values(\"00\", \"01\", \"02\", \"03\", \"04\", \"05\", \"06\", \"07\", \"08\", \"09\", \"10\", \"11\", \"12\", \"13\", \"14\", \"15\", \"16\", \"17\", \"18\", \"19\", \"20\", \"21\", \"22\", \"23\") in hour with 0 for last_month_hour\n| order by hour asc",
                            "queryType": "Logs",
                            "queryKey": "B",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        },
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"MM\") as month\n| formatDate(_timeslice, \"HH\") as hour\n| formatDate(now(), \"MM\") as this_month\n| if(this_month = 1, 11,if(this_month = 2, 10, this_month - 2)) as two_months_ago\n| where month = two_months_ago\n| count as two_months_ago by hour\n| fillmissing values(\"00\", \"01\", \"02\", \"03\", \"04\", \"05\", \"06\", \"07\", \"08\", \"09\", \"10\", \"11\", \"12\", \"13\", \"14\", \"15\", \"16\", \"17\", \"18\", \"19\", \"20\", \"21\", \"22\", \"23\") in hour with 0 for two_months_ago\n| order by hour asc",
                            "queryType": "Logs",
                            "queryKey": "C",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "EF1E321972D52910",
                    "key": "panelPANE-71A277598932AB4B",
                    "title": "False Positive Ratio",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_view=cse_insight_metrics\n| toLong(realtimeslice) as _timeslice\n| formatDate(_timeslice, \"YYYY-MM\") as month\n| if(resolution = \"False Positive\", 1, 0) as fp_count\n| 1 as _row\n| total(_row) as total_insights by month\n| total(fp_count) as fp_insights by month\n| last(total_insights) as total_insights, last(fp_insights) as fp_insights by month\n| (fp_insights/total_insights) * 100 as fp_ratio\n| fields month, fp_ratio\n| order by month asc",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                }
            ],
            "variables": [],
            "coloringRules": []
        },
        {
            "type": "SavedSearchWithScheduleSyncDefinition",
            "name": "View for Insights Dashboard",
            "search": {
                "queryText": "_sourcecategory=\"asoc/INSIGHT/insights\" \n| json field=_raw \"closed\" nodrop \n| where !isNull(closed) \n| timeslice 1m \n| json field=_raw \"timeToResponse\" nodrop \n| json field=_raw \"timeToDetection\" nodrop \n| json field=_raw \"timeToRemediation\" nodrop \n| json field=_raw \"severity\" nodrop \n| json field=_raw \"name\" nodrop\n| json field=_raw \"resolution\" nodrop\n| json field=_raw \"closedBy\" as closed_by nodrop\n| json field=_raw \"id\" as uid\n| avg(timeToResponse) as avg_time_to_response, avg(timeToDetection) as avg_time_to_detection, avg(timeToRemediation) as avg_time_to_remediation by _timeslice, severity, name, resolution, closed_by, uid\n| _timeslice as realtimeslice \n| queryEndTime() as _timeslice\n| order by avg_time_to_remediation\n| save view cse_insight_metrics",
                "defaultTimeRange": "-24h",
                "byReceiptTime": false,
                "viewName": "",
                "viewStartTime": "1970-01-01T00:00:00Z",
                "queryParameters": [],
                "parsingMode": "Manual"
            },
            "searchSchedule": {
                "cronExpression": "0 0 23 ? * 1,2,3,4,5,6,7 *",
                "displayableTimeRange": "-90d",
                "parseableTimeRange": {
                    "type": "BeginBoundedTimeRange",
                    "from": {
                        "type": "RelativeTimeRangeBoundary",
                        "relativeTime": "-12w6d"
                    },
                    "to": null
                },
                "timeZone": "America/Chicago",
                "threshold": {
                    "thresholdType": "group",
                    "operator": "lt",
                    "count": 0
                },
                "notification": {
                    "taskType": "EmailSearchNotificationSyncDefinition",
                    "toList": [
                        "tdiderich@sumologic.com"
                    ],
                    "subjectTemplate": "Search Alert: {{AlertCondition}} found for {{SearchName}}",
                    "includeQuery": true,
                    "includeResultSet": true,
                    "includeHistogram": true,
                    "includeCsvAttachment": false
                },
                "scheduleType": "1Day",
                "muteErrorEmails": false,
                "parameters": []
            },
            "description": ""
        }
    ]
})
}

resource "sumologic_content" "cse_dashboards" {
    parent_id = data.sumologic_personal_folder.personalFolder.id
    config = jsonencode({
    "type": "FolderSyncDefinition",
    "name": "CSE Dashboards",
    "description": "",
    "children": [
        {
            "type": "DashboardV2SyncDefinition",
            "name": "CSE Record Dashboard",
            "description": "",
            "title": "CSE Record Dashboard",
            "rootPanel": null,
            "theme": "Light",
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
                "to": null
            },
            "layout": {
                "layoutType": "Grid",
                "layoutStructures": [
                    {
                        "key": "panelPANE-EC5055E694CE7A4A",
                        "structure": "{\"height\":10,\"width\":12,\"x\":0,\"y\":0}"
                    },
                    {
                        "key": "panelPANE-6C8CBFFBB8391A40",
                        "structure": "{\"height\":10,\"width\":12,\"x\":12,\"y\":0}"
                    },
                    {
                        "key": "panelPANE-51D272A38569884A",
                        "structure": "{\"height\":8,\"width\":6,\"x\":0,\"y\":10}"
                    },
                    {
                        "key": "panel5BAC0541BAA83840",
                        "structure": "{\"height\":8,\"width\":6,\"x\":6,\"y\":10}"
                    },
                    {
                        "key": "panelPANE-06E62C0FA1D00B40",
                        "structure": "{\"height\":8,\"width\":12,\"x\":12,\"y\":10}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "39280F01360D86DB",
                    "key": "panelPANE-EC5055E694CE7A4A",
                    "title": "Total Event Volume",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| timeslice 1h\n| count by _timeslice",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "1BE0CD982ECCD009",
                    "key": "panelPANE-6C8CBFFBB8391A40",
                    "title": "Events by Vendor and Product",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| timeslice 1h\n| count by _timeslice, metadata_vendor, metadata_product\n| transpose row _timeslice column metadata_vendor, metadata_product",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "3976D6E58C1B86FA",
                    "key": "panelPANE-51D272A38569884A",
                    "title": "Top Talkers",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| where isValidIP(srcdevice_ip)\n| timeslice 1h\n| count by srcdevice_ip\n| order by _count\n| limit 10",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "EDBD6F26873B10C8",
                    "key": "panel5BAC0541BAA83840",
                    "title": "Top Destinations",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| where isValidIP(dstDevice_ip)\n| timeslice 1h\n| count by dstDevice_ip\n| order by _count\n| limit 10",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "C60BB6943022EB53",
                    "key": "panelPANE-06E62C0FA1D00B40",
                    "title": "Rare Domains",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| where !isEmpty(http_url_rootDomain) and http_url_entropyRootDomain > 3\n| count by http_url_rootDomain, http_url_entropyRootDomain\n| order by _count asc\n| where _count = 1",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                }
            ],
            "variables": [],
            "coloringRules": []
        },
        {
            "type": "DashboardV2SyncDefinition",
            "name": "Office 365",
            "description": "",
            "title": "Office 365",
            "rootPanel": null,
            "theme": "Light",
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
                "to": null
            },
            "layout": {
                "layoutType": "Grid",
                "layoutStructures": [
                    {
                        "key": "panelPANE-3D7A83B8BC3F0A42",
                        "structure": "{\"height\":9,\"width\":24,\"x\":0,\"y\":0}"
                    },
                    {
                        "key": "panelPANE-8D8B53FA8B7F0B48",
                        "structure": "{\"height\":10,\"width\":12,\"x\":0,\"y\":9}"
                    },
                    {
                        "key": "panelPANE-FE7AC796B6FB284C",
                        "structure": "{\"height\":5,\"width\":12,\"x\":12,\"y\":9}"
                    },
                    {
                        "key": "panelPANE-D4B76A1FA14FB944",
                        "structure": "{\"height\":5,\"width\":12,\"x\":12,\"y\":15}"
                    },
                    {
                        "key": "panelPANE-99D55CAAB2F7584F",
                        "structure": "{\"height\":14,\"width\":24,\"x\":0,\"y\":20}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "87EF86139851BFE4",
                    "key": "panelPANE-3D7A83B8BC3F0A42",
                    "title": "Event Trend",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| timeslice 1d\n| where metadata_product = \"Office 365\"\n| count by metadata_deviceeventid, _timeslice\n| transpose row _timeslice column metadata_deviceeventid",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "A38FB066C52D9FD5",
                    "key": "panelPANE-8D8B53FA8B7F0B48",
                    "title": "Successful Non-US Logins",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| where metadata_product = \"Office 365\" and !(isEmpty(device_ip_countryCode) OR device_ip_countryCode = \"Unassigned\" OR device_ip_countryCode = \"US\" OR toLowerCase(user_username) = \"unknown\") and !isNull(success) and success\n| count by user_username, device_ip_countryCode\n| order by _count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "8628D3EAEECACE38",
                    "key": "panelPANE-FE7AC796B6FB284C",
                    "title": "Users that Successfully Logged in from 2+ Countries",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| where metadata_product = \"Office 365\" and !(isEmpty(device_ip_countryCode) OR device_ip_countryCode = \"Unassigned\" OR toLowerCase(user_username) = \"unknown\") and !isNull(success) and success\n| count_distinct(device_ip_countryCode) by user_username\n| where _count_distinct > 1\n| order by _count_distinct",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "3E47409C07648DBF",
                    "key": "panelPANE-D4B76A1FA14FB944",
                    "title": "User Account Lockouts - attempted logins on locked account for last 7 days",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| where metadata_product = \"Office 365\" and fields matches \"*IdsLocked*\"\n| count by user_username",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "028086DA58B3134C",
                    "key": "panelPANE-99D55CAAB2F7584F",
                    "title": "DLP Violations",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| json field=fields \"Operation\"\n| where metadata_product = \"Office 365\" and (toLowerCase(Operation) matches \"*dlp*\" or toLowerCase(metadata_deviceeventid) matches \"*dlp*\")\n| count, last(fields) as details by user_username, metadata_deviceeventid, Operation\n| order by _count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                }
            ],
            "variables": [],
            "coloringRules": []
        },
        {
            "type": "DashboardV2SyncDefinition",
            "name": "Office 365 User Search",
            "description": "",
            "title": "Office 365 User Search",
            "rootPanel": null,
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
                "to": null
            },
            "layout": {
                "layoutType": "Grid",
                "layoutStructures": [
                    {
                        "key": "panelPANE-D183AF2FBEFFA844",
                        "structure": "{\"height\":8,\"width\":24,\"x\":0,\"y\":0}"
                    },
                    {
                        "key": "panel63CCFAF7B0A04A48",
                        "structure": "{\"height\":9,\"width\":24,\"x\":0,\"y\":8}"
                    },
                    {
                        "key": "panel36D874DB8ECBF843",
                        "structure": "{\"height\":9,\"width\":24,\"x\":0,\"y\":17}"
                    },
                    {
                        "key": "panelPANE-E53C31E8906D0849",
                        "structure": "{\"height\":7,\"width\":24,\"x\":0,\"y\":26}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "0EF892BEF62E0F06",
                    "key": "panelPANE-D183AF2FBEFFA844",
                    "title": "Distinct Days + Percentage of Logins by IP/User",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_sourceCategory=*o365* UserLoggedIn\n| timeslice 1d\n| json field=_raw \"UserId\" as user_username\n| toLowerCase(user_username)\n| where user_username matches \"{{user_username}}\"\n| json field=_raw \"ClientIP\" as device_ip\n| where device_ip matches \"{{device_ip}}\"\n| lookup country_name, state, city from geo://location on ip=device_ip\n| 1 as _accum\n| count_distinct(_timeslice) as days_seen, count by user_username, device_ip, country_name, state, city\n| total(_count) as total_logins by user_username\n| total(_count) as logins_per_ip by user_username, device_ip\n| (logins_per_ip/total_logins)*100 as pct_logins_by_ip\n| fields - total_logins, logins_per_ip\n| order by days_seen",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-4w2d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "2CCA0B762EEA0729",
                    "key": "panel63CCFAF7B0A04A48",
                    "title": "Distinct Days + Percentage of Events by UserAgent/User",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_sourceCategory=*o365* useragent\n| timeslice 1d\n| json field=_raw \"UserId\" as user_username nodrop\n| toLowerCase(user_username)\n| where user_username matches \"{{user_username}}\"\n| json field=_raw \"ClientIP\" as device_ip nodrop\n| where device_ip matches \"{{device_ip}}\"\n| lookup country_name, state, city from geo://location on ip=device_ip\n| json field=_raw \"UserAgent\" as user_agent\n| count_distinct(_timeslice) as days_seen, count by user_username, user_agent, device_ip, country_name, state, city\n| total(_count) as total_events by user_username\n| total(_count) as events_per_user_agent by user_username, user_agent, device_ip\n| (events_per_user_agent/total_events)*100 as pct_events_by_user_agent\n| fields - total_events, events_per_user_agent\n| order by days_seen",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-4w2d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "790AA6399AAE6F52",
                    "key": "panel36D874DB8ECBF843",
                    "title": "Distinct Days + Percentage of Events by Operation",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_sourceCategory=*o365* Operation\n| timeslice 1d\n| json field=_raw \"UserId\" as user_username nodrop\n| toLowerCase(user_username)\n| where user_username matches \"{{user_username}}\"\n| json field=_raw \"ClientIP\" as device_ip nodrop\n| where device_ip matches \"{{device_ip}}\"\n| lookup country_name, state, city from geo://location on ip=device_ip\n| json field=_raw \"Operation\" as operation\n| count_distinct(_timeslice) as days_seen, count by user_username, operation\n| total(_count) as total_events by user_username\n| total(_count) as events_per_operation by user_username, operation\n| (events_per_operation/total_events)*100 as pct_events_by_operation\n| fields - total_events, events_per_operation\n| order by days_seen ",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-4w2d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "A4DB7F81E1EA1BDA",
                    "key": "panelPANE-E53C31E8906D0849",
                    "title": "Landspeed Violations",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_sourceCategory=*o365* UserLoggedIn\n| timeslice 1d\n| json field=_raw \"UserId\" as user nodrop\n| toLowerCase(user)\n| where user matches \"{{user_username}}\"\n| json field=_raw \"ClientIP\" as src_ip nodrop\n// Parse out the user & source ip address\n// Create table listing successive logins by user\n| _messagetime as login_time\n| count BY login_time, user, src_ip\n| sort BY user, +login_time\n| ipv4ToNumber(src_ip) AS src_ip_decimal\n| backshift src_ip_decimal BY user\n| backshift login_time AS previous_login\n| where !(isNull(_backshift)) // This filters on users with only a single login or the latest event per user & avoids 'null' error messages\n// Convert the decimal back into an IP address\n| decToHex(toLong(_backshift)) as src_ip_hex\n| parse regex field=src_ip_hex \"^(?<o1>[0-9A-Z]{2})(?<o2>[0-9A-Z]{2})(?<o3>[0-9A-Z]{2})(?<o4>[0-9A-Z]{2})\"\n| concat(hexToDec(o1), \".\", hexToDec(o2), \".\", hexToDec(o3), \".\", hexToDec(o4)) as previous_src_ip\n// A geo-lookup for each IP address\n| lookup latitude AS lat1, longitude AS long1, country_name AS country_name1, state as state1 FROM geo://location ON ip=src_ip\n| lookup latitude AS lat2, longitude AS long2, country_name AS country_name2, state as state2 FROM geo://location ON ip=previous_src_ip\n| where !(isNull(lat1) OR isNull(lat2))\n// Calculate the distance between a user's successive logins using the haversine formula\n| haversine(lat1, long1, lat2, long2) AS distance_kms\n// Calculate the speed a user would have to travel at in order to have done this\n| (login_time - previous_login)/3600000 AS login_time_delta_hrs\n| where !(login_time_delta_hrs=0)\n| distance_kms/login_time_delta_hrs AS apparent_velocity_kph\n| where apparent_velocity_kph > 0 // Filter out logins from the same IP\n// Specify the impossible speed here (km/hr)\n| 500 AS impossible_speed\n| where apparent_velocity_kph > impossible_speed\n// Clean it up for presentation\n| concat(src_ip,\", \",previous_src_ip) AS ip_addresses\n| if(country_name1 <> country_name2,concat(country_name1,\", \",country_name2),country_name1) AS countries\n| if(state1 <> state2,concat(state1,\", \",state2),state1) AS states\n| fields user, ip_addresses, countries, distance_kms, login_time_delta_hrs, apparent_velocity_kph\n| sort BY apparent_velocity_kph",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-4w2d"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                }
            ],
            "variables": [
                {
                    "id": "7F3221D8B72931C0",
                    "name": "user_username",
                    "displayName": null,
                    "defaultValue": "*",
                    "sourceDefinition": {
                        "variableSourceType": "LogQueryVariableSourceDefinition",
                        "query": "| \"*\" as user_username",
                        "field": "user_username"
                    },
                    "allowMultiSelect": false,
                    "includeAllOption": true,
                    "hideFromUI": false
                },
                {
                    "id": "FCFD9FAA38B81268",
                    "name": "device_ip",
                    "displayName": null,
                    "defaultValue": "*",
                    "sourceDefinition": {
                        "variableSourceType": "LogQueryVariableSourceDefinition",
                        "query": "| \"*\" as device_ip",
                        "field": "device_ip"
                    },
                    "allowMultiSelect": false,
                    "includeAllOption": true,
                    "hideFromUI": false
                }
            ],
            "coloringRules": []
        },
        {
            "type": "DashboardV2SyncDefinition",
            "name": "Palo Alto",
            "description": "",
            "title": "Palo Alto",
            "rootPanel": null,
            "theme": "Light",
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
                "to": null
            },
            "layout": {
                "layoutType": "Grid",
                "layoutStructures": [
                    {
                        "key": "panelPANE-FA7CB8BD98677B49",
                        "structure": "{\"height\":12,\"width\":24,\"x\":0,\"y\":0}"
                    },
                    {
                        "key": "panelPANE-3688E28CA47B1B48",
                        "structure": "{\"height\":9,\"width\":8,\"x\":0,\"y\":12}"
                    },
                    {
                        "key": "panel74DE34C4B3EE694A",
                        "structure": "{\"height\":9,\"width\":8,\"x\":16,\"y\":12}"
                    },
                    {
                        "key": "panelPANE-172A25D49EEA9A45",
                        "structure": "{\"height\":9,\"width\":8,\"x\":8,\"y\":12}"
                    },
                    {
                        "key": "panel72CEB7099B18C845",
                        "structure": "{\"height\":9,\"width\":24,\"x\":0,\"y\":21}"
                    },
                    {
                        "key": "panelF70AF94EAF876847",
                        "structure": "{\"height\":9,\"width\":24,\"x\":0,\"y\":30}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "592B2B8C95F1590B",
                    "key": "panelPANE-FA7CB8BD98677B49",
                    "title": "Allowed Connections to IPs on Threat List",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| json field=fields \"action\"\n| json field=fields \"device_name\"\n| json field=fields \"source_zone\"\n| where metadata_vendor matches \"Palo Alto*\" AND srcdevice_ip_isInternal AND !dstDevice_ip_isInternal AND action = \"allow\" AND listMatches matches \"*threat*\" AND listMatches matches \"*column:DstIp*\"\n| count by device_name,\n     srcdevice_ip,\n     srcdevice_ip_location,\n     source_zone,\n     listMatches,\n     dstDevice_ip,\n     dstPort,\n     dstDevice_ip_countryCode,\n     dstDevice_ip_isp,\n     dstDevice_ip_asnNumber\n| order by _count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "E00EA461AF95CC92",
                    "key": "panelPANE-3688E28CA47B1B48",
                    "title": "Threat Events by Category",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"column\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"fillOpacity\":1,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| json field=fields \"threat_category\"\n| json field=fields \"severity\"\n| where metadata_vendor matches \"Palo Alto*\" and (severity = \"low\" or severity = \"medium\" or severity = \"high\" or severity = \"critical\")\n| count by threat_category\n| order by _count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "82AB467AC63218C1",
                    "key": "panel74DE34C4B3EE694A",
                    "title": "Threat Events by Severity",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"column\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"fillOpacity\":1,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| json field=fields \"severity\"\n| where metadata_vendor matches \"Palo Alto*\" and (severity = \"low\" or severity = \"medium\" or severity = \"high\" or severity = \"critical\")\n| count by severity\n| order by _count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "55287A232D0186D0",
                    "key": "panelPANE-172A25D49EEA9A45",
                    "title": "Threat Events by Action",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"bar\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"fillOpacity\":1,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| where metadata_vendor matches \"Palo Alto*\" and (severity = \"low\" or severity = \"medium\" or severity = \"high\" or severity = \"critical\") and !isEmpty(action)\n| count by action\n| order by _count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "F03B0EC6235541FE",
                    "key": "panel72CEB7099B18C845",
                    "title": "Critical & High Severity IDS/IPS Events",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| json field=fields \"severity\"\n| where metadata_vendor matches \"Palo Alto*\" and (severity = \"high\" or severity = \"critical\") and metadata_deviceeventid = \"PALO_FW_THREAT\"\n| count by action,\n  description,\n  device_ip,\n  dstDevice_ip,\n  dstDevice_natIp,\n  dstPort,\n  file_basename,\n  ipProtocol,\n  severity,\n  srcdevice_ip,\n  srcDevice_natIp,\n  srcPort,\n  threat_name,\n  user_username\n| order by _count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "C1E7725F6D8294B7",
                    "key": "panelF70AF94EAF876847",
                    "title": "Palo Alto Correlation Alerts",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| json field=fields \"category\" nodrop\n| json field=fields \"device_name\" nodrop\n| json field=fields \"dg_hierarchy_1\" nodrop\n| json field=fields \"dg_hierarchy_2\" nodrop\n| json field=fields \"dg_hierarchy_3\" nodrop\n| json field=fields \"dg_hierarchy_4\" nodrop\n| json field=fields \"evidence\" nodrop\n| json field=fields \"generated_time\" nodrop\n| json field=fields \"object_id\" nodrop\n| json field=fields \"object_name\" nodrop\n| json field=fields \"source_ip\" nodrop\n| json field=fields \"sub_type\" nodrop\n| json field=fields \"username\" nodrop\n| json field=fields \"virtual_system\" nodrop\n| json field=fields \"virtual_system_id\" nodrop\n| json field=fields \"virtual_system_name\" nodrop\n| where metadata_vendor matches \"Palo Alto*\" and !(severity = \"low\" or severity = \"informational\") and metadata_deviceeventid = \"PALO_FW_CORRELATION\"\n| count by description,\ndevice_ip,\nsrcdevice_ip,\nthreat_name,\nuser_username,\ncategory,\ndevice_name,\ndg_hierarchy_1,\ndg_hierarchy_2,\ndg_hierarchy_3,\ndg_hierarchy_4,\nevidence,\ngenerated_time,\nobject_id,\nobject_name,\nseverity,\nsource_ip,\nsub_type,\nusername,\nvirtual_system,\nvirtual_system_id,\nvirtual_system_name\n| order by _count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                }
            ],
            "variables": [],
            "coloringRules": []
        },
        {
            "type": "DashboardV2SyncDefinition",
            "name": "ProofPoint",
            "description": "",
            "title": "ProofPoint",
            "rootPanel": null,
            "theme": "Light",
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
                "to": null
            },
            "layout": {
                "layoutType": "Grid",
                "layoutStructures": [
                    {
                        "key": "panelPANE-57DF0D38A28B5A4F",
                        "structure": "{\"height\":17,\"width\":24,\"x\":0,\"y\":0}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "B57FF694224C06A7",
                    "key": "panelPANE-57DF0D38A28B5A4F",
                    "title": "Proofpoint Phishing Emails Clicked",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| where metadata_vendor = \"Proofpoint\" and metadata_product = \"Targeted Attack Protection\" AND !(toLowerCase(metadata_deviceeventid) = \"message_blocked\" or toLowerCase(metadata_deviceeventid) = \"message_permitted\") AND (threat_name = \"spam\" or threat_name = \"phish\" or threat_name = \"malware\")\n| count by action,\n  device_ip,\n  email_sender,\n  http_url,\n  http_userAgent,\n  srcdevice_ip,\n  threat_name,\n  threat_referenceUrl,\n  timestamp,\n  user_email,\n  user_username\n| order by _count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                }
            ],
            "variables": [],
            "coloringRules": []
        },
        {
            "type": "DashboardV2SyncDefinition",
            "name": "Sample Searches",
            "description": "",
            "title": "Sample Searches",
            "rootPanel": null,
            "theme": "Light",
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
                "to": null
            },
            "layout": {
                "layoutType": "Grid",
                "layoutStructures": [
                    {
                        "key": "panelPANE-F62B526EBDFFF849",
                        "structure": "{\"height\":3,\"width\":15,\"x\":9,\"y\":0}"
                    },
                    {
                        "key": "panelPANE-9702096F8930AB46",
                        "structure": "{\"height\":3,\"width\":9,\"x\":0,\"y\":0}"
                    },
                    {
                        "key": "panel0E6CC0DABD3B2A48",
                        "structure": "{\"height\":4,\"width\":9,\"x\":0,\"y\":3}"
                    },
                    {
                        "key": "panelF5AB4109890A4B42",
                        "structure": "{\"height\":4,\"width\":15,\"x\":9,\"y\":3}"
                    },
                    {
                        "key": "panel3D36A5A3B470C949",
                        "structure": "{\"height\":6,\"width\":9,\"x\":0,\"y\":7}"
                    },
                    {
                        "key": "panel347569D880BE784E",
                        "structure": "{\"height\":6,\"width\":15,\"x\":9,\"y\":7}"
                    },
                    {
                        "key": "panel641649E2B74A0948",
                        "structure": "{\"height\":8,\"width\":9,\"x\":0,\"y\":13}"
                    },
                    {
                        "key": "panel0AB09527A5288947",
                        "structure": "{\"height\":8,\"width\":15,\"x\":9,\"y\":13}"
                    },
                    {
                        "key": "panel355B619EB0ECEB43",
                        "structure": "{\"height\":8,\"width\":9,\"x\":0,\"y\":21}"
                    },
                    {
                        "key": "panelF205C02C89E08A4E",
                        "structure": "{\"height\":8,\"width\":15,\"x\":9,\"y\":21}"
                    },
                    {
                        "key": "panel51A8C1859D709947",
                        "structure": "{\"height\":8,\"width\":9,\"x\":0,\"y\":29}"
                    },
                    {
                        "key": "panel2D56DD3D81404A45",
                        "structure": "{\"height\":8,\"width\":15,\"x\":9,\"y\":29}"
                    },
                    {
                        "key": "panelE7CC41539AC74844",
                        "structure": "{\"height\":8,\"width\":9,\"x\":0,\"y\":37}"
                    },
                    {
                        "key": "panelE119A9C1A5A50945",
                        "structure": "{\"height\":8,\"width\":15,\"x\":9,\"y\":37}"
                    },
                    {
                        "key": "panel6EE1451EBFC8394F",
                        "structure": "{\"height\":8,\"width\":9,\"x\":0,\"y\":37,\"minHeight\":2,\"minWidth\":1}"
                    },
                    {
                        "key": "panelD310AE6CA5636A42",
                        "structure": "{\"height\":8,\"width\":15,\"x\":9,\"y\":37,\"minHeight\":3,\"minWidth\":3}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "01773D29445DE3E0",
                    "key": "panelPANE-F62B526EBDFFF849",
                    "title": "Output",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"overrides\":[],\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "// BASE QUERY - all data past 24hrs\n_index=sec_record_*\n| count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": null,
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "06BE62A53EAF44BC",
                    "key": "panelPANE-9702096F8930AB46",
                    "title": "1. Base Query - all data past 24hrs",
                    "visualSettings": "{\"general\":{\"mode\":\"TextPanel\",\"type\":\"text\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"series\":{},\"text\":{\"format\":\"markdown\"}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "TextPanel",
                    "text": "\\_index=sec\\_record\\_* </br>\n| count"
                },
                {
                    "id": "C793ECE0DB2A2E53",
                    "key": "panel0E6CC0DABD3B2A48",
                    "title": "2. Filter by vendor / product / event id",
                    "visualSettings": "{\"general\":{\"mode\":\"TextPanel\",\"type\":\"text\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"series\":{},\"text\":{\"format\":\"markdown\"}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "TextPanel",
                    "text": "\\_index=sec\\_record\\_*\n<br />| where metadata_vendor = \"Palo Alto Networks\" and metadata_product = \"Next Generation Firewall\" and metadata_deviceEventId = \"PALO_FW_THREAT\"\n<br />| count by metadata_vendor, metadata_product, metadata_deviceEventId"
                },
                {
                    "id": "825C1564A869EDB9",
                    "key": "panelF5AB4109890A4B42",
                    "title": "Output",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"overrides\":[],\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| where metadata_vendor = \"Palo Alto Networks\" and metadata_product = \"Next Generation Firewall\" and metadata_deviceEventId = \"PALO_FW_THREAT\"\n| count by metadata_vendor, metadata_product, metadata_deviceEventId",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": null,
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "A90D2C39F8AE261C",
                    "key": "panel3D36A5A3B470C949",
                    "title": "3. All logs with an IP matching 10*",
                    "visualSettings": "{\"general\":{\"mode\":\"TextPanel\",\"type\":\"text\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"series\":{},\"text\":{\"format\":\"markdown\"}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "TextPanel",
                    "text": "\\_index=sec\\_record\\_\\*\n</br>| where srcDevice_ip matches \"10*\"\n\n--\n\nAll search operators can be found here -> https://help.sumologic.com/05Search/Search-Query-Language/Search-Operators"
                },
                {
                    "id": "30B549E5EEBCC730",
                    "key": "panel347569D880BE784E",
                    "title": "Output",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"overrides\":[],\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where srcDevice_ip matches \"10*\"\n| count by srcDevice_ip",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": null,
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "7009A7C4A4C5211F",
                    "key": "panel641649E2B74A0948",
                    "title": "4. All logs where a file hash is mapped",
                    "visualSettings": "{\"general\":{\"mode\":\"TextPanel\",\"type\":\"text\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"series\":{},\"text\":{\"format\":\"markdown\"}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "TextPanel",
                    "text": "\\_index=sec\\_record\\_\\*\n</br>| where !isEmpty(file_hash_md5) or !isEmpty(file_hash_sha1) or !isEmpty(file_hash_sha256)\n\n--\n\nAll search operators can be found here -> https://help.sumologic.com/05Search/Search-Query-Language/Search-Operators"
                },
                {
                    "id": "1827D8579438F499",
                    "key": "panel0AB09527A5288947",
                    "title": "Output",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"overrides\":[],\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where !isEmpty(file_hash_md5) or !isEmpty(file_hash_sha1) or !isEmpty(file_hash_sha256)\n| count by file_hash_md5, file_hash_sha1, file_hash_sha256",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": null,
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "785391C566B99EF9",
                    "key": "panel355B619EB0ECEB43",
                    "title": "5. Counting and ordering by field values",
                    "visualSettings": "{\"general\":{\"mode\":\"TextPanel\",\"type\":\"text\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"series\":{},\"text\":{\"format\":\"markdown\"}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "TextPanel",
                    "text": "\\_index=sec\\_record\\_\\*\n</br>// \"as foo\" is optional - default value is _count \n</br>| count as foo by metadata_vendor, metadata_product, metadata_deviceEventId\n</br>| order by foo \n"
                },
                {
                    "id": "0A2D8FEA11B6923F",
                    "key": "panelF205C02C89E08A4E",
                    "title": "Output",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"overrides\":[],\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| count as foo by metadata_vendor, metadata_product, metadata_deviceEventId\n| order by foo",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": null,
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "3F3133FA9248BFA0",
                    "key": "panel51A8C1859D709947",
                    "title": "6. Graphing time series data",
                    "visualSettings": "{\"general\":{\"mode\":\"TextPanel\",\"type\":\"text\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"series\":{},\"text\":{\"format\":\"markdown\"}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "TextPanel",
                    "text": "\\_index=sec\\_record\\_\\*\n</br>// timeslice can take in many options like 1d for daily buckets, 1m for minute buckets, etc \n</br>| timeslice 1h\n</br>| count by metadata_vendor, metadata_product, metadata_deviceEventId, _timeslice\n</br>| transpose row _timeslice column metadata_vendor, metadata_product, metadata_deviceEventId"
                },
                {
                    "id": "B61188A537D38BBD",
                    "key": "panel2D56DD3D81404A45",
                    "title": "Output ",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"line\",\"displayType\":\"default\",\"markerSize\":5,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":1,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"title\":\"\",\"titleFontSize\":12,\"labelFontSize\":12,\"logarithmic\":false}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"Categorical Default\"},\"overrides\":[],\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n// timeslice can take in many options like 1d for daily buckets, 1m for minute buckets, etc\n| timeslice 1h\n| count by metadata_vendor, metadata_product, metadata_deviceEventId, _timeslice\n| transpose row _timeslice column metadata_vendor, metadata_product, metadata_deviceEventId",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": null,
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "9E0FFBEF534352AF",
                    "key": "panelE7CC41539AC74844",
                    "title": "7. Avg, Max, Min, Sum and beyond",
                    "visualSettings": "{\"general\":{\"mode\":\"TextPanel\",\"type\":\"text\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"series\":{},\"text\":{\"format\":\"markdown\"}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "TextPanel",
                    "text": "\\_index=sec\\_record\\_\\*\n</br>| timeslice 1h\n</br>// counting by timeslice to get a number to work with \n</br>| count by _timeslice\n</br>| avg(_count) as avg_count_per_hour, max(_count) as max_count_seen, min(_count) as min_count_seen, sum(_count) as total_count\n\n-- \n\nAverage, Max, Min, and Sum used - other operators can be found in the docs -> https://help.sumologic.com/05Search/Search-Query-Language/aaGroup"
                },
                {
                    "id": "B5A834FC5B256F89",
                    "key": "panelE119A9C1A5A50945",
                    "title": "Output ",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"overrides\":[],\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| timeslice 1h\n// counting by timeslice to get a number to work with\n| count by _timeslice\n| avg(_count) as avg_count_per_hour, max(_count) as max_count_seen, min(_count) as min_count_seen, sum(_count) as total_count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": null,
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "56C64342ECEF4ABF",
                    "key": "panel6EE1451EBFC8394F",
                    "title": "8. Compare with timeshift",
                    "visualSettings": "{\"general\":{\"mode\":\"TextPanel\",\"type\":\"text\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"series\":{},\"text\":{\"format\":\"markdown\"}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "TextPanel",
                    "text": "\\_index=sec\\_record\\_\\*\n</br>// count of logs for comparison\n</br>| count \n</br>// timeframe to compare against (this is 7 days back, 2 times = 7 days ago + 14 days ago) \n</br>| compare with timeshift 7d 2"
                },
                {
                    "id": "D6290AFDA918D80F",
                    "key": "panelD310AE6CA5636A42",
                    "title": "Output ",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"overrides\":[],\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| count \n| compare with timeshift 7d 2",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": null,
                    "coloringRules": null,
                    "linkedDashboards": []
                }
            ],
            "variables": [],
            "coloringRules": []
        },
        {
            "type": "DashboardV2SyncDefinition",
            "name": "Trend Micro",
            "description": "",
            "title": "Trend Micro",
            "rootPanel": null,
            "theme": "Light",
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
                "to": null
            },
            "layout": {
                "layoutType": "Grid",
                "layoutStructures": [
                    {
                        "key": "panelPANE-6FABC1E2A454CB4F",
                        "structure": "{\"height\":11,\"width\":24,\"x\":0,\"y\":0}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "2F8E60302ACA9E76",
                    "key": "panelPANE-6FABC1E2A454CB4F",
                    "title": "Event Trend",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| timeslice 1d\n| where metadata_vendor = \"Trend Micro\"\n| count by metadata_vendor, metadata_product, metadata_deviceeventid, _timeslice\n| transpose row _timeslice column metadata_vendor, metadata_product, metadata_deviceeventid",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                }
            ],
            "variables": [],
            "coloringRules": []
        },
        {
            "type": "DashboardV2SyncDefinition",
            "name": "Windows",
            "description": "",
            "title": "Windows",
            "rootPanel": null,
            "theme": "Light",
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
                "to": null
            },
            "layout": {
                "layoutType": "Grid",
                "layoutStructures": [
                    {
                        "key": "panelPANE-B7EA901F90DE9B40",
                        "structure": "{\"height\":13,\"width\":24,\"x\":0,\"y\":0}"
                    },
                    {
                        "key": "panelPANE-AEC2DE16BA47B943",
                        "structure": "{\"height\":9,\"width\":12,\"x\":0,\"y\":13}"
                    },
                    {
                        "key": "panelDCA9934A874E2940",
                        "structure": "{\"height\":9,\"width\":12,\"x\":12,\"y\":13}"
                    },
                    {
                        "key": "panel361FF294A4F29B4F",
                        "structure": "{\"height\":9,\"width\":12,\"x\":12,\"y\":22}"
                    },
                    {
                        "key": "panelD6F18170A8D0484E",
                        "structure": "{\"height\":9,\"width\":12,\"x\":0,\"y\":22}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "2A1C75E8149B8E15",
                    "key": "panelPANE-B7EA901F90DE9B40",
                    "title": "Windows Event Trend by Event ID",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"showLabels\":true,\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"showLabels\":true,\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| timeslice 1d\n| where metadata_vendor = \"Microsoft\" and metadata_product = \"Windows\"\n| count by metadata_vendor, metadata_product, metadata_deviceeventid, _timeslice\n| transpose row _timeslice column metadata_vendor, metadata_product, metadata_deviceeventid",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "3CEC3B08EE47B475",
                    "key": "panelPANE-AEC2DE16BA47B943",
                    "title": "Admin Password Resets",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| where metadata_vendor = \"Microsoft\" and metadata_product = \"Windows\" and user_username matches \"*adm_*\" AND metadata_deviceeventid = \"Security-4724\"\n| count by user_username, device_hostname\n| order by _count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "D2A4FB53DEA448AC",
                    "key": "panelDCA9934A874E2940",
                    "title": "Users Added to Global Security Groups",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| json field=fields \"Computer\" as computer\n| json field=fields \"$['EventData.TargetUserName']\" as target\n| where metadata_vendor = \"Microsoft\" and metadata_product = \"Windows\" AND metadata_deviceeventid IN (\"Security-4728\", \"Security-4732\", \"Security-4756\")\n| count by user_username, device_hostname, computer, target\n| order by _count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "DED46831C8F1B4A2",
                    "key": "panel361FF294A4F29B4F",
                    "title": "Service Accounts with Interactive Logins",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| json field=fields \"LogonType\" as logontype\n| where metadata_vendor = \"Microsoft\" and metadata_product = \"Windows\" AND metadata_deviceeventid IN (\"Security-4624\", \"Security-4625\") and logontype = \"2\" and user_username matches \"*svc_*\"\n| count by user_username, device_hostname\n| order by _count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                },
                {
                    "id": "18BEF72C9216126A",
                    "key": "panelD6F18170A8D0484E",
                    "title": "Account Lockouts",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record*\n| where metadata_vendor = \"Microsoft\" and metadata_product = \"Windows\" AND metadata_deviceeventid = \"Security-4740\"\n| count by user_username\n| order by _count",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "",
                    "timeRange": {
                        "type": "BeginBoundedTimeRange",
                        "from": {
                            "type": "RelativeTimeRangeBoundary",
                            "relativeTime": "-1w"
                        },
                        "to": null
                    },
                    "coloringRules": null,
                    "linkedDashboards": []
                }
            ],
            "variables": [],
            "coloringRules": []
        }
    ]
})
}