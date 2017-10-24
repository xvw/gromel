{- This module describe the static data and configuration -}


module Static exposing (urlFragment, routingMethod)

import UrlParser as Url exposing (Parser, parseHash, parsePath)
import Navigation exposing (Location)


-- Define the kind of front-end routing


type Kind
    = Hash
    | History


defineKind : Kind
defineKind =
    Hash


urlFragment : String
urlFragment =
    case defineKind of
        Hash ->
            "#"

        History ->
            ""


routingMethod : Parser (a -> a) a -> Location -> Maybe a
routingMethod =
    case defineKind of
        Hash ->
            parseHash

        History ->
            parsePath
