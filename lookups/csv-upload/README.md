# TL;DR

- This script uploads a CSV to a lookup table
- I am currently troubleshooting an issue with the CSV file upload option and will add that script once resolved
- upload_csv_rows.py will make an API call per row in the CSV, so it would not scale well with CSVs with a lot of rows

# Required environment variables

1. CIP_ACCESS_KEY
2. CIP_ACCESS_ID
3. CIP_DEPLOYMENT

# Script Prerequisites

- Create lookup

1. Create a CIP lookup table
2. Get the ID from the URL when you are looking at the lookup in Sumo

- Update the upload value

1. The columns are hard coded for IP and Damain - you'll need to update based on the headers in your file
