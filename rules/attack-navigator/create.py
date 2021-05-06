import requests 
import logging
import dateutil.parser
from collections import defaultdict
import os
import json

# environment variables
cse_api_key = os.environ['CSE_API_KEY']
cse_tenant_name = os.environ['CSE_TENANT_NAME']
headers = {'X-API-KEY': cse_api_key}

def load_rules():
    hasNextPage = True
    offset = 0
    rules = {}
    while hasNextPage:
        rules_url = f'https://{cse_tenant_name}.portal.jask.ai/api/v1/rules?&offset={offset}&limit=100'
        r = requests.get(rules_url, headers=headers)
        rules_data = r.json()['data']['objects']
        for rule in rules_data:
            if 'tags' in rule:
                rules[rule['id']] = {}
                rules[rule['id']]['id_compiled'] = rule['id']
                rules[rule['id']]['tags'] = rule['tags']


        if r.json()['data']['hasNextPage'] == True:
            hasNextPage = True
            offset += 100
        else:
            hasNextPage = False  
    print(rules)
    return rules



def load_mitre_attack_enterprise():
    logging.info("Loading MITRE ATT&CK Enterprise data")

    # Define output
    ATTACK = {
        "tactics": {},
        "techniques": {},
        "sub-techniques": {}
    }

    # Load the data from GitHub
    stix2_json = requests.get(url="https://github.com/mitre/cti/raw/master/enterprise-attack/enterprise-attack.json").json()

    # Load tactics
    for item in stix2_json["objects"]:
        if item["type"] == "x-mitre-tactic":

            # Lookup ID and URL
            tactic_id = None
            tactic_url = None
            for ref in item["external_references"]:
                if ref["source_name"] == "mitre-attack":
                    tactic_id = ref["external_id"]
                    tactic_url = ref["url"]

            # Save object
            ATTACK["tactics"][tactic_id] = {
                "created": dateutil.parser.parse(item["created"]),
                "modified": dateutil.parser.parse(item["modified"]),
                "name": item["name"],
                "description": item["description"],
                "short_name": item["x_mitre_shortname"],
                "url": tactic_url
            }

    # Load techniques
    for item in stix2_json["objects"]:
        if item["type"] == "attack-pattern":
            if item.get("revoked", False) == False:  # Skip techniques no longer supported
                if item["x_mitre_is_subtechnique"] == False:  #Skip sub-techniques

                    # Lookup ID and URL
                    technique_id = None
                    technique_url = None
                    for ref in item["external_references"]:
                        if ref["source_name"] == "mitre-attack":
                            technique_id = ref["external_id"]
                            technique_url = ref["url"]

                    # Lookup associated tactics
                    tactic_ids = []
                    tactic_names = set()
                    for phase in item["kill_chain_phases"]:
                        if phase["kill_chain_name"] == "mitre-attack":
                            tactic_names.add(phase["phase_name"])
                    for tactic_id, tactic in ATTACK["tactics"].items():
                        for tactic_name in tactic_names:
                            if tactic_name == tactic["short_name"]:
                                tactic_ids.append(tactic_id)

                    # Save object
                    ATTACK["techniques"][technique_id] = {
                        "created": dateutil.parser.parse(item["created"]),
                        "modified": dateutil.parser.parse(item["modified"]),
                        "name": item["name"],
                        "description": item["description"],
                        "tactics": tactic_ids,
                        "url": technique_url
                    }
        
    # Tactics - Add Techniques
    temp = defaultdict(list)
    for technique_id, technique in ATTACK["techniques"].items():
        for tactic in technique["tactics"]:
            temp[tactic].append(technique_id)
    for tactic_id, technique_ids in temp.items():
        ATTACK["tactics"][tactic_id]["techniques"] = technique_ids


    # Load Sub-Techniques
    for item in stix2_json["objects"]:
        if item["type"] == "attack-pattern":
            if item.get("revoked", False) == False:  # Skip no longer supported objects
                if item["x_mitre_is_subtechnique"] == True:  # sub-techniques

                    # Lookup ID and URL
                    sub_technique_id = None
                    sub_technique_url = None
                    for ref in item["external_references"]:
                        if ref["source_name"] == "mitre-attack":
                            sub_technique_id = ref["external_id"]
                            sub_technique_url = ref["url"]

                    # Lookup associated tactics
                    tactic_ids = []
                    tactic_names = set()
                    for phase in item["kill_chain_phases"]:
                        if phase["kill_chain_name"] == "mitre-attack":
                            tactic_names.add(phase["phase_name"])
                    for tactic_id, tactic in ATTACK["tactics"].items():
                        for tactic_name in tactic_names:
                            if tactic_name == tactic["short_name"]:
                                tactic_ids.append(tactic_id)

                    # Save object
                    ATTACK["sub-techniques"][sub_technique_id] = {
                        "created": dateutil.parser.parse(item["created"]),
                        "modified": dateutil.parser.parse(item["modified"]),
                        "name": item["name"],
                        "description": item["description"],
                        "tactics": tactic_ids,
                        "technique": sub_technique_id.split(".")[0],
                        "url": technique_url
                    }

    # Tactics - Add Sub-Techniques
    temp = defaultdict(list)
    for sub_technique_id, sub_technique in ATTACK["sub-techniques"].items():
        for tactic in sub_technique["tactics"]:
            temp[tactic].append(sub_technique_id)
    for tactic_id, sub_technique_ids in temp.items():
        ATTACK["tactics"][tactic_id]["sub-techniques"] = sub_technique_ids

    # All done organizing, return results
    return ATTACK

