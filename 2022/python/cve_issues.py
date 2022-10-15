# cerner_2tothe5th_2022
# parse CVE issues logged as Github issues and writes out a CSV file
# Run as:
#   python3 cve_issues.py <graphql-endpoint> <token> <github-graphql-query>
import requests
import json
import re
import csv
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("url")
parser.add_argument("token")
parser.add_argument("query")
args = parser.parse_args()

## TODO paginate this..
query = "{ search(first: 20, type: ISSUE, query: \"%s\") { nodes { ... on Issue { title createdAt url bodyHTML } } } }" % args.query

response = requests.post(args.url, json={'query': query}, headers={ 'Authorization': "Bearer %s" % args.token }) 

with open('cves.csv', 'w') as file:
    filewriter = csv.writer(file, delimiter=',')
    filewriter.writerow(['Date', 'Title', 'Url', 'Image'])
    for row in json.loads(response.text)["data"]["search"]["nodes"]:
        images = re.findall("([a-z0-9-]+):[0-9]\.", row["bodyHTML"]) # attempt to parse out image names
        # write a row for each image
        for image in images:
            filewriter.writerow([row["createdAt"][0:10], row["title"], row["url"], image])
