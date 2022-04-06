module Mouisturizing exposing 
    (Mouisturizing
    , MouisturizingId
    , idParser
    , idToString
    , mouisturizingDecoder
    , mouisturizingEncoder
    , mouisturizingProductsDecoder
    )


import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Url.Parser exposing (Parser, custom)

type alias Mouisturizing =
    { id : MouisturizingId 
    , title : String
    , imgSrc : String
    , info1 : String
    , info2 : String
    , info3 : String
    , price : String
    , category : String
    }


type MouisturizingId
    = MouisturizingId Int


mouisturizingProductsDecoder : Decoder (List Mouisturizing)
mouisturizingProductsDecoder =
    list mouisturizingDecoder


mouisturizingDecoder : Decoder Mouisturizing
mouisturizingDecoder = 
    Decode.succeed Mouisturizing
        |> required "id" idDecoder
        |> required "title" string
        |> required "imgSrc" string
        |> required "info1" string
        |> required "info2" string
        |> required "info3" string
        |> required "price" string
        |> required "category" string


idDecoder : Decoder MouisturizingId
idDecoder =
    Decode.map MouisturizingId int


idToString : MouisturizingId -> String
idToString (MouisturizingId id) =
    String.fromInt id


idParser : Parser (MouisturizingId -> a) a 
idParser = 
    custom "MOUISTURIZINGID" <| 
        \mouisturizingId -> 
            Maybe.map MouisturizingId (String.toInt mouisturizingId)


mouisturizingEncoder : Mouisturizing -> Encode.Value
mouisturizingEncoder mouisturizing =
    Encode.object
        [ ( "id", encodeId mouisturizing.id )
        , ( "title", Encode.string mouisturizing.title )
        , ( "imgSrc", Encode.string mouisturizing.imgSrc )
        , ( "info1", Encode.string mouisturizing.info1 )
        , ( "price", Encode.string mouisturizing.price )
        ]


encodeId : MouisturizingId -> Encode.Value
encodeId (MouisturizingId id) =
    Encode.int id