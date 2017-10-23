module Views exposing (..)

import Html exposing (Html, text, nav, a, div)
import Model exposing (State(..))


viewOf : Model.State -> List (Html message)
viewOf model =
    case model of
        Home ->
            [ text "Hello World" ]


global : Model.State -> Html message
global model =
    div []
        [ nav []
            [ a [] [ text "Accueil" ]
            , a [] [ text "A propos" ]
            , a [] [ text "Liens" ]
            ]
        , div [] (viewOf model)
        ]
