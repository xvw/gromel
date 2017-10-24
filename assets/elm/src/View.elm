{- This module describes all of the views -}


module View exposing (global)

import Dispatcher exposing (Model(..), Message(..))
import Html exposing (Html, text, div, nav, a, h1, h2, p, ul, li, button)
import Html.Events exposing (onClick)
import Html.Attributes as Attr
import Router
import Page exposing (Page(..))


-- The global view of the application


global : Model -> Html Message
global model =
    div []
        [ h1 []
            [ text "My ugly page" ]
        , nav []
            [ a [ Router.href Router.Home ] [ text "Home" ]
            , a [ Router.href Router.About ] [ text "About" ]
            , a [ Router.href Router.Links ] [ text "Links" ]
            ]
        , div [] (fragment model)
        ]



-- Render a model (as a widget)


fragment : Model -> List (Html Message)
fragment model =
    case model of
        Error code message ->
            [ error code message ]

        Routage content ->
            pageFragment (Patch model) content



-- Render a page fragment


toggleAbout : Model -> Model
toggleAbout model =
    case model of
        Routage (About t) ->
            Routage (About (not t))

        _ ->
            model


pageFragment : ((Model -> Model) -> Message) -> Page -> List (Html Message)
pageFragment patch page =
    case page of
        Home ->
            [ text "Hello World" ]

        About toggle ->
            let
                toggler =
                    if toggle then
                        "opened"
                    else
                        "closed"
            in
                [ text "About page"
                , button
                    [ onClick (patch toggleAbout) ]
                    [ text "Toggle content" ]
                , div [ Attr.class toggler ] [ text "Hidden content" ]
                ]

        Links links ->
            [ ul []
                (List.map
                    (\link -> li [] [ linkToA link ])
                    links
                )
            ]



-- Render an error


error : Int -> String -> Html message
error code message =
    div [ Attr.class "error" ]
        [ h2 [] [ text (toString code) ]
        , p [] [ text message ]
        ]



-- Helpers


linkToA : { name : String, url : String } -> Html message
linkToA link =
    a [ Attr.href link.url ] [ text link.name ]
