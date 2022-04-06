module Page.OneSerumProduct exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
import Error exposing (buildErrorMessage)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Serum exposing (Serum, SerumId, serumDecoder, serumEncoder)
import RemoteData exposing (WebData)
import Route


type alias Model =
    { navKey : Nav.Key
    , serum : WebData Serum
    , saveError : Maybe String
    }


init : SerumId -> Nav.Key -> ( Model, Cmd Msg )
init serumId navKey =
    ( initialModel navKey, fetchProduct serumId )


initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , serum = RemoteData.Loading
    , saveError = Nothing
    }


fetchProduct : SerumId -> Cmd Msg
fetchProduct serumId =
    Http.get
        { url = "http://localhost:5019/serum/" ++ Serum.idToString serumId
        , expect =
            serumDecoder
                |> Http.expectJson (RemoteData.fromResult >> ProductReceived)
        }


type Msg = ProductReceived (WebData Serum)
    

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProductReceived serum ->
            ( { model | serum = serum }, Cmd.none )
        

view : Model -> Html Msg
view model =
    div []
        [ viewHeader
        , viewSerumProduct model.serum
        ]


viewHeader : Html Msg 
viewHeader =
    let
        productPath =
            "/products/" 

        homePath =
            "/products/" 
    in
    div [ class "bg-slate-0 p-8 flex relative drop-shadow-md"] 
        [ img [ src "https://i.pinimg.com/564x/17/bb/6f/17bb6f914478d3f78dc3e71c6a040783.jpg", class "flex-start absolute bottom-3 left-3 top-0.5 w-14 h-14" ] 
            []
        , article [ class "flex-start absolute bottom-3 right-16 z-20"] 
            [ ul [ class "right-3 p-2 text-indigo-700" ] 
                [ li [ class " p-2 -mb-2 inline-block m-3 mx-2 transition-colors duration-150 rounded-lg focus:shadow-outline hover:bg-indigo-500 hover:text-slate-0" ] 
                    [ a [ href homePath, class "" ]
                        [ text "Home"]
                    ]
                , li [ class "p-2 -mb-2 inline-block m-3 mx-3 transition-colors duration-150 rounded-lg focus:shadow-outline hover:bg-indigo-500 hover:text-slate-0" ] 
                    [ a [ href productPath, class "" ]
                        [ text "Products"]
                    ]
                ]
            ] 
        , img [ src "https://cdn-icons-png.flaticon.com/512/2169/2169842.png", class "flex-end absolute bottom-5 w-7 h-7 drop-shadow-md right-6" ]
            []
        
        ]


viewSerumProduct : WebData Serum -> Html Msg
viewSerumProduct serum =
    case serum of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "" ]

        RemoteData.Success productData ->
            viewSerumProductCard productData

        RemoteData.Failure httpError ->
            viewFetchError (buildErrorMessage httpError)


viewSerumProductCard : Serum -> Html Msg
viewSerumProductCard serum =
    section [class "flex item-center justify-center"] 
        [ section [class "flex item-center justify-center bg-slate-0 p-5 pb-10 m-3 mt-16 h-3/4 w-2/4 rounded-md drop-shadow-md hover:drop-shadow-xl mx-16"]
            [ section [ class "m-7" ]  
                [ h1 [class "text-2xl text-center"]
                    [ text serum.title ]
                , article [class "flex justify-center item-center"]
                    [ img [ src serum.imgSrc, class "max-w-xs max-h-80 w-3/4 h-4/5 mx-7 my-7"] 
                        []
                    ]
                ]
            , section [ class "m-12"]
                [ p [class "text-center text-ml mb-5"]
                    [ text serum.info1 ]
                , p [ class "text-center text-xs mb-5" ]
                    [ text serum.info2 ]
                , p [ class "text-center text-xs mb-10" ]
                    [ text serum.info3 ]
                , h1 [class "text-center text-lg text-center mb-5"]
                    [ text serum.price ]
                , article [class "flex justify-center item-center"]
                    [ button [class "text-center text-sm px-3 py-2 my-2 text-indigo-700 transition-colors duration-150 border border-indigo-500 rounded-lg focus:shadow-outline hover:bg-indigo-500 hover:text-slate-0" ]
                        [ text "Add to cart" ]
                    ]
                ]
                
            ]
        ]

        
    
    

viewFetchError : String -> Html Msg
viewFetchError errorMessage =
    let
        errorHeading =
            "Couldn't fetch product at this time."
    in
    div []
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ errorMessage)
        ]