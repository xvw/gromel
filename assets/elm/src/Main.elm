module Main exposing (..)

import Helper exposing (just)
import Navigation
import Router exposing (fromLocation)
import Dispatcher exposing (Message(..), Model, Channel(..), State(..))
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

        Discrete (Simple socket_message) ->
            let
                offset =
                    case model.state of
                        Routed (Page.Post _) ->
                            0

                        _ ->
                            1
            in
                just
                    { model
                        | messages = socket_message.body :: model.messages
                        , total = model.total + offset
                    }


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.batch
        [ Ports.subMessage (\message -> Discrete (Simple message)) ]



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
