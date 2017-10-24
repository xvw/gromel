{- This module describes all of the available interaction as messages -}


module Dispatcher exposing (Message(..), Model(..), doRouting, toggleAbout)

import Router exposing (Route(..))
import Page


-- A model to represente the state of the Application


type Model
    = Routed Page.Page
    | Error Int String



-- A message (to be broadcasted by the Elm Architecture)


type Message
    = Routing (Maybe Route) -- an url mutation
    | Patch Model (Model -> Model) -- a page mutation



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
                    Routed Page.Home

                About ->
                    Routed (Page.About False)

                Links ->
                    Routed
                        (Page.Links
                            [ { name = "Google", url = "https://google.fr" }
                            , { name = "My blog", url = "https://xvw.github.io" }
                            ]
                        )



-- Patch for the page About


toggleAbout : Model -> Model
toggleAbout model =
    case model of
        Routed (Page.About t) ->
            Routed (Page.About (not t))

        _ ->
            model
