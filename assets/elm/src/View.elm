{- This module describes all of the views -}


module View exposing (global)

import Dispatcher
    exposing
        ( Model
        , Message(..)
        , State(..)
        , toggleAbout
        , handleInput
        , addToStack
        , resetStack
        , publish
        )
import Html
    exposing
        ( Html
        , text
        , div
        , nav
        , a
        , h1
        , h2
        , p
        , ul
        , ol
        , li
        , button
        , br
        , input
        , span
        )
import Html.Events exposing (onClick, onInput)
import Html.Attributes as Attr
import Router
import Page exposing (Page(..))


-- The global view of the application


global : Model -> Html Message
global model =
    div [ Attr.class "content" ]
        [ h1 []
            [ text "My ugly page" ]
        , nav []
            [ a [ Router.href Router.Home ] [ text "Home" ]
            , a [ Router.href Router.About ] [ text "About" ]
            , a [ Router.href Router.Links ] [ text "Links" ]
            , a [ Router.href Router.Step ] [ text "Multiple step sample" ]
            , a [ Router.href Router.Post ]
                [ text ("Post message (" ++ (toString model.total) ++ ")") ]
            ]
        , div [] (fragment model)
        ]



-- Render a model (as a widget)


fragment : Model -> List (Html Message)
fragment model =
    case model.state of
        Error code message ->
            [ error code message ]

        Routed content ->
            pageFragment model content



-- Render a page fragment


pageFragment : Model -> Page -> List (Html Message)
pageFragment model page =
    case page of
        Home ->
            [ div [ Attr.class "page" ]
                [ h2 [] [ text "Home" ]
                , text "Hello World"
                ]
            ]

        About toggle ->
            about toggle

        Links ->
            let
                links =
                    [ { name = "Google", url = "https://google.fr" }
                    , { name = "My blog", url = "https://xvw.github.io" }
                    ]
            in
                [ div [ Attr.class "page" ]
                    [ h2 [] [ text "Links" ]
                    , ul []
                        (List.map
                            (\link -> li [] [ linkToA link ])
                            links
                        )
                    ]
                ]

        Step state ->
            let
                btn =
                    if (List.length state.stack) > 4 then
                        [ button [ onClick (Patch resetStack) ] [ text "reset" ] ]
                    else
                        []
            in
                [ input
                    [ Attr.placeholder "A Task"
                    , Attr.value state.input
                    , onInput (\s -> Patch (handleInput s))
                    ]
                    []
                , button
                    [ onClick (Patch addToStack) ]
                    [ text "Add to Stack" ]
                , div [ Attr.class "page" ]
                    [ h2 [] [ text "Multiple step page" ]
                    , ol []
                        (List.map
                            (\step -> li [] [ text step ])
                            state.stack
                        )
                    ]
                ]
                    ++ btn

        Post state ->
            [ input
                [ Attr.placeholder "A message"
                , Attr.value state.input
                , onInput (\s -> Patch (handleInput s))
                ]
                []
            , button
                [ onClick (Patch publish) ]
                [ text "Publish" ]
            , div [ Attr.class "page" ]
                [ h2 [] [ text "List of messages" ]
                , ul []
                    (List.map
                        (\message -> li [] [ text message ])
                        model.messages
                    )
                ]
            ]


about : Bool -> List (Html Message)
about toggle =
    let
        toggler =
            if toggle then
                "opened"
            else
                "closed"
    in
        [ button
            [ onClick (Patch toggleAbout) ]
            [ text "Toggle content" ]
        , div [ Attr.class "page" ]
            [ h2 [] [ text "About" ]
            , text "This is an "
            , span [ Attr.class toggler ] [ text "ugly" ]
            , text " experience !"
            ]
        ]



-- Render an error


error : Int -> String -> Html message
error code message =
    div [ Attr.class "error" ]
        [ h2 [] [ text (toString code) ]
        , text message
        ]



-- Helpers


linkToA : { name : String, url : String } -> Html message
linkToA link =
    a [ Attr.href link.url ] [ text link.name ]
