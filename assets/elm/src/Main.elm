module Main exposing (..)

import Helper exposing (just)
import Navigation
import Router exposing (fromLocation)
import Dispatcher exposing (Message(..), Model, Chan(..), State(..))
import Page
import View exposing (global)
import Ports exposing (subMessage)


init : Navigation.Location -> ( Model, Cmd Message )
init location =
    let
        route =
            fromLocation location

        model =
            { messages = [], state = Error 404 "", total = 0 }
    in
        ( Dispatcher.doRouting model route, Cmd.none )


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        Routing potentialRoute ->
            just (Dispatcher.doRouting model potentialRoute)

        Patch apply_patch ->
            apply_patch model

        Discrete apply_patch pub ->
            apply_patch pub model


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.batch
        [ Ports.subMessage (\s -> Discrete Dispatcher.handleMessage (Simple s)) ]



-- Main process


main : Platform.Program Never Model Message
main =
    Navigation.program
        (fromLocation >> Routing)
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = global
        }
