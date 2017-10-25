{- This module describes all of the available interaction as messages -}


module Dispatcher
    exposing
        ( Message(..)
        , Model
        , State(..)
        , Chan(..)
        , doRouting
        , toggleAbout
        , handleInput
        , addToStack
        , resetStack
        , publish
        , handleMessage
        )

import Router exposing (Route(..))
import Page
import Ports


-- A model to represente the state of the Application


type State
    = Routed Page.Page
    | Error Int String


type alias Model =
    { state : State
    , messages : List String
    , total : Int
    }



-- A message (to be broadcasted by the Elm Architecture)


type Chan
    = Simple Ports.Message


type Message
    = Routing (Maybe Route) -- an url mutation
    | Patch (Model -> ( Model, Cmd Message )) -- a page mutation
    | Discrete (Chan -> Model -> ( Model, Cmd Message )) Chan



-- Perform the routing


doRouting : Model -> Maybe Route -> Model
doRouting model potentialRoute =
    case potentialRoute of
        Nothing ->
            { model | state = Error 404 "The route does not exists" }

        Just route ->
            -- Here the "model of a page" should be generate in
            -- separate modules
            case route of
                Home ->
                    { model | state = Routed Page.Home }

                About ->
                    { model | state = Routed (Page.About False) }

                Links ->
                    { model | state = Routed Page.Links }

                Step ->
                    { model | state = Routed (Page.Step { input = "", stack = [] }) }

                Post ->
                    { model | total = 0, state = Routed (Page.Post { input = "" }) }



-- Patches


unauthorized : Model -> ( Model, Cmd message )
unauthorized model =
    ( { model | state = Error 401 "Unauthorized case" }, Cmd.none )


handleInput : String -> Model -> ( Model, Cmd message )
handleInput text model =
    case model.state of
        Routed (Page.Step state) ->
            ( { model
                | state = Routed (Page.Step { state | input = text })
              }
            , Cmd.none
            )

        Routed (Page.Post state) ->
            ( { model
                | state = Routed (Page.Post { state | input = text })
              }
            , Cmd.none
            )

        _ ->
            unauthorized model


addToStack : Model -> ( Model, Cmd message )
addToStack model =
    case model.state of
        Routed (Page.Step state) ->
            ( { model
                | state =
                    Routed
                        (Page.Step
                            { state
                                | stack = state.input :: state.stack
                                , input = ""
                            }
                        )
              }
            , Cmd.none
            )

        _ ->
            unauthorized model


handleMessage : Chan -> Model -> ( Model, Cmd message )
handleMessage channel model =
    let
        offset =
            case model.state of
                Routed (Page.Post _) ->
                    0

                _ ->
                    1
    in
        case channel of
            Simple message ->
                ( { model
                    | messages = message.body :: model.messages
                    , total = model.total + offset
                  }
                , Cmd.none
                )


resetStack : Model -> ( Model, Cmd message )
resetStack model =
    case model.state of
        Routed (Page.Step state) ->
            ( { model
                | state =
                    Routed
                        (Page.Step { state | stack = [], input = "" })
              }
            , Cmd.none
            )

        _ ->
            unauthorized model


publish : Model -> ( Model, Cmd message )
publish model =
    case model.state of
        Routed (Page.Post state) ->
            ( model, Ports.pubMessage { body = state.input } )

        _ ->
            unauthorized model


toggleAbout : Model -> ( Model, Cmd message )
toggleAbout model =
    case model.state of
        Routed (Page.About t) ->
            ( { model | state = Routed (Page.About (not t)) }, Cmd.none )

        _ ->
            unauthorized model
