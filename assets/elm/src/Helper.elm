{- Simple Helper -}


module Helper exposing (just)

-- wrap in tuple


just : a -> ( a, Cmd message )
just x =
    ( x, Cmd.none )
