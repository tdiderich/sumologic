#!/usr/bin/env python3
import os
import json
import requests
import logging
import base64
from requests.auth import HTTPBasicAuth

# environment variables
cip_access_id = os.environ['CIP_ACCESS_ID']
cip_access_key = os.environ['CIP_ACCESS_KEY']
cip_deployment = os.environ['CIP_DEPLOYMENT']

# do not touch variables
# match_list_url = f'https://api.{cip_deployment}.sumologic.com/api/sec/v1/match-lists'
match_list_url = 'https://long-api.sumologic.net/api/sec/v1/match-lists'


def create_match_lists(lists):
    for l in lists:
        payload = {
                "fields": {
                    "active": True,
                    "defaultTtl": 0,
                    "description": l['description'],
                    "name": l['name'],
                    "targetColumn": l['targetColumn']
                }
            }
        r = requests.post(match_list_url, auth=HTTPBasicAuth(cip_access_id, cip_access_key), json=payload)   
        if r.status_code

def main():

    # need to add https://help.sumologic.com/Cloud_SIEM_Enterprise/Match_Lists/Standard_Match_Lists#verified_uri_paths-1
    lists = [
        {'name': 'admin_ips', 'description': 'Hosts that are known to be involved with specific administrative or privileged activity on the network. Can be used for tracking hosts that are operated by admins and other privileged users, or are often the source of restricted, privileged or suspicious authorized actions, and so on. This sort of tracking is useful for baselining activity and as a result, surfacing more suspicious activity.', 'targetColumn': 'SrcIp'}, 
        {'name': 'auth_servers', 'description': 'Network authentication servers, including Active Directory, LDAP, Kerberos, RADIUS/TACACS, and NIS servers. May be used in analytics designed to detect DCSync attacks.', 'targetColumn': 'Ip'}, 
        {'name': 'auth_servers_dst', 'description': 'Copy of the auth_servers Match List for directional matches.', 'targetColumn': 'DstIp'}, 
        {'name': 'auth_servers_src', 'description': 'Copy of the auth_servers Match List for directional matches.', 'targetColumn': 'SrcIp'}, 
        {'name': 'business_asns', 'description': 'Remote ASNs supporting business processes.', 'targetColumn': 'Asn'}, 
        {'name': 'business_domains', 'description': 'DNS domain names that are known business-related domains. This is intended to capture domains related to validated, expected, or critical business functions and may be used for allowlisting or filtering related uninteresting results from query result sets.', 'targetColumn': 'Domain'}, 
        {'name': 'business_hostnames', 'description': 'DNS hostnames that are known to be business-related FQDNs.', 'targetColumn': 'Hostname'}, 
        {'name': 'business_ips', 'description': 'Remote IP addresses supporting business processes. Can be used for things like SSH servers for SFTP file exchanges (similarly, FTP servers).', 'targetColumn': 'Ip'}, 
        {'name': 'dns_servers', 'description': 'DNS caching resolvers/authoritative content servers in customer environments.', 'targetColumn': 'Ip'}, 
        {'name': 'dns_servers_dst', 'description': 'Copy of the dns_servers Match List for directional matches.', 'targetColumn': 'SrcIp'}, 
        {'name': 'dns_servers_src', 'description': 'Copy of the dns_servers Match List for directional matches.', 'targetColumn': 'DstIp'}, 
        {'name': 'downgrade_krb5_etype_authorized_users', 'description': 'Known account names that utilize downgraded encryption types with multiple SPNs. This is an exception Match List that should be populated with a list of Kerberos principal names (for example,  jdoe@EXAMPLE.COM) matched in endpoint username that are known to trigger content around legacy downgraded encryption types. This is directly related to the detection of Kerberoasting attacks.', 'targetColumn': 'Username'}, 
        {'name': 'ds_replication_authorized_users', 'description': 'Authorized account names to initiate Directory Service Replication requests to Active Directory.', 'targetColumn': 'Username'}, 
        {'name': 'ftp_servers', 'description': 'Known FTP servers.', 'targetColumn': 'Ip'}, 
        {'name': 'guest_networks', 'description': 'Known guest WLAN and other guests/BYOD network addresses.', 'targetColumn': 'Ip'}, 
        {'name': 'lan_scanner_exception_ips', 'description': 'IP addresses excepted from analytics identifying LAN protocol scanning activity. Used in specific cases to exclude hosts from flagging particular types of rule content, primarily around scanning of commonly targeted LAN service ports, etc. Not an across-the-board allowlist. This Match List is not intended for vulnerability scanners, which should be listed instead in vuln scanners.', 'targetColumn': 'Ip'}, 
        {'name': 'nat_ips', 'description': 'Source NAT addresses. Can be used as an exception Match List to block content relying on the evaluation of data per-host from applying to hosts that are translated or aggregations of other hosts. Note that this can also be applied using proxy_servers as an example of a specific case.', 'targetColumn': 'Ip'}, 
        {'name': 'nms_ips', 'description': 'Hosts known to be Network Management System (NMS) nodes.', 'targetColumn': 'Ip'}, 
        {'name': 'palo_alto_sinkhole_ips', 'description': 'IP addresses for the sinkhole IP or IPs configured for Palo Alto DNS sinkhole.', 'targetColumn': 'Ip'}, 
        {'name': 'proxy_servers', 'description': 'Forward proxy servers, including HTTP and SOCKS proxies.', 'targetColumn': 'Ip'}, 
        {'name': 'proxy_servers_dst', 'description': 'Copy of the proxy_servers Match List for directional matches.', 'targetColumn': 'DstIp'}, 
        {'name': 'proxy_servers_src', 'description': 'Copy of the proxy_server Match List for directional matches.', 'targetColumn': 'SrcIp'}, 
        {'name': 'sandbox_ips', 'description': 'Malware sandboxes or security devices interacting with malicious infrastructure.', 'targetColumn': 'Ip'}, 
        {'name': 'scanner_targets', 'description': 'Destination networks that are authorized/standard targets of vulnerability scans in customer environment.', 'targetColumn': 'Ip'}, 
        {'name': 'smtp_servers', 'description': 'SMTP sending/receiving hosts in customer environment.', 'targetColumn': 'Ip'}, 
        {'name': 'sql_servers', 'description': 'Database servers in customer environment.', 'targetColumn': 'Ip'}, 
        {'name': 'ssh_servers', 'description': 'Known SSH servers.', 'targetColumn': 'Ip'}, 
        {'name': 'telnet_servers', 'description': 'Telnet servers in your environment.', 'targetColumn': 'Ip'}, 
        {'name': 'threat', 'description': 'A record flagged an IP address from a threat intelligence Match List.', 'targetColumn': 'Ip'}, 
        {'name': 'vpn_networks', 'description': 'VPN/remote access user address pools and DHCP scopes.', 'targetColumn': 'Ip'}, 
        {'name': 'vpn_servers', 'description': 'VPN/remote access servers, including IKE/IPsec/SSL VPN concentrators, OpenVPN endpoints, and so on.', 'targetColumn': 'Ip'}, 
        {'name': 'vuln_scanners', 'description': 'Vulnerability scanner and network mapping hosts.', 'targetColumn': 'Ip'}
    ]
    create_match_lists(lists)

    create_intel_sources()

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, filename='./cse_setup.log')
    main()