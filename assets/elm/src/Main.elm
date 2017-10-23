module Main exposing (..)

import Html exposing (Html)
import Model exposing (State(..))
import Views


type Message
    = Unit


type alias Model =
    State


update : Message -> Model -> ( Model, Cmd Message )
update _ model =
    ( model, Cmd.none )


main : Platform.Program Never Model Message
main =
    Html.program
        { init = ( Home, Cmd.none )
        , subscriptions = (\_ -> Sub.batch [])
        , update = update
        , view = Views.global
        }
