## Simple stock ticker using websocket in Nim using jester and ws packages
## cerner_2tothe5th_2022
import jester
import ws, ws/jester_extra
import std/httpclient
import std/strformat
import std/json

settings:
  port = Port 3000

routes:
  get "/stocks":
    var ws = await newWebSocket(request)
    await ws.send("Welcome to the stock ticker server")
    while ws.readyState == Open:
      let symbol = await ws.receiveStrPacket()
      var client = newHttpClient()
      let jsonNode = parseJson(client.getContent(&"https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol={symbol}&apikey=7SSFN5A63GVQREZT"))
      await ws.send(jsonNode["Global Quote"]["05. price"].getStr())
