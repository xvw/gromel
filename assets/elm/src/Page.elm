{- This module describes all pages models -}


module Page exposing (Page(..))

-- The enumeration for statics pages
-- You can parametrize your enumeration which a specific model !
-- In fact, the parametrization of the page is not necessary.


type Page
    = Home
    | About Bool
    | Links (List { name : String, url : String })
