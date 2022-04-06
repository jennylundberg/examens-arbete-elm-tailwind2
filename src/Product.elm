module Product exposing 
    (Product
    , ProductId
    , idParser
    , idToString
    , productDecoder
    , productEncoder
    , productsDecoder
    )

import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Url.Parser exposing (Parser, custom)

type alias Product =
    { id : ProductId 
    , title : String
    , imgSrc : String
    , info1 : String
    , info2 : String
    , info3 : String
    , price : String
    , category : String
    }


type ProductId
    = ProductId Int


productsDecoder : Decoder (List Product)
productsDecoder =
    list productDecoder


productDecoder : Decoder Product
productDecoder = 
    Decode.succeed Product
        |> required "id" idDecoder
        |> required "title" string
        |> required "imgSrc" string
        |> required "info1" string
        |> required "info2" string
        |> required "info3" string
        |> required "price" string
        |> required "category" string


idDecoder : Decoder ProductId
idDecoder =
    Decode.map ProductId int


idToString : ProductId -> String
idToString (ProductId id) =
    String.fromInt id


idParser : Parser (ProductId -> a) a 
idParser = 
    custom "PRODUCTID" <| 
        \productId -> 
            Maybe.map ProductId (String.toInt productId)


productEncoder : Product -> Encode.Value
productEncoder product =
    Encode.object
        [ ( "id", encodeId product.id )
        , ( "title", Encode.string product.title )
        , ( "imgSrc", Encode.string product.imgSrc )
        , ( "info1", Encode.string product.info1 )
        , ( "price", Encode.string product.price )
        ]


encodeId : ProductId -> Encode.Value
encodeId (ProductId id) =
    Encode.int id