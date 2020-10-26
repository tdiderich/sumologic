# Script Prerequisites 
* In order to run this script, you must first create a threat intel source to post the IOCs to
1. Navigate to the Theat Intelligence page in Sumo Logic CSE
2. Create source
3. Navigate to that source and get the source id out of the URL
4. In this example, the source id is '38'
```
https://content.portal.jask.ai/content/threat-intelligence/source/38?offset=0&sorts=value
```
5. Update that configuration parameter in the script 
6. Your CSV file should have the "value" and "description" headers with the IOCs in the value section and description in the decription section (see sample)
7. If you use a different filename rather than replace the existing iocs.csv, you will need to update that line in the script
```
import_intel('./iocs.csv')
```