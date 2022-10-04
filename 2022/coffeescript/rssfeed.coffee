## read an RSS feed - parse and print titles and link to the article
## npm install xml2js
## npm install axios
## run as: 
##      coffee rssfeed.coffee 
## cerner_2tothe5th_2022
axios = require 'axios'
{parseString} = require 'xml2js'

axios.get 'https://www.lastweekinaws.com/feed/'
    .then (res) ->
        parseString res.data, { trim: true}, (err, result) ->
            for item in result.rss.channel[0].item
                console.log item.title[0], item.link[0]
