module Acne exposing 
    (Acne
    , AcneId
    , idParser
    , idToString
    , acneDecoder
    , acneEncoder
    , acneProductsDecoder
    )


import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Url.Parser exposing (Parser, custom)

type alias Acne =
    { id : AcneId 
    , title : String
    , imgSrc : String
    , info1 : String
    , info2 : String
    , info3 : String
    , price : String
    , category : String
    }


type AcneId
    = AcneId Int


acneProductsDecoder : Decoder (List Acne)
acneProductsDecoder =
    list acneDecoder


acneDecoder : Decoder Acne
acneDecoder = 
    Decode.succeed Acne
        |> required "id" idDecoder
        |> required "title" string
        |> required "imgSrc" string
        |> required "info1" string
        |> required "info2" string
        |> required "info3" string
        |> required "price" string
        |> required "category" string


idDecoder : Decoder AcneId
idDecoder =
    Decode.map AcneId int


idToString : AcneId -> String
idToString (AcneId id) =
    String.fromInt id


idParser : Parser (AcneId -> a) a 
idParser = 
    custom "ACNEID" <| 
        \acneId -> 
            Maybe.map AcneId (String.toInt acneId)


acneEncoder : Acne -> Encode.Value
acneEncoder acne =
    Encode.object
        [ ( "id", encodeId acne.id )
        , ( "title", Encode.string acne.title )
        , ( "imgSrc", Encode.string acne.imgSrc )
        , ( "info1", Encode.string acne.info1 )
        , ( "price", Encode.string acne.price )
        ]


encodeId : AcneId -> Encode.Value
encodeId (AcneId id) =
    Encode.int id