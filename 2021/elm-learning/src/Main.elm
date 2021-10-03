-- A Web-App which refreshes every 60s reading data from a REST API and rendering stock details
-- cerner_2tothe5th_2021
module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (map2, field, string)
import Time

main = Browser.element { init = init , update = update, subscriptions = subscriptions, view = view }

-- MODEL
type Model = Failure | Loading | Success Stock

init : () -> (Model, Cmd Msg)
init _ = (Loading, getData)

-- UPDATE
type Msg = FetchAnother | GotResponse (Result Http.Error Stock) | Tick Time.Posix
type alias Stock = { price: String, volume: String }
update : Msg -> Model -> (Model, Cmd Msg)
update msg _ = case msg of
                FetchAnother -> (Loading, getData)
                GotResponse result -> case result of 
                                        Ok url -> (Success url, Cmd.none) 
                                        Err _ -> (Failure, Cmd.none)
                Tick _ -> (Loading, getData)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions _ = Time.every 60000 Tick

-- VIEW
view : Model -> Html Msg
view model = div [] [ h2 [] [ text "Current Stock" ] , viewGif model ]

viewGif : Model -> Html Msg
viewGif model = case model of
                    Failure -> div [] [ text "Sorry! Failure", button [ onClick FetchAnother ] [ text "Try Again!" ] ]
                    Loading -> text "Loading..."
                    Success url -> div [] [ button [ onClick FetchAnother, style "display" "block" ] [ text "Refresh" ], text ("Price: " ++ url.price), text ( " Volume: " ++ url.volume) ]

-- HTTP
getData : Cmd Msg
-- getData = Http.get { url = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&count=2", expect = Http.expectJson GotResponse (index 0 ( field "url" string )) }
getData = Http.get { url = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=CERN&apikey=7SSFN5A63GVQREZT", expect = Http.expectJson GotResponse (map2 Stock ( field "Global Quote" ( field "05. price" string )) ( field "Global Quote" ( field "06. volume" string )))}
