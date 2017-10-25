{- This module describes all of the Routing interaction -}


module Router exposing (Route(..), toString, fromLocation, href)

import UrlParser as Url exposing (Parser, s, map)
import Navigation exposing (Location)
import Static exposing (urlFragment, routingMethod, source)
import Html.Attributes as Attr
import Html exposing (Attribute)


-- Enum the list of the available routes


type Route
    = Home
    | About
    | Links
    | Step
    | Post



-- Produces a Parser from a route


route : Parser (Route -> a) a
route =
    Url.oneOf
        [ map Home (s "")
        , map About (s "about")
        , map Links (s "links")
        , map Step (s "multiple-steps")
        , map Post (s "publish-a-message")
        ]



-- Produce a string's representation of a route


toString : Route -> String
toString route =
    let
        fragment =
            case route of
                Home ->
                    [ "" ]

                About ->
                    [ "about" ]

                Links ->
                    [ "links" ]

                Step ->
                    [ "multiple-steps" ]

                Post ->
                    [ "publish-a-message" ]
    in
        urlFragment ++ "/" ++ (String.join "/" fragment)



-- Build the href attribute from a route


href : Route -> Attribute messsage
href route =
    Attr.href (toString route)



-- Builds a route from a Location


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty (source location) then
        Just Home
    else
        routingMethod route location
