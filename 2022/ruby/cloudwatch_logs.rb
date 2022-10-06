require 'aws-sdk-cloudwatchlogs'

# Parse cloudwatch-logs to print out job-flow-ids
# run as 
#   cloudwatch_logs.rb /aws/lambda/some-lambda 3 us-west-1"
# cerner_2tothe5th_2022
abort "run as: cloudwatch_logs.rb log_group_name duration_in_hours_lookback aws_region" if !ARGV[0] || !ARGV[1] || !ARGV[2]

client = Aws::CloudWatchLogs::Client.new(region: ARGV[2])
filter = {
    log_group_name: ARGV[0],
    filter_pattern: "?ScopeIdField ?JobFlowID",
    start_time: (Time.now - (ARGV[1].to_i)*60*60).to_i * 1000, # epoch time in milliseconds
    limit: 100
}

# parsing output from the filtered logs and generate a table as below.
# we expect two lines to match the pattern, one line containing the scope-id and another job-flow-id
# print them out collated, if scope-id alone is found without a subsequence job-flow-id print just the "scope-id     "
loop = true, found_scope = "", next_token = nil
while loop do
    filter.merge!(next_token: next_token) if next_token
    resp = client.filter_log_events(filter)

    resp[:events].each do |event|
        scope = event[:message].match(/ScopeIdField: (?<scope>[a-z0-9-]+)/)&.[](:scope)
        if scope 
            print "#{found_scope}#{scope} " 
            found_scope = "\n"
        else 
            job_flow = event[:message].match(/JobFlowID: (?<job_flow>[a-zA-Z0-9-]+)/)&.[](:job_flow)
            if job_flow
                puts job_flow
                found_scope = ""
            end
        end
    end
    next_token = resp[:next_token]
    loop = false if !next_token
end
