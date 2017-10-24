{- This module describes all of the available interaction as messages -}


module Dispatcher exposing (Message(..), Model(..), doRouting)

import Router exposing (Route(..))
import Page


-- A message (to be broadcasted by the Elm Architecture)


type Message
    = Routing (Maybe Route) -- an url mutation
    | Patch -- a page mutation



-- A model to represente the state of the Application


type Model
    = Routage Page.Page
    | Error Int String



-- Perform the routing


doRouting : Maybe Route -> Model
doRouting potentialRoute =
    case potentialRoute of
        Nothing ->
            Error 404 "The route does not exists"

        Just route ->
            -- Here the "model of a page" should be generate in
            -- separate modules
            case route of
                Home ->
                    Routage (Page.Home "Hello World")

                About ->
                    Routage (Page.About "This page is an example of Elm")

                Links ->
                    Routage
                        (Page.Links
                            [ { name = "Google", url = "https://google.fr" }
                            , { name = "My blog", url = "https://xvw.github.io" }
                            ]
                        )
