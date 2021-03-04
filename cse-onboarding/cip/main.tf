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
                    },
                    {
                        "key": "panelPANE-0EB5184F90884945",
                        "structure": "{\"height\":11,\"width\":12,\"x\":0,\"y\":18}"
                    },
                    {
                        "key": "panelAC5F82968DA13847",
                        "structure": "{\"height\":11,\"width\":12,\"x\":12,\"y\":18}"
                    },
                    {
                        "key": "panelPANE-E4DF1482A670BB44",
                        "structure": "{\"height\":9,\"width\":24,\"x\":0,\"y\":29}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "0F347A8E5D74554F",
                    "key": "panelPANE-EC5055E694CE7A4A",
                    "title": "Total Event Volume",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| timeslice 1h\n| count by _timeslice",
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
                    "id": "4CCF680BE2F7C927",
                    "key": "panelPANE-6C8CBFFBB8391A40",
                    "title": "Events by Vendor and Product",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| timeslice 1h\n| count by _timeslice, metadata_vendor, metadata_product\n| transpose row _timeslice column metadata_vendor, metadata_product",
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
                    "id": "FF8EA0C74003C580",
                    "key": "panelPANE-51D272A38569884A",
                    "title": "Top Talkers",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where isValidIP(srcDevice_ip)\n| timeslice 1h\n| count by srcDevice_ip\n| order by _count\n| limit 10",
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
                    "id": "74469190F099C817",
                    "key": "panel5BAC0541BAA83840",
                    "title": "Top Destinations",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where isValidIP(dstDevice_ip)\n| timeslice 1h\n| count by dstDevice_ip\n| order by _count\n| limit 10",
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
                    "id": "8B2A282741CFF4D1",
                    "key": "panelPANE-06E62C0FA1D00B40",
                    "title": "Rare Domains",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where !isEmpty(http_url_rootDomain) and http_url_entropyRootDomain > 3\n| count by http_url_rootDomain, http_url_entropyRootDomain\n| order by _count asc\n| where _count = 1",
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
                    "id": "0EB5184F90884945",
                    "key": "panelPANE-0EB5184F90884945",
                    "title": "Map View - SrcIp",
                    "visualSettings": "{\"general\":{\"mode\":\"map\",\"type\":\"map\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| lookup latitude, longitude, country_code, country_name, region, city, postal_code from geo://location on ip = srcDevice_ip\n| count by latitude, longitude, country_code, country_name, region, city, postal_code\n| sort _count",
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
                    "id": "AC5F82968DA13847",
                    "key": "panelAC5F82968DA13847",
                    "title": "Map View - DstIP",
                    "visualSettings": "{\"general\":{\"mode\":\"map\",\"type\":\"map\",\"displayType\":\"default\"},\"title\":{\"fontSize\":14},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| lookup latitude, longitude, country_code, country_name, region, city, postal_code from geo://location on ip = dstDevice_ip\n| count by latitude, longitude, country_code, country_name, region, city, postal_code\n| sort _count",
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
                    "id": "E4DF1482A670BB44",
                    "key": "panelPANE-E4DF1482A670BB44",
                    "title": "Non-US IPs",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where !(srcDevice_ip_countryCode = \"US\") and !isEmpty(srcDevice_ip_countryCode) and !(metadata_vendor=\"Bro\")\n| count by srcDevice_ip, srcDevice_ip_countryCode, metadata_vendor, metadata_product, metadata_deviceEventId\n| order by _count",
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
            "type": "DashboardV2SyncDefinition",
            "name": "IP Search",
            "description": "",
            "title": "IP Search",
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
                        "key": "panelPANE-A5042C788B671A4B",
                        "structure": "{\"height\":12,\"width\":12,\"x\":0,\"y\":9}"
                    },
                    {
                        "key": "panelPANE-55B522E8B969DB49",
                        "structure": "{\"height\":12,\"width\":12,\"x\":12,\"y\":9}"
                    },
                    {
                        "key": "panel2D26E0AE8C1A1841",
                        "structure": "{\"height\":9,\"width\":12,\"x\":0,\"y\":0}"
                    },
                    {
                        "key": "panelPANE-50FF0E72BB4E2B4C",
                        "structure": "{\"height\":7,\"width\":12,\"x\":0,\"y\":21}"
                    },
                    {
                        "key": "panel2C4CAB72B002B845",
                        "structure": "{\"height\":9,\"width\":12,\"x\":12,\"y\":0}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "DA8113560381AEA2",
                    "key": "panelPANE-A5042C788B671A4B",
                    "title": "Destinations",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where srcDevice_ip matches \"{{ip}}\" or device_ip matches \"{{ip}}\"\n| where !isEmpty(dstDevice_ip)\n| count by dstDevice_ip\n| order by _count",
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
                    "id": "C304D46F833AEE98",
                    "key": "panelPANE-55B522E8B969DB49",
                    "title": "Sources",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where srcDevice_ip matches \"{{ip}}\"\n| where !isEmpty(srcDevice_ip)\n| count by srcDevice_ip\n| order by _count",
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
                    "id": "EF4BFC39583549D5",
                    "key": "panel2D26E0AE8C1A1841",
                    "title": "Connections by Hour + Country Code",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"overrides\":[],\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| timeslice 1h\n| where dstDevice_ip matches \"{{ip}}\" or srcDevice_ip matches \"{{ip}}\"\n| where !isEmpty(srcDevice_ip) and !isEmpty(dstDevice_ip) and !isEmpty(dstDevice_ip_countryCode)\n| count by _timeslice, dstDevice_ip_countryCode\n| transpose row _timeslice column dstDevice_ip_countryCode",
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
                    "id": "7351B5C3328D1F3B",
                    "key": "panelPANE-50FF0E72BB4E2B4C",
                    "title": "Ports",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where dstDevice_ip matches \"{{ip}}\" or srcDevice_ip matches \"{{ip}}\"\n| where !isEmpty(srcDevice_ip) and !isEmpty(dstDevice_ip)\n| count by dstPort\n| order by _count",
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
                    "id": "554214B73BAECA7C",
                    "key": "panel2C4CAB72B002B845",
                    "title": "DNS Queries",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where dstDevice_ip matches \"{{ip}}\" or srcDevice_ip matches \"{{ip}}\"\n| where !isEmpty(srcDevice_ip) and !isEmpty(dstDevice_ip) and !isEmpty(dns_query)\n| count by dns_query\n| order by _count",
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
            "variables": [
                {
                    "id": "B52BFFDE39346E38",
                    "name": "ip",
                    "displayName": null,
                    "defaultValue": "*",
                    "sourceDefinition": {
                        "variableSourceType": "LogQueryVariableSourceDefinition",
                        "query": "| \"*\" as ip",
                        "field": "ip"
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
                    "id": "BF572A31862390BC",
                    "key": "panelPANE-3D7A83B8BC3F0A42",
                    "title": "Event Trend",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| timeslice 1d\n| where metadata_product = \"Office 365\"\n| count by metadata_deviceEventId, _timeslice\n| transpose row _timeslice column metadata_deviceEventId",
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
                    "id": "B0C44EF50372FB17",
                    "key": "panelPANE-8D8B53FA8B7F0B48",
                    "title": "Successful Non-US Logins",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where metadata_product = \"Office 365\" and !(isEmpty(device_ip_countryCode) OR device_ip_countryCode = \"Unassigned\" OR device_ip_countryCode = \"US\" OR toLowerCase(user_username) = \"unknown\") and !isNull(success) and success\n| count by user_username, device_ip_countryCode\n| order by _count",
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
                    "id": "21AB8CD37381BA07",
                    "key": "panelPANE-FE7AC796B6FB284C",
                    "title": "Users that Successfully Logged in from 2+ Countries",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where metadata_product = \"Office 365\" and !(isEmpty(device_ip_countryCode) OR device_ip_countryCode = \"Unassigned\" OR toLowerCase(user_username) = \"unknown\") and !isNull(success) and success\n| count_distinct(device_ip_countryCode) by user_username\n| where _count_distinct > 1\n| order by _count_distinct",
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
                    "id": "D56AA922C86F5385",
                    "key": "panelPANE-D4B76A1FA14FB944",
                    "title": "User Account Lockouts - attempted logins on locked account for last 7 days",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where metadata_product = \"Office 365\" and fields matches \"*IdsLocked*\"\n| count by user_username",
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
                    "id": "E7CFBFE18D56B70B",
                    "key": "panelPANE-99D55CAAB2F7584F",
                    "title": "DLP Violations",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| json field=_raw \"Operation\"\n| where metadata_product = \"Office 365\" and (toLowerCase(Operation) matches \"*dlp*\" or toLowerCase(metadata_deviceEventId) matches \"*dlp*\")\n| count, last(fields) as details by user_username, metadata_deviceEventid, Operation\n| order by _count",
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
                    "id": "D503AAE2624A3BEC",
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
                    "id": "71F9A5CBE6616D52",
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
                    "id": "70E11C67DAC0D1A2",
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
                    "id": "28A5AE573EBBD52E",
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
                    "id": "1E4AAB630D18E444",
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
                    "id": "CCB7F6505205D162",
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
                    "id": "ADDCF4762430AA45",
                    "key": "panelPANE-FA7CB8BD98677B49",
                    "title": "Allowed Connections to IPs on Threat List",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| json field=_raw \"action\"\n| json field=_raw \"device_name\"\n| json field=_raw \"source_zone\"\n| where metadata_vendor matches \"Palo Alto*\" AND srcDevice_ip_isInternal AND !dstDevice_ip_isInternal AND action = \"allow\" AND listMatches matches \"*threat*\" AND listMatches matches \"*column:DstIp*\"\n| count by device_name,\n     srcDevice_ip,\n     srcDevice_ip_location,\n     source_zone,\n     listMatches,\n     dstDevice_ip,\n     dstPort,\n     dstDevice_ip_countryCode,\n     dstDevice_ip_isp,\n     dstDevice_ip_asnNumber\n| order by _count",
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
                    "id": "054F1B260B6AE270",
                    "key": "panelPANE-3688E28CA47B1B48",
                    "title": "Threat Events by Category",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"column\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"fillOpacity\":1,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| json field=_raw \"threat_category\"\n| json field=_raw \"severity\"\n| where metadata_vendor matches \"Palo Alto*\" and (severity = \"low\" or severity = \"medium\" or severity = \"high\" or severity = \"critical\")\n| count by threat_category\n| order by _count",
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
                    "id": "7FA697190F5958F1",
                    "key": "panel74DE34C4B3EE694A",
                    "title": "Threat Events by Severity",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"column\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"fillOpacity\":1,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| json field=_raw \"severity\"\n| where metadata_vendor matches \"Palo Alto*\" and (severity = \"low\" or severity = \"medium\" or severity = \"high\" or severity = \"critical\")\n| count by severity\n| order by _count",
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
                    "id": "0E187EC9AC18B1E1",
                    "key": "panelPANE-172A25D49EEA9A45",
                    "title": "Threat Events by Action",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"bar\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"fillOpacity\":1,\"mode\":\"timeSeries\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where metadata_vendor matches \"Palo Alto*\" and (severity = \"low\" or severity = \"medium\" or severity = \"high\" or severity = \"critical\") and !isEmpty(action)\n| count by action\n| order by _count",
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
                    "id": "00932C08ECC173DC",
                    "key": "panel72CEB7099B18C845",
                    "title": "Critical & High Severity IDS/IPS Events",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| json field=_raw \"severity\"\n| where metadata_vendor matches \"Palo Alto*\" and (severity = \"high\" or severity = \"critical\") and metadata_deviceEventId = \"PALO_FW_THREAT\"\n| count by action,\n  description,\n  device_ip,\n  dstDevice_ip,\n  dstDevice_natIp,\n  dstPort,\n  file_basename,\n  ipProtocol,\n  severity,\n  srcDevice_ip,\n  srcDevice_natIp,\n  srcPort,\n  threat_name,\n  user_username\n| order by _count",
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
                    "id": "ADAA18936C843904",
                    "key": "panelF70AF94EAF876847",
                    "title": "Palo Alto Correlation Alerts",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| json field=_raw \"category\" nodrop\n| json field=_raw \"device_name\" nodrop\n| json field=_raw \"dg_hierarchy_1\" nodrop\n| json field=_raw \"dg_hierarchy_2\" nodrop\n| json field=_raw \"dg_hierarchy_3\" nodrop\n| json field=_raw \"dg_hierarchy_4\" nodrop\n| json field=_raw \"evidence\" nodrop\n| json field=_raw \"generated_time\" nodrop\n| json field=_raw \"object_id\" nodrop\n| json field=_raw \"object_name\" nodrop\n| json field=_raw \"source_ip\" nodrop\n| json field=_raw \"sub_type\" nodrop\n| json field=_raw \"username\" nodrop\n| json field=_raw \"virtual_system\" nodrop\n| json field=_raw \"virtual_system_id\" nodrop\n| json field=_raw \"virtual_system_name\" nodrop\n| where metadata_vendor matches \"Palo Alto*\" and !(severity = \"low\" or severity = \"informational\") and metadata_deviceEventId = \"PALO_FW_CORRELATION\"\n| count by description,\ndevice_ip,\nsrcDevice_ip,\nthreat_name,\nuser_username,\ncategory,\ndevice_name,\ndg_hierarchy_1,\ndg_hierarchy_2,\ndg_hierarchy_3,\ndg_hierarchy_4,\nevidence,\ngenerated_time,\nobject_id,\nobject_name,\nseverity,\nsource_ip,\nsub_type,\nusername,\nvirtual_system,\nvirtual_system_id,\nvirtual_system_name\n| order by _count",
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
                    "id": "4C440DB80BC14DB1",
                    "key": "panelPANE-57DF0D38A28B5A4F",
                    "title": "Proofpoint Phishing Emails Clicked",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where metadata_vendor = \"Proofpoint\" and metadata_product = \"Targeted Attack Protection\" AND !(toLowerCase(metadata_deviceEventId) = \"message_blocked\" or toLowerCase(metadata_deviceEventId) = \"message_permitted\") AND (threat_name = \"spam\" or threat_name = \"phish\" or threat_name = \"malware\")\n| count by action,\n  device_ip,\n  email_sender,\n  http_url,\n  http_userAgent,\n  srcDevice_ip,\n  threat_name,\n  threat_referenceUrl,\n  timestamp,\n  user_email,\n  user_username\n| order by _count",
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
            "name": "Signal Overview",
            "description": "",
            "title": "Signal Overview",
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
                        "key": "panelPANE-15758D7FBF7E0B46",
                        "structure": "{\"height\":12,\"width\":24,\"x\":0,\"y\":0}"
                    },
                    {
                        "key": "panel54E99200ABB9DB4A",
                        "structure": "{\"height\":12,\"width\":14,\"x\":0,\"y\":32}"
                    },
                    {
                        "key": "panel4B2686C2A08F3B4B",
                        "structure": "{\"height\":10,\"width\":14,\"x\":0,\"y\":12}"
                    },
                    {
                        "key": "panel546FA2399FFF994F",
                        "structure": "{\"height\":6,\"width\":14,\"x\":0,\"y\":56}"
                    },
                    {
                        "key": "panelF49EF78DBC736945",
                        "structure": "{\"height\":10,\"width\":10,\"x\":14,\"y\":12}"
                    },
                    {
                        "key": "panelBC23FADDBAB31A4E",
                        "structure": "{\"height\":12,\"width\":10,\"x\":14,\"y\":32}"
                    },
                    {
                        "key": "panel3556C1C0B7B9A841",
                        "structure": "{\"height\":10,\"width\":10,\"x\":14,\"y\":56}"
                    },
                    {
                        "key": "panel0AC3AC72AA9BC843",
                        "structure": "{\"height\":10,\"width\":24,\"x\":0,\"y\":22}"
                    },
                    {
                        "key": "panel4F3574C7AA54FB46",
                        "structure": "{\"height\":12,\"width\":24,\"x\":0,\"y\":44}"
                    },
                    {
                        "key": "panelC7D2979DB112684D",
                        "structure": "{\"height\":10,\"width\":24,\"x\":0,\"y\":66}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "4D267907895F060D",
                    "key": "panelPANE-15758D7FBF7E0B46",
                    "title": "Top Signals by Rule Name",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"column\",\"displayType\":\"default\",\"fillOpacity\":1,\"mode\":\"distribution\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"title\":\"\",\"titleFontSize\":12,\"labelFontSize\":12,\"logarithmic\":false}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"Categorical Default\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_sourceCategory=asoc/SIGNAL/*\n| json field=_raw \"rule_name\"\n| where rule_name matches \"{{{rule_name}}}\"\n| json field=_raw \"asset.name\" as name\n| where name matches \"{{{device_hostname}}}\" and name matches \"{{{device_ip}}}\" and name matches \"{{{user_username}}}\"\n| count by rule_name\n| order by _count\n| limit 10",
                            "queryType": "Logs",
                            "queryKey": "A",
                            "metricsQueryMode": null,
                            "metricsQueryData": null,
                            "tracesQueryData": null,
                            "parseMode": "Manual",
                            "timeSource": "Message"
                        }
                    ],
                    "description": "Sign",
                    "timeRange": null,
                    "coloringRules": null,
                    "linkedDashboards": [
                        {
                            "id": "d4rAxxe1dRt6cq0Qod7cM9UmZ2zOmjAubtdYOCSJVx0QVN8JtuFgqS9ilIsB",
                            "relativePath": "",
                            "includeTimeRange": true,
                            "includeVariables": true
                        }
                    ]
                },
                {
                    "id": "04B73221F2AB0434",
                    "key": "panel54E99200ABB9DB4A",
                    "title": "Top Signals by User",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"column\",\"displayType\":\"default\",\"fillOpacity\":1,\"mode\":\"distribution\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"title\":\"\",\"titleFontSize\":12,\"labelFontSize\":12,\"logarithmic\":false}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"Categorical Default\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_sourceCategory=asoc/SIGNAL/*\n| json field=_raw \"rule_name\"\n| json field=_raw \"asset.asset_type\" as type\n| where type = \"username\"\n| json field=_raw \"asset.name\" as user_username\n| where rule_name matches \"{{{rule_name}}}\"\n| where user_username matches \"{{{user_username}}}\"\n| count by user_username, rule_name\n| order by _count\n| limit 10",
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
                    "linkedDashboards": [
                        {
                            "id": "d4rAxxe1dRt6cq0Qod7cM9UmZ2zOmjAubtdYOCSJVx0QVN8JtuFgqS9ilIsB",
                            "relativePath": "",
                            "includeTimeRange": true,
                            "includeVariables": true
                        }
                    ]
                },
                {
                    "id": "F77E21BBFB42A473",
                    "key": "panel4B2686C2A08F3B4B",
                    "title": "Top Signals by Host",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"column\",\"displayType\":\"default\",\"fillOpacity\":1,\"mode\":\"distribution\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"title\":\"\",\"titleFontSize\":12,\"labelFontSize\":12,\"logarithmic\":false}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"Categorical Default\"},\"overrides\":[],\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_sourceCategory=asoc/SIGNAL/*\n| json field=_raw \"rule_name\"\n| json field=_raw \"asset.asset_type\" as type\n| where type = \"hostname\" \n| json field=_raw \"asset.name\" as device_hostname\n| where rule_name matches \"{{{rule_name}}}\"\n| where device_hostname matches \"{{{device_hostname}}}\"\n| count by device_hostname, rule_name\n| order by _count\n| limit 10",
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
                    "linkedDashboards": [
                        {
                            "id": "d4rAxxe1dRt6cq0Qod7cM9UmZ2zOmjAubtdYOCSJVx0QVN8JtuFgqS9ilIsB",
                            "relativePath": "",
                            "includeTimeRange": true,
                            "includeVariables": true
                        }
                    ]
                },
                {
                    "id": "C98445FD651AE059",
                    "key": "panel546FA2399FFF994F",
                    "title": "Top Signals by IP",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"column\",\"displayType\":\"default\",\"fillOpacity\":1,\"mode\":\"distribution\"},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"title\":\"\",\"titleFontSize\":12,\"labelFontSize\":12,\"logarithmic\":false}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"Categorical Default\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_sourceCategory=asoc/SIGNAL/*\n| json field=_raw \"rule_name\"\n| json field=_raw \"asset.asset_type\" as type\n| where type = \"ip\"\n| json field=_raw \"asset.name\" as device_ip\n| where rule_name matches \"{{{rule_name}}}\"\n| where device_ip matches \"{{{device_ip}}}\"\n| count by device_ip, rule_name\n| order by _count\n| limit 10",
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
                    "linkedDashboards": [
                        {
                            "id": "d4rAxxe1dRt6cq0Qod7cM9UmZ2zOmjAubtdYOCSJVx0QVN8JtuFgqS9ilIsB",
                            "relativePath": "",
                            "includeTimeRange": true,
                            "includeVariables": true
                        }
                    ]
                },
                {
                    "id": "7B3CD643A287842A",
                    "key": "panelF49EF78DBC736945",
                    "title": "Top Signals by Host",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"distribution\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_sourceCategory=asoc/SIGNAL/*\n| json field=_raw \"rule_name\"\n| json field=_raw \"asset.asset_type\" as type\n| where type = \"hostname\"\n| json field=_raw \"asset.name\" as device_hostname\n| where rule_name matches \"{{{rule_name}}}\"\n| where device_hostname matches \"{{{device_hostname}}}\"\n| count by device_hostname, rule_name\n| order by _count",
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
                    "id": "523C57FFB495435D",
                    "key": "panelBC23FADDBAB31A4E",
                    "title": "Top Signals by User ",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"distribution\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_sourceCategory=asoc/SIGNAL/*\n| json field=_raw \"rule_name\"\n| json field=_raw \"asset.asset_type\" as type\n| where type = \"username\"\n| json field=_raw \"asset.name\" as user_username\n| where rule_name matches \"{{{rule_name}}}\"\n| where user_username matches \"{{{user_username}}}\"\n| count by user_username, rule_name\n| order by _count",
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
                    "id": "3B96FBFF7767F180",
                    "key": "panel3556C1C0B7B9A841",
                    "title": "Top Signals by IP",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"distribution\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_sourceCategory=asoc/SIGNAL/*\n| json field=_raw \"rule_name\"\n| json field=_raw \"asset.asset_type\" as type\n| where type = \"ip\"\n| json field=_raw \"asset.name\" as device_ip\n| where rule_name matches \"{{{rule_name}}}\"\n| where device_ip matches \"{{{device_ip}}}\"\n| count by device_ip, rule_name\n| order by _count",
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
                    "id": "59BE72FE6CA69D80",
                    "key": "panel0AC3AC72AA9BC843",
                    "title": "Signals by Host - Log Reduce",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"distribution\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_sourceCategory=asoc/SIGNAL/*\n| json field=_raw \"rule_name\"\n| json field=_raw \"asset.asset_type\" as type\n| where type = \"hostname\"\n| json field=_raw \"asset.name\" as device_hostname\n| where rule_name matches \"{{{rule_name}}}\"\n| where device_hostname matches \"{{{device_hostname}}}\"\n| json field=_raw \"full_records[0].baseImage\" as baseImage nodrop\n| json field=_raw \"full_records[0].parentBaseImage\" as parentBaseImage nodrop\n| json field=_raw \"full_records[0].action\" as action nodrop\n| json field=_raw \"full_records[0].commandLine\" as commandLine nodrop\n| json field=_raw \"full_records[0].listMatches\" as listMatches nodrop\n| json field=_raw \"full_records[0].user_username\" as user_username nodrop\n| json field=_raw \"full_records[0].device_hostname\" as device_hostname nodrop\n| json field=_raw \"full_records[0].device_ip\" as device_ip nodrop\n| json field=_raw \"full_records[0].http_url_rootDomain\" as http_url_rootDomain nodrop\n| logreduce values on baseImage, parentBaseImage, action, commandLine, listMatches, user_username, device_hostname, device_ip, http_url_rootDomain\n| order by _count",
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
                    "id": "CB486DF4F500CE7D",
                    "key": "panel4F3574C7AA54FB46",
                    "title": "Signals by User - Log Reduce",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"distribution\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_sourceCategory=asoc/SIGNAL/*\n| json field=_raw \"rule_name\"\n| json field=_raw \"asset.asset_type\" as type\n| where type = \"username\"\n| json field=_raw \"asset.name\" as user_username\n| where rule_name matches \"{{{rule_name}}}\"\n| where user_username matches \"{{{user_username}}}\"\n| json field=_raw \"full_records[0].baseImage\" as baseImage nodrop\n| json field=_raw \"full_records[0].parentBaseImage\" as parentBaseImage nodrop\n| json field=_raw \"full_records[0].action\" as action nodrop\n| json field=_raw \"full_records[0].commandLine\" as commandLine nodrop\n| json field=_raw \"full_records[0].listMatches\" as listMatches nodrop\n| json field=_raw \"full_records[0].user_username\" as user_username nodrop\n| json field=_raw \"full_records[0].device_hostname\" as device_hostname nodrop\n| json field=_raw \"full_records[0].device_ip\" as device_ip nodrop\n| json field=_raw \"full_records[0].http_url_rootDomain\" as http_url_rootDomain nodrop\n| logreduce values on baseImage, parentBaseImage, action, commandLine, listMatches, user_username, device_hostname, device_ip, http_url_rootDomain\n| order by _count",
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
                    "id": "9A81D1B937D6BF46",
                    "key": "panelC7D2979DB112684D",
                    "title": "Signals by IP - Log Reduce",
                    "visualSettings": "{\"title\":{\"fontSize\":14},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"distribution\"},\"axes\":{\"axisX\":{\"titleFontSize\":12,\"labelFontSize\":12},\"axisY\":{\"titleFontSize\":12,\"labelFontSize\":12}},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_sourceCategory=asoc/SIGNAL/*\n| json field=_raw \"rule_name\"\n| json field=_raw \"asset.asset_type\" as type\n| where type = \"ip\"\n| json field=_raw \"asset.name\" as device_ip\n| where rule_name matches \"{{{rule_name}}}\"\n| where device_ip matches \"{{{device_ip}}}\"\n| json field=_raw \"full_records[0].baseImage\" as baseImage nodrop\n| json field=_raw \"full_records[0].parentBaseImage\" as parentBaseImage nodrop\n| json field=_raw \"full_records[0].action\" as action nodrop\n| json field=_raw \"full_records[0].commandLine\" as commandLine nodrop\n| json field=_raw \"full_records[0].listMatches\" as listMatches nodrop\n| json field=_raw \"full_records[0].user_username\" as user_username nodrop\n| json field=_raw \"full_records[0].device_hostname\" as device_hostname nodrop\n| json field=_raw \"full_records[0].device_ip\" as device_ip nodrop\n| json field=_raw \"full_records[0].http_url_rootDomain\" as http_url_rootDomain nodrop\n| logreduce values on baseImage, parentBaseImage, action, commandLine, listMatches, user_username, device_hostname, device_ip, http_url_rootDomain\n| order by _count",
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
            "variables": [
                {
                    "id": "7E4948BC833F3672",
                    "name": "device_ip",
                    "displayName": "device_ip",
                    "defaultValue": "*",
                    "sourceDefinition": {
                        "variableSourceType": "LogQueryVariableSourceDefinition",
                        "query": "| \"*\" as device_ip",
                        "field": "device_ip"
                    },
                    "allowMultiSelect": false,
                    "includeAllOption": true,
                    "hideFromUI": false
                },
                {
                    "id": "B8C6FA44E48FFA02",
                    "name": "user_username",
                    "displayName": "user_username",
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
                    "id": "54619AF0DDDE7C10",
                    "name": "device_hostname",
                    "displayName": "device_hostname",
                    "defaultValue": "*",
                    "sourceDefinition": {
                        "variableSourceType": "LogQueryVariableSourceDefinition",
                        "query": "\n| \"*\" as device_hostname",
                        "field": "device_hostname"
                    },
                    "allowMultiSelect": false,
                    "includeAllOption": true,
                    "hideFromUI": false
                },
                {
                    "id": "A7613303B321D0F8",
                    "name": "rule_name",
                    "displayName": "rule_name",
                    "defaultValue": "*",
                    "sourceDefinition": {
                        "variableSourceType": "LogQueryVariableSourceDefinition",
                        "query": "\n| \"*\" as rule_name",
                        "field": "rule_name"
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
                    "id": "6BBC0AAFA88DA619",
                    "key": "panelPANE-6FABC1E2A454CB4F",
                    "title": "Event Trend",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| timeslice 1d\n| where metadata_vendor = \"Trend Micro\"\n| count by metadata_vendor, metadata_product, metadata_deviceEventId, _timeslice\n| transpose row _timeslice column metadata_vendor, metadata_product, metadata_deviceEventId",
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
            "name": "User Search",
            "description": "",
            "title": "User Search",
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
                        "key": "panelPANE-FD43A8AE91DB9A49",
                        "structure": "{\"height\":8,\"width\":24,\"x\":0,\"y\":0}"
                    },
                    {
                        "key": "panelPANE-6719B4D9AFE3A946",
                        "structure": "{\"height\":8,\"width\":12,\"x\":0,\"y\":9}"
                    },
                    {
                        "key": "panel2950191E8CBCA844",
                        "structure": "{\"height\":8,\"width\":12,\"x\":12,\"y\":8}"
                    },
                    {
                        "key": "panelA104F25D8A3AB849",
                        "structure": "{\"height\":8,\"width\":12,\"x\":12,\"y\":16}"
                    },
                    {
                        "key": "panel6B2436FBAC8AFA4D",
                        "structure": "{\"height\":8,\"width\":12,\"x\":0,\"y\":15}"
                    }
                ]
            },
            "panels": [
                {
                    "id": "95C14397539F2B57",
                    "key": "panelPANE-FD43A8AE91DB9A49",
                    "title": "Events by Vendor/Product",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| timeslice 1h\n| where !isEmpty(user_username)\n| where user_username matches \"{{user_username}}\"\n| count by _timeslice, metadata_vendor, metadata_product\n| transpose row _timeslice column metadata_vendor, metadata_product",
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
                    "id": "787AB41F50587DE8",
                    "key": "panelPANE-6719B4D9AFE3A946",
                    "title": "Logins by Location/Country",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where user_username matches \"{{user_username}}\"\n| where metadata_deviceEventId = \"Security-4624\" or metadata_deviceEventId = \"Security-4625\"\n| count by device_ip, device_ip_location, device_ip_countryCode, success\n| order by _count",
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
                    "id": "B1CA04D62B74981B",
                    "key": "panel2950191E8CBCA844",
                    "title": "CB Events",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where user_username matches \"{{user_username}}\"\n| where metadata_vendor = \"Carbon Black\"\n| count by threat_name\n| order by _count",
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
                    "id": "241AFE07424E7510",
                    "key": "panelA104F25D8A3AB849",
                    "title": "Linux Messages",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where user_username matches \"{{user_username}}\"\n| where metadata_vendor = \"Linux\"\n| json field=_raw \"process\", \"hostname\", \"src_ip\"\n| count by action, process, hostname, src_ip\n| order by _count",
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
                    "id": "576E6C7031D5BE1C",
                    "key": "panel6B2436FBAC8AFA4D",
                    "title": "OpenSSH",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"outlierBandColor\":\"#FDECF5\",\"outlierBandMarkerColor\":\"#F032A9\",\"outlierBandFillOpacity\":0.5,\"outlierBandLineThickness\":2,\"outlierBandMarkerSize\":10,\"outlierBandMarkerType\":\"triangle\",\"outlierBandLineDashType\":\"solid\",\"outlierBandDisplayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where user_username matches \"{{user_username}}\"\n| where metadata_vendor = \"OpenSSH\"\n| json field=_raw \"username\", \"port\", \"client\"\n| count by username, port, client\n| order by _count",
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
            "variables": [
                {
                    "id": "8A68319B4ED5CAB4",
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
                }
            ],
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
                    "id": "573B5DB335DFE4A0",
                    "key": "panelPANE-B7EA901F90DE9B40",
                    "title": "Windows Event Trend by Event ID",
                    "visualSettings": "{\"general\":{\"mode\":\"timeSeries\",\"type\":\"line\",\"displayType\":\"default\",\"markerSize\":0,\"lineDashType\":\"solid\",\"markerType\":\"none\",\"lineThickness\":2},\"title\":{\"fontSize\":16},\"axes\":{\"axisX\":{\"showLabels\":true,\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":10},\"axisY\":{\"showLabels\":true,\"title\":\"\",\"titleFontSize\":11,\"labelFontSize\":12,\"logarithmic\":false,\"gridColor\":\"#dde4e9\"}},\"legend\":{\"enabled\":true,\"verticalAlign\":\"bottom\",\"fontSize\":12,\"maxHeight\":50,\"showAsTable\":false,\"wrap\":true},\"color\":{\"family\":\"scheme9\"},\"series\":{},\"overrides\":[]}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| timeslice 1d\n| where metadata_vendor = \"Microsoft\" and metadata_product = \"Windows\"\n| count by metadata_vendor, metadata_product, metadata_deviceEventId, _timeslice\n| transpose row _timeslice column metadata_vendor, metadata_product, metadata_deviceEventId",
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
                    "id": "F94821EBBEE18DE6",
                    "key": "panelPANE-AEC2DE16BA47B943",
                    "title": "Admin Password Resets",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where metadata_vendor = \"Microsoft\" and metadata_product = \"Windows\" and user_username matches \"*adm_*\" AND metadata_deviceEventId = \"Security-4724\"\n| count by user_username, device_hostname\n| order by _count",
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
                    "id": "4750476B0288BBA3",
                    "key": "panelDCA9934A874E2940",
                    "title": "Users Added to Global Security Groups",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| json field=_raw \"Computer\" as computer\n| json field=_raw \"$['EventData.TargetUserName']\" as target\n| where metadata_vendor = \"Microsoft\" and metadata_product = \"Windows\" AND metadata_deviceEventId IN (\"Security-4728\", \"Security-4732\", \"Security-4756\")\n| count by user_username, device_hostname, computer, target\n| order by _count",
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
                    "id": "0E153E707FFF8C77",
                    "key": "panel361FF294A4F29B4F",
                    "title": "Service Accounts with Interactive Logins",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| json field=_raw \"LogonType\" as logontype\n| where metadata_vendor = \"Microsoft\" and metadata_product = \"Windows\" AND metadata_deviceEventId IN (\"Security-4624\", \"Security-4625\") and logontype = \"2\" and user_username matches \"*svc_*\"\n| count by user_username, device_hostname\n| order by _count",
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
                    "id": "39CCF916F6069DD2",
                    "key": "panelD6F18170A8D0484E",
                    "title": "Account Lockouts",
                    "visualSettings": "{\"title\":{\"fontSize\":16},\"general\":{\"type\":\"table\",\"displayType\":\"default\",\"paginationPageSize\":100,\"fontSize\":12,\"mode\":\"timeSeries\"},\"series\":{}}",
                    "keepVisualSettingsConsistentWithParent": true,
                    "panelType": "SumoSearchPanel",
                    "queries": [
                        {
                            "queryString": "_index=sec_record_*\n| where metadata_vendor = \"Microsoft\" and metadata_product = \"Windows\" AND metadata_deviceEventId = \"Security-4740\"\n| count by user_username\n| order by _count",
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