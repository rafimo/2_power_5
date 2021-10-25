## cerner_2tothe5th_2021
## Fetch all orgs for a user in julia!
import GitHub
import HTTP

## Run as: julia github.jl <user>
## Env Vars needed! 
## GITHUB_URL  - REST API url
## GITHUB_AUTH - your PAT
user = pop!(ARGS)
println("Finding all orgs for $user")
api = GitHub.GitHubWebAPI(HTTP.URI(ENV["GITHUB_URL"]))
myauth = GitHub.authenticate(api, ENV["GITHUB_AUTH"])
repos = GitHub.orgs(api, user, auth=myauth)

for repo in repos[1]
    println(repo.login)
end
