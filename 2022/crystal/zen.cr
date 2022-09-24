require "http/client"

# cerner_2tothe5th_2022 
# Get a random sentence from the Zen of GitHub
response = HTTP::Client.get "https://api.github.com/zen"
puts response.body.lines.first
