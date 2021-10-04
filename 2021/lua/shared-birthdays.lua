-- cli to pull birthdays on the month-day provided on the command line from wikipedia REST API
-- cerner_2tothe5th_2021
local lunajson = require 'lunajson'
local http_request = require "http.request"

if (arg[1] == nil or arg[2] == nil or (tonumber(arg[1]) < 1 or tonumber(arg[2]) > 12))
then
    -- check if days are valid!
    print("two args needed - month(1-12), day")
    return
end

-- invoke the API
local uri = "https://en.wikipedia.org/api/rest_v1/feed/onthisday/births/" .. arg[1] .. "/" .. arg[2]

local headers, stream = assert(http_request.new_from_uri(uri):go())
local body = assert(stream:get_body_as_string())

if headers:get ":status" ~= "200" then
    error(body)
end

local t = lunajson.decode(body)

for _, birth in ipairs(t.births) do
    print(birth.text)
end
