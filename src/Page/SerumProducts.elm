module Page.SerumProducts exposing (Model, Msg, init, update, view, viewHeader)

import Error exposing (buildErrorMessage)
import Html exposing (..)
import Html.Attributes exposing (href, class, src, value)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Serum exposing (Serum, SerumId, serumProductsDecoder)
import RemoteData exposing (WebData)


type alias Model = 
    { serum : WebData (List Serum)
    }


type Msg
    = FetchProducts
    | SerumProductsReceived (WebData (List Serum))


init : ( Model, Cmd Msg )
init = 
    ( { serum = RemoteData.Loading }, fetchProducts )

fetchProducts : Cmd Msg
fetchProducts = 
    Http.get 
        { url = "http://localhost:5019/serum/"
        , expect = 
            serumProductsDecoder
                |> Http.expectJson (RemoteData.fromResult >> SerumProductsReceived)
        }   


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
    case msg of
        FetchProducts -> 
            ( { model | serum = RemoteData.Loading }, fetchProducts )

        SerumProductsReceived response -> 
            ( { model | serum = response }, Cmd.none ) 


-- Views


view : Model -> Html Msg 
view model = 
    div [class "bg-zinc-50"]
        [ viewHeader 
        , viewSerumProducts model.serum
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
                [ li [ class "p-2 -mb-2 inline-block m-3 mx-2 transition-colors duration-150 rounded-lg focus:shadow-outline hover:bg-indigo-500 hover:text-slate-0" ] 
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


viewSerumProducts : WebData (List Serum) -> Html Msg 
viewSerumProducts products =
    case products of
        RemoteData.NotAsked -> 
            text ""

        RemoteData.Loading -> 
            h3 [] [ text "" ]

        RemoteData.Success actualProducts -> 
            let
                acneProductPath =
                    "/acne/" 
                
                poreProductPath =
                    "/pore/" 

                serumProductPath =
                    "/serum/" 

                mouisturizingProductPath =
                    "/mouisturizing/"
            in

            div [class "max-w-screen max-h-max"]
                [ section [class "grid grid-cols-7 grid-rows-1"] 
                    [ section [class "grid col-span-1 grid-cols-1 grid-rows-6"]
                        [ ul [class ""]
                            [ li [class ""]
                                [ h3 [class "text-3xl mt-8 ml-12"] 
                                    [ text "Products" ]
                                ]
                            , li [class ""]
                                [ p [class "text-md m-1 ml-12"] 
                                    [ text "Categorys" ] 
                                ]
                            , li [class "mt-4"]
                                [ a [ href poreProductPath, class "text-center text-sm m-1 mt-2 ml-12 px-3 py-2 text-indigo-700 transition-colors duration-150 border border-indigo-500 rounded-lg focus:shadow-outline hover:bg-indigo-500 hover:text-slate-0"] 
                                    [ text "Pore" ]
                                ]
                            , li [class "mt-4"]
                                [ a [ href mouisturizingProductPath, class "text-center text-sm m-1 mt-2 ml-12 px-3 py-2 text-indigo-700 transition-colors duration-150 border border-indigo-500 rounded-lg focus:shadow-outline hover:bg-indigo-500 hover:text-slate-0"] 
                                    [ text "Mouisturizing" ]
                                ]
                            , li [class "mt-4"]
                                [ a [ href serumProductPath, class "text-center text-sm m-1 mt-2 ml-12 px-3 py-2 text-indigo-700 transition-colors duration-150 border border-indigo-500 rounded-lg focus:shadow-outline hover:bg-indigo-500 hover:text-slate-0"] 
                                    [ text "Serum" ]
                                ]
                            , li [class "mt-4"]
                                [ a [ href acneProductPath, class "text-center text-sm m-1 mt-2 ml-12 px-3 py-2 text-indigo-700 transition-colors duration-150 border border-indigo-500 rounded-lg focus:shadow-outline hover:bg-indigo-500 hover:text-slate-0"] 
                                    [ text "Acne" ]
                                ]
                            ] 
                        ]         
                    , section [class "z-10 grid col-span-6 grid-flow-row auto-rows-max grid-cols-3 gap-1"]
                        (List.map viewSerum actualProducts)  
                    ]
                ]
        
        RemoteData.Failure httpError -> 
            viewFetchError (buildErrorMessage httpError)


viewSerum : Serum -> Html Msg
viewSerum serum = 
    let
        productPath =
            "/serum/" ++ Serum.idToString serum.id
    in
    div [class "bg-slate-0 p-10 pb-10 mb-3 ml-3 mt-8 mr-14 h-6/7 w-7/8 rounded-md drop-shadow-md hover:drop-shadow-xl" ] 
        [ h1 [class "text-2xl text-center"]
            [ text serum.title ]
        , article [class "flex justify-center item-center"]
            [ img [ src serum.imgSrc, class "w-3/4 h-4/5 mx-7 my-7"] 
                []
            ]
        , h1 [class "text-lg text-center my-2"]
            [ text serum.price ]
        , article [class "grid grid-cols-2 gap-4 place-content-between"]
            [ a [ href productPath, class "p-2 z-10 -m-2 relative inline-block m-3 my-3 mx-0.5 flex-start text-center text-sm text-indigo-700 transition-colors duration-150 border border-indigo-500 rounded-lg focus:shadow-outline hover:bg-indigo-500 hover:text-slate-0" ]
                [ text "Go to product"] 
            , button [class "p-2 z-1 -m-2 relative inline-block m-3 my-3 mx-0.5 flex-start text-center text-sm text-indigo-700 transition-colors duration-150 border border-indigo-500 rounded-lg focus:shadow-outline hover:bg-indigo-500 hover:text-slate-0" ]
                [ text "Add to cart" ]
            ]
        ]
    

viewFetchError : String -> Html Msg
viewFetchError errorMessage =
    let
        errorHeading =
            "Couldn't fetch products at this time."
    in
    div []
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ errorMessage)
        ]