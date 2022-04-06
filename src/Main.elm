module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav 
import Html exposing (..)
import Page.ListProducts as ListProducts
import Page.OneProduct as OneProduct
import Page.AcneProducts as AcneProducts
import Page.OneAcneProduct as OneAcneProduct
import Page.PoreProducts as PoreProducts
import Page.OnePoreProduct as OnePoreProduct
import Page.SerumProducts as SerumProducts
import Page.OneSerumProduct as OneSerumProduct
import Page.MouisturizingProducts as MouisturizingProducts
import Page.OneMouisturizingProduct as OneMouisturizingProduct
import Route exposing (Route)
import Url exposing (Url)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    }


type Page
    = NotFoundPage
    | ListPage ListProducts.Model
    | OneProductPage OneProduct.Model
    | AcnePage AcneProducts.Model
    | OneAcneProductPage OneAcneProduct.Model
    | PorePage PoreProducts.Model
    | OnePoreProductPage OnePoreProduct.Model
    | SerumPage SerumProducts.Model
    | OneSerumProductPage OneSerumProduct.Model
    | MouisturizingPage MouisturizingProducts.Model
    | OneMouisturizingProductPage OneMouisturizingProduct.Model


type Msg
    = ListPageMsg ListProducts.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url
    | OneProductPageMsg OneProduct.Msg
    | AcnePageMsg AcneProducts.Msg
    | OneAcneProductPageMsg OneAcneProduct.Msg
    | PorePageMsg PoreProducts.Msg
    | OnePoreProductPageMsg OnePoreProduct.Msg
    | SerumPageMsg SerumProducts.Msg
    | OneSerumProductPageMsg OneSerumProduct.Msg
    | MouisturizingPageMsg MouisturizingProducts.Msg
    | OneMouisturizingProductPageMsg OneMouisturizingProduct.Msg


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage 
            , navKey = navKey
            }
    in
    initCurrentPage ( model, Cmd.none )


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                Route.NotFound ->
                    ( NotFoundPage, Cmd.none )

                Route.Products ->
                    let
                        ( pageModel, pageCmds ) =
                            ListProducts.init
                    in
                    ( ListPage pageModel, Cmd.map ListPageMsg pageCmds )

                Route.Product productId ->
                    let
                        ( pageModel, pageCmd ) =
                            OneProduct.init productId model.navKey
                    in
                    ( OneProductPage pageModel, Cmd.map OneProductPageMsg pageCmd )

                Route.AcneProducts ->
                    let
                        ( pageModel, pageCmds ) =
                            AcneProducts.init
                    in
                    ( AcnePage pageModel, Cmd.map AcnePageMsg pageCmds )

                Route.Acne acneId ->
                    let
                        ( pageModel, pageCmd ) =
                            OneAcneProduct.init acneId model.navKey
                    in
                    ( OneAcneProductPage pageModel, Cmd.map OneAcneProductPageMsg pageCmd )

                Route.PoreProducts ->
                    let
                        ( pageModel, pageCmds ) =
                            PoreProducts.init
                    in
                    ( PorePage pageModel, Cmd.map PorePageMsg pageCmds )

                Route.Pore poreId ->
                    let
                        ( pageModel, pageCmd ) =
                            OnePoreProduct.init poreId model.navKey
                    in
                    ( OnePoreProductPage pageModel, Cmd.map OnePoreProductPageMsg pageCmd )

                Route.SerumProducts ->
                    let
                        ( pageModel, pageCmds ) =
                            SerumProducts.init
                    in
                    ( SerumPage pageModel, Cmd.map SerumPageMsg pageCmds )

                Route.Serum serumId ->
                    let
                        ( pageModel, pageCmd ) =
                            OneSerumProduct.init serumId model.navKey
                    in
                    ( OneSerumProductPage pageModel, Cmd.map OneSerumProductPageMsg pageCmd )

                Route.MouisturizingProducts ->
                    let
                        ( pageModel, pageCmds ) =
                            MouisturizingProducts.init
                    in
                    ( MouisturizingPage pageModel, Cmd.map MouisturizingPageMsg pageCmds )

                Route.Mouisturizing mouisturizingId ->
                    let
                        ( pageModel, pageCmd ) =
                            OneMouisturizingProduct.init mouisturizingId model.navKey
                    in
                    ( OneMouisturizingProductPage pageModel, Cmd.map OneMouisturizingProductPageMsg pageCmd )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )


