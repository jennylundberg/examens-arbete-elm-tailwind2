module Pore exposing 
    ( Pore
    , PoreId
    , idParser
    , idToString
    , poreDecoder
    , poreEncoder
    , poreProductsDecoder
    )

import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Url.Parser exposing (Parser, custom)

type alias Pore =
    { id : PoreId 
    , title : String
    , imgSrc : String
    , info1 : String
    , info2 : String
    , info3 : String
    , price : String
    , category : String
    }


type PoreId
    = PoreId Int


poreProductsDecoder : Decoder (List Pore)
poreProductsDecoder =
    list poreDecoder


poreDecoder : Decoder Pore
poreDecoder = 
    Decode.succeed Pore
        |> required "id" idDecoder
        |> required "title" string
        |> required "imgSrc" string
        |> required "info1" string
        |> required "info2" string
        |> required "info3" string
        |> required "price" string
        |> required "category" string


idDecoder : Decoder PoreId
idDecoder =
    Decode.map PoreId int


idToString : PoreId -> String
idToString (PoreId id) =
    String.fromInt id


idParser : Parser (PoreId -> a) a 
idParser = 
    custom "POREID" <| 
        \poreId -> 
            Maybe.map PoreId (String.toInt poreId)


poreEncoder : Pore -> Encode.Value
poreEncoder pore =
    Encode.object
        [ ( "id", encodeId pore.id )
        , ( "title", Encode.string pore.title )
        , ( "imgSrc", Encode.string pore.imgSrc )
        , ( "info1", Encode.string pore.info1 )
        , ( "price", Encode.string pore.price )
        ]


encodeId : PoreId -> Encode.Value
encodeId (PoreId id) =
    Encode.int id