{- This module describes all of the views -}


module View exposing (global)

import Dispatcher exposing (Model(..), Message(..))
import Html exposing (Html, text, div, nav, a, h1, h2, p, ul, li)
import Html.Attributes as Attr
import Router
import Page exposing (Page(..))


-- The global view of the application


global : Dispatcher.Model -> Html message
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


fragment : Dispatcher.Model -> List (Html message)
fragment model =
    case model of
        Error code message ->
            [ error code message ]

        Routage content ->
            pageFragment content



-- Render a page fragment


pageFragment : Page -> List (Html message)
pageFragment page =
    case page of
        Home content ->
            [ text content ]

        About content ->
            [ text content ]

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
