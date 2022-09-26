import groovy.json.JsonSlurper
import java.util.regex.Pattern

// fetch notifications from GitHub in the last 24 hours in which you are participating
// set following ENV vars
// GITHUB_API - GitHub url to fetch notifications from, add trailing slash
// GITHUB_BEARER_TOKEN - GitHub Bearer token
// cerner_2tothe5th_2022

def today = String.format('%tF', java.time.LocalDateTime.now().minusHours(24))
def url = System.getenv("GITHUB_API")
def token = System.getenv("BEARER_TOKEN")
def request = new URL(url + "notifications?since=" + today + "&participating=true").openConnection()
request.setRequestProperty("Authorization", token)

def responseCode = request.getResponseCode();
if (responseCode.equals(200)) {
    def output = new JsonSlurper().parseText(request.getInputStream().getText())
    def pull_pattern = Pattern.compile("pulls/(.+)")
    def issue_pattern = Pattern.compile("issues/(.+)")
    output.each { 
        def link = ""
        if ("PullRequest".equals(it.subject.type)) {
            def (_, id) = (it.subject.url =~ pull_pattern)[0]
            link = it.repository.html_url + "/pull/" + id // construct the PR url
        } else if ("Issue".equals(it.subject.type)) {
            def (_, id) = (it.subject.url =~ issue_pattern)[0]
            link = it.repository.html_url + "/issues/" + id // construct the issue url
        }
        println(sprintf("|%-17s| %-50s | %s |", it.reason, it.subject.title.take(50), link))
    }
} else {
    println("Failed to fetch notifications")
}

// example output
// |review_requested | Do something                      | https://link |
// |comment          | Move MCS component service to CD  | https://link |
// |team_mention     | Enhance to include Service        | https://link |