view : Model -> Document Msg 
view model = 
    { title = "Webshop App"
    , body = [ currentView model ]
    }


currentView : Model -> Html Msg
currentView model =
    case model.page of 
        NotFoundPage -> 
            notFoundView

        ListPage pageModel ->
            ListProducts.view pageModel
                |> Html.map ListPageMsg
    
        OneProductPage pageModel ->
            OneProduct.view pageModel
                |> Html.map OneProductPageMsg 

        AcnePage pageModel ->
            AcneProducts.view pageModel
                |> Html.map AcnePageMsg

        OneAcneProductPage pageModel ->
            OneAcneProduct.view pageModel
                |> Html.map OneAcneProductPageMsg 

        PorePage pageModel ->
            PoreProducts.view pageModel
                |> Html.map PorePageMsg

        OnePoreProductPage pageModel ->
            OnePoreProduct.view pageModel
                |> Html.map OnePoreProductPageMsg 

        SerumPage pageModel ->
            SerumProducts.view pageModel
                |> Html.map SerumPageMsg

        OneSerumProductPage pageModel ->
            OneSerumProduct.view pageModel
                |> Html.map OneSerumProductPageMsg 

        MouisturizingPage pageModel ->
            MouisturizingProducts.view pageModel
                |> Html.map MouisturizingPageMsg

        OneMouisturizingProductPage pageModel ->
            OneMouisturizingProduct.view pageModel
                |> Html.map OneMouisturizingProductPageMsg 


notFoundView : Html msg
notFoundView =
    h3 [] [ text "Oops! The page you requested was not found!" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( ListPageMsg subMsg, ListPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    ListProducts.update subMsg pageModel
            in
            ( { model | page = ListPage updatedPageModel }
            , Cmd.map ListPageMsg updatedCmd
            )

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        ( UrlChanged url, _ ) ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> initCurrentPage

        ( OneProductPageMsg subMsg, OneProductPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    OneProduct.update subMsg pageModel
            in
            ( { model | page = OneProductPage updatedPageModel }
            , Cmd.map OneProductPageMsg updatedCmd
            )

        ( AcnePageMsg subMsg, AcnePage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    AcneProducts.update subMsg pageModel
            in
            ( { model | page = AcnePage updatedPageModel }
            , Cmd.map AcnePageMsg updatedCmd
            )

        ( OneAcneProductPageMsg subMsg, OneAcneProductPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    OneAcneProduct.update subMsg pageModel
            in
            ( { model | page = OneAcneProductPage updatedPageModel }
            , Cmd.map OneAcneProductPageMsg updatedCmd
            )

        ( PorePageMsg subMsg, PorePage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    PoreProducts.update subMsg pageModel
            in
            ( { model | page = PorePage updatedPageModel }
            , Cmd.map PorePageMsg updatedCmd
            )

        ( OnePoreProductPageMsg subMsg, OnePoreProductPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    OnePoreProduct.update subMsg pageModel
            in
            ( { model | page = OnePoreProductPage updatedPageModel }
            , Cmd.map OnePoreProductPageMsg updatedCmd
            )

        ( SerumPageMsg subMsg, SerumPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    SerumProducts.update subMsg pageModel
            in
            ( { model | page = SerumPage updatedPageModel }
            , Cmd.map SerumPageMsg updatedCmd
            )

        ( OneSerumProductPageMsg subMsg, OneSerumProductPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    OneSerumProduct.update subMsg pageModel
            in
            ( { model | page = OneSerumProductPage updatedPageModel }
            , Cmd.map OneSerumProductPageMsg updatedCmd
            )

        ( MouisturizingPageMsg subMsg, MouisturizingPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    MouisturizingProducts.update subMsg pageModel
            in
            ( { model | page = MouisturizingPage updatedPageModel }
            , Cmd.map MouisturizingPageMsg updatedCmd
            )

        ( OneMouisturizingProductPageMsg subMsg, OneMouisturizingProductPage pageModel ) ->
            let
                ( updatedPageModel, updatedCmd ) =
                    OneMouisturizingProduct.update subMsg pageModel
            in
            ( { model | page = OneMouisturizingProductPage updatedPageModel }
            , Cmd.map OneMouisturizingProductPageMsg updatedCmd
            )

        ( _, _ ) ->
            ( model, Cmd.none )