module Main exposing (main)

import Browser
import Element exposing (Element, centerX, centerY, el, fill, height, text, width)
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)
import String
import Task
import Time exposing (toHour, toMinute, toSecond, utc)


wallpaper : String
wallpaper =
    "https://cdna.artstation.com/p/assets/images/images/022/502/864/medium/alena-aenami-eternity-1080px.jpg?1575651131"


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


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0)
    , Task.perform AdjustTimeZone Time.here
    )


update : Msg -> Model -> ( Model, Cmd Msg )
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
subscriptions _ =
    Time.every 1000 Tick


view : Model -> Html Msg
view model =
    Element.layout []
        (myElement model)


myElement : Model -> Element msg
myElement model =
    el
        [ Background.image wallpaper
        , width fill
        , height fill
        ]
        (el
            [ centerX
            , centerY
            , Font.size 100
            , Font.color (Element.rgb 1 1 1)
            , Font.family
                [ Font.external
                    { name = "SF Pixelate"
                    , url = "https://fontlibrary.org/face/pixelated"
                    }
                ]
            ]
            (text (timeStr model))
        )


timeStr : Model -> String
timeStr model =
    "["
        ++ formatDigits (String.fromInt (toHour model.zone model.time))
        ++ ":"
        ++ formatDigits (String.fromInt (toMinute model.zone model.time))
        ++ ":"
        ++ formatDigits (String.fromInt (toSecond model.zone model.time))
        ++ "]"


formatDigits : String -> String
formatDigits s =
    if String.length s == 1 then
        "0" ++ s

    else
        s
