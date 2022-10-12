## Fetches issues with GraphQL API and plots created-date and the GitHub issue title
## Create a .Renviron file and have the following key-value pairs
##    GITHUB_TOKEN=<github token>
##    GITHUB_URL=<graphql url>
##    GITHUB_QUERY=<query to filter issues by>
## Run below in the project directory, it creates Rplots.pdf file with the plot
##  Rscript plot_issues.R
## cerner_2tothe5th_2022
library("ghql")
library("jsonlite")
library("ggplot2")
library("stringr")

con <- GraphqlClient$new(url = Sys.getenv("GITHUB_URL"), headers = list(Authorization = paste0("Bearer ", Sys.getenv("GITHUB_TOKEN"))))
qry <- Query$new()
## construct your query - picks first 20 issues based on the GitHub Query
query <- str_interp("{
  search(first: 20, type: ISSUE, query: \"${Sys.getenv('GITHUB_QUERY')}\") {
    nodes {
      ... on Issue {
        title
        createdAt
      }
    }
  }
}")

qry$query('issues', query)
res <- con$exec(qry$queries$issues)
df <- as.data.frame(jsonlite::fromJSON(res)) ## convert to data frome

## plot the created-date with the title
ggplot(df, aes(data.search.nodes.createdAt, data.search.nodes.title)) + 
  geom_point()
