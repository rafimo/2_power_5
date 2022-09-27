## cerner_2tothe5th_2022
## Fetch all public gists for a user
import GitHub
import HTTP

## Run as: julia gists.jl <user>
## Env Vars needed! 
## GITHUB_URL  - REST API url
## GITHUB_BEARER_TOKEN - your PAT
user = pop!(ARGS)
println("Finding all Public gists for $user")
api = GitHub.GitHubWebAPI(HTTP.URI(ENV["GITHUB_URL"]))
myauth = GitHub.authenticate(api, ENV["GITHUB_BEARER_TOKEN"])
gists = GitHub.gists(api, user, auth=myauth)

# loop through and print the files that are part of gist
for gist in gists[1]
    for key in keys(gist.files)
        println(key)
    end
end
