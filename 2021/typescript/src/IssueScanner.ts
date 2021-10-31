// query for github issues and print certain metadata that is helpful to identity when the issue is due
// cerner_2tothe5th_2021

// npm install
// export GITHUB_TOKEN="PAT"
// export GITHUB_API="REST API url"
// export GITHUB_SEARCH_QUERY="q=is:open created:>=2020-08-19 repo:<org/repo1> repo:<org/repo2> label:<label>"
// ts-node src/IssueScanner.ts

import axios from 'axios';

const url = process.env.GITHUB_API
const auth = `Bearer ${process.env.GITHUB_TOKEN}` 
const query = `search/issues?${process.env.GITHUB_SEARCH_QUERY}`

console.log(url, auth, query)

const client = axios.create({ baseURL: url, headers: { 'Authorization': auth }})

// interfaces representing the API response
interface Results { items: Issue[], total_count: Number, incomplete_results: Boolean } 
interface Issue { title: String, created_at: String, body: String, repository_url: String, labels: Label[] }
interface Label { name: String }

const searchLabels = [ "ack", "overdue" ]
// paginate through all results here - this currently prints out first 20
client.get<Results>(query).then(
    ( { data }) => {
        console.log(`Found ${data.total_count} issues.`)
        data.items.forEach (issue => {
            var repo = issue.repository_url.substring(issue.repository_url.lastIndexOf('/') + 1)
            var match = issue.body.match(/Due Date = ([\w-]+)\n/)
            var dueDate = null
            if (match) { dueDate = match[1] }
            var labels = issue.labels.filter(label => searchLabels.some(string => label.name.includes(string))).map(label => label.name)
            // print a table with details
            console.log(`${issue.created_at} | ${dueDate} | ${repo} | ${issue.title} | ${labels}`)
        })
    }) 