def attack_nav_sumo_layer(attack_enterprise, rules):
    IMPORT_JSON = {
        "name": "Sumo Logic Rule Coverage",
        "versions": {
            "attack": "8",
            "navigator": "4.2",
            "layer": "4.1"
        },
        "domain": "enterprise-attack",
        "description": "Maps Sumo Logic rules to the Mitre Att&ck framework.",
        "filters": {
            "platforms": [
                "Linux",
                "macOS",
                "Windows",
                "Office 365",
                "Azure AD",
                "AWS",
                "GCP",
                "Azure",
                "SaaS",
                "PRE",
                "Network"
            ]
        },
        "sorting": 0,
        "layout": {
            "layout": "side",
            "showID": False,
            "showName": True
        },
        "hideDisabled": False,
        "techniques": [],
        "gradient": {
            "colors": [
                "#fff2af",
                "#c0d373",
                "#6cb211"
            ],
            "minValue": 1,
            "maxValue": 5
        },
        "legendItems": [],
        
        "showTacticRowBackground": True,
        "tacticRowBackground": "#dddddd",
        "selectTechniquesAcrossTactics": True,
        "selectSubtechniquesWithParent": False
    }


    heat_map_data = []
    for tactic in attack_enterprise["tactics"].values():
        for technique in tactic["techniques"]:

            # Template
            data = {
                "techniqueID": technique,
                "tactic": tactic["short_name"],
                "score": 0,
                "color": "",
                "comment": None,
                "enabled": True,
                "metadata": [],
                "showSubtechniques": False
            }

            # Check rule tags
            rule_ids = set()
            for rule in rules.values():
                for tag in rule["tags"]:
                    if technique in tag:
                        data["score"] += 1
                        rule_ids.add(rule["id_compiled"])
            
            if data["score"]:
                data["comment"] = "\n".join(sorted(list(rule_ids)))
                heat_map_data.append(data)
            else:
                data["score"] = None
                data["enabled"] = False
                heat_map_data.append(data)

    # Add the techniques to the overall main JSON
    IMPORT_JSON["techniques"] = heat_map_data

    # Save file
    with open("attack_nav_sumo_logic.json", "w") as file_handle:
        json.dump(IMPORT_JSON, file_handle, indent=4, sort_keys=True)

if __name__ == '__main__':
    attack_enterprise = load_mitre_attack_enterprise()
    rules = load_rules()
    attack_nav_sumo_layer(attack_enterprise, rules)