# cerner_2tothe5th_2021
# find all open pull requests for the associated user order desc by updated and pretty print them!
import requests
import json
import argparse
from rich.console import Console
from rich.table import Table, Column

# create cli parser
parser = argparse.ArgumentParser()
parser.add_argument("login")
parser.add_argument("url")
parser.add_argument("token")
args = parser.parse_args()

query = "{ \
  user(login: \"%s\") { \
    pullRequests(first: 100, states: OPEN, orderBy: {field: UPDATED_AT, direction: DESC}) { \
      nodes { title url createdAt reviewDecision } } } } " % args.login

response = requests.post(args.url, json={'query': query}, headers={ 'Authorization': "Bearer %s" % args.token }) 

table = Table(Column("Date", style="cyan"), Column("Title", style="green"), Column("Url", style="yellow"), Column("Status", style="blue"), title="Pull Requests" )

for row in json.loads(response.text)["data"]["user"]["pullRequests"]["nodes"]:
  status = ":thumbs_up:" if row["reviewDecision"] == "APPROVED" else ":cross_mark:"
  table.add_row(row["createdAt"][0:10], row["title"], row["url"], status)

Console().print(table)
