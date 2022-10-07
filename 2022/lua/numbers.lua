-- cli to pull stats about a number passed in..
-- run as:
--    lua numbers.lua 2
-- example output: 2 is the price in cents per acre the USA bought Alaska from Russia.
-- cerner_2tothe5th_2022
local http_request = require "http.request"

if (arg[1] == nil)
then
    print("enter the number you are interested in as first argument")
    return
end

-- invoke the API
local uri = "http://numbersapi.com/" .. arg[1] 

local headers, stream = assert(http_request.new_from_uri(uri):go())
local body = assert(stream:get_body_as_string())

if headers:get ":status" ~= "200" then
    error(body)
end

print(body)
