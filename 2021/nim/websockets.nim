## Simple websocket in Nim using jester and ws packages
## cerner_2tothe5th_2021
import jester
import ws, ws/jester_extra

routes:
  get "/backend":
    var ws = await newWebSocket(request)
    await ws.send("Welcome to the echo server")
    while ws.readyState == Open:
      let packet = await ws.receiveStrPacket()
      await ws.send(packet)
