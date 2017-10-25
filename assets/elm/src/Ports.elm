port module Ports
    exposing
        ( Message
        , pubMessage
        , subMessage
        )


type alias Message =
    { body : String
    }


port pubMessage : Message -> Cmd msg


port subMessage : (Message -> msg) -> Sub msg
