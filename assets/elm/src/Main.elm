module Main exposing (..)

import Helper exposing (just)
import Navigation
import Router exposing (fromLocation)
import Dispatcher exposing (Message(..), Model(..))
import View exposing (global)


init : Navigation.Location -> ( Model, Cmd Message )
init location =
    location
        |> fromLocation
        |> Dispatcher.doRouting
        |> just


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        Routing potentialRoute ->
            just (Dispatcher.doRouting potentialRoute)

        Patch target f ->
            just (f model)



-- Main process


main : Platform.Program Never Model Message
main =
    Navigation.program
        (fromLocation >> Routing)
        { init = init
        , update = update
        , subscriptions = (\_ -> Sub.none)
        , view = global
        }
