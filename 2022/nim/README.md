# Nim

## Installation

```
brew install nim
```

## VS Code extensions

https://marketplace.visualstudio.com/items?itemName=kosz78.nim

https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner

## To execute in VS Code with Code Runner extension

MacOS: Ctrl + Option + N

## To run example - dependencies

```
nimble install ws
nimble install jester
```

## Testing

- compile and run `nim c -d:ssl  -r stock_ticker.nim`
- Above step starts a server and exposes a websocket at port 3000
- The stock_ticker.html has simple logic to connect to the server and prints out price of the stock sent in the websocket request
