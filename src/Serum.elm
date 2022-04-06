module Serum exposing 
    (Serum
    , SerumId
    , idParser
    , idToString
    , serumDecoder
    , serumEncoder
    , serumProductsDecoder
    )


import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Url.Parser exposing (Parser, custom)

type alias Serum =
    { id : SerumId 
    , title : String
    , imgSrc : String
    , info1 : String
    , info2 : String
    , info3 : String
    , price : String
    , category : String
    }


type SerumId
    = SerumId Int


serumProductsDecoder : Decoder (List Serum)
serumProductsDecoder =
    list serumDecoder


serumDecoder : Decoder Serum
serumDecoder = 
    Decode.succeed Serum
        |> required "id" idDecoder
        |> required "title" string
        |> required "imgSrc" string
        |> required "info1" string
        |> required "info2" string
        |> required "info3" string
        |> required "price" string
        |> required "category" string


idDecoder : Decoder SerumId
idDecoder =
    Decode.map SerumId int


idToString : SerumId -> String
idToString (SerumId id) =
    String.fromInt id


idParser : Parser (SerumId -> a) a 
idParser = 
    custom "SERUMID" <| 
        \serumId -> 
            Maybe.map SerumId (String.toInt serumId)


serumEncoder : Serum -> Encode.Value
serumEncoder serum =
    Encode.object
        [ ( "id", encodeId serum.id )
        , ( "title", Encode.string serum.title )
        , ( "imgSrc", Encode.string serum.imgSrc )
        , ( "info1", Encode.string serum.info1 )
        , ( "price", Encode.string serum.price )
        ]


encodeId : SerumId -> Encode.Value
encodeId (SerumId id) =
    Encode.int id