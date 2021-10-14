# Download NR Dashboards with Pages cerner_2tothe5th_2021

# bundle install and then run below.
# nr_dashboard_download.rb <API-KEY> <DASHBOARD-GUID>
require "graphql/client"
require "graphql/client/http"
require 'faraday'

HTTP = GraphQL::Client::HTTP.new("https://api.newrelic.com/graphql") do
    def headers(context) 
        { 'API-Key' => ARGV[0], 'Content-Type' => 'application/json' }
    end
end  

# fetch graphql schema
Schema = GraphQL::Client.load_schema(HTTP)

# create the graphql client
Client = GraphQL::Client.new(schema: Schema, execute: HTTP)

# Get all pages associated with the dashboard guid
# Could perhaps also query to lookup the dashboard guid perhaps by name instead of asking the user to find that!
# For a single page dashboard the query would be on id instead of parentId!
ALLPAGES = "{ actor { entitySearch(query: \"parentId ='#{ARGV[1]}'\") { results { entities { guid name ... on DashboardEntityOutline { guid name } } } } } }"

# generate a snapshot of the dashboard
# duration indicates the time period for the dashboard - the number below is 7 days in milliseconds.
SNAPSHOT_GEN = "mutation($guid: EntityGuid!) { dashboardCreateSnapshotUrl(guid: $guid, params: {timeWindow: {duration: 604800000}}) }"

ALLPAGES_QUERY = Client.parse(ALLPAGES)
SNAPSHOT_GEN_QUERY = Client.parse(SNAPSHOT_GEN)
response = Client.query(ALLPAGES_QUERY)

# iterate through all pages and save them as files locally in png format..
response.data.actor.entity_search.results.entities.each do |entity|
    puts "Downloading dashboard for #{entity.name} with guid #{entity.guid}"
    download_response = Client.query(SNAPSHOT_GEN_QUERY, variables: {guid: entity.guid})
    download_url = download_response.data.dashboard_create_snapshot_url.sub("PDF", "PNG")
    file_name = entity.name.gsub(" ", "_").gsub("/", "_").gsub("-", "_").tr_s("_", "_") + ".png"
    puts "Downloading from #{download_url}"
    File.open(file_name, 'wb') { |file| file.write(Faraday.get(download_url).body) }
end

# next upload to a jira or github issue
