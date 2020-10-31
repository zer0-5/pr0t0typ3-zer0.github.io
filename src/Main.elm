module Main exposing (..)

import Browser
import Element exposing (Element, el, width, height, fill, text)
import Element.Background as Background
import Element.Font as Font
import String
import Html exposing (Html)
import Time exposing (utc, toHour, toMinute, toSecond)
import Task

wallpaper : String
wallpaper = "https://cdnb.artstation.com/p/assets/images/images/030/073/957/large/alena-aenami-out-of-time-1080p.jpg"

type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    }

type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone

main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

init : () -> (Model, Cmd Msg)
init _ =
    ( Model Time.utc (Time.millisToPosix 0)
    , Task.perform AdjustTimeZone Time.here
    )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick

view : Model -> Html Msg
view model =
    Element.layout []
        (myElement model)

myElement : Model -> Element msg
myElement model =
    el
        [ Background.tiled wallpaper
        , width fill
        , height fill
        ]
        (text (timeStr model))

timeStr : Model -> String
timeStr model =
    "[ " ++
    formatDigits (String.fromInt (toHour model.zone model.time))
    ++ ":" ++
    formatDigits (String.fromInt (toMinute model.zone model.time))
    ++ ":" ++
    formatDigits (String.fromInt (toSecond model.zone model.time))
    ++ " ]"

formatDigits : String -> String
formatDigits s =
    if String.length s == 1 then "0" ++ s
    else s
