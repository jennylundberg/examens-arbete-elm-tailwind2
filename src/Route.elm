module Route exposing (Route(..), parseUrl, pushUrl)

import Browser.Navigation as Nav 
import Product exposing (ProductId)
import Acne exposing (AcneId)
import Pore exposing (PoreId)
import Serum exposing (SerumId)
import Mouisturizing exposing (MouisturizingId)
import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = NotFound
    | Products
    | Product ProductId
    | AcneProducts
    | Acne AcneId
    | PoreProducts
    | Pore PoreId
    | SerumProducts
    | Serum SerumId
    | MouisturizingProducts
    | Mouisturizing MouisturizingId


parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Products top 
        , map Products (s "products")
        , map Product (s "products" </> Product.idParser)
        , map AcneProducts (s "acne")
        , map Acne (s "acne" </> Acne.idParser)
        , map PoreProducts (s "pore")
        , map Pore (s "pore" </> Pore.idParser)
        , map SerumProducts (s "serum")
        , map Serum (s "serum" </> Serum.idParser)
        , map MouisturizingProducts (s "mouisturizing")
        , map Mouisturizing (s "mouisturizing" </> Mouisturizing.idParser)
        ]


pushUrl : Route -> Nav.Key -> Cmd msg
pushUrl route navKey =
    routeToString route
        |> Nav.pushUrl navKey


routeToString : Route -> String
routeToString route =
    case route of
        NotFound ->
            "/not-found"

        Products ->
            "/products"

        Product productId ->
            "/products/" ++ Product.idToString productId

        AcneProducts -> 
            "/acne"

        Acne acneId ->
            "/acne/" ++ Acne.idToString acneId

        PoreProducts -> 
            "/pore"

        Pore poreId ->
            "/pore/" ++ Pore.idToString poreId

        SerumProducts -> 
            "/serum"

        Serum serumId ->
            "/serum/" ++ Serum.idToString serumId

        MouisturizingProducts -> 
            "/mouisturizing"

        Mouisturizing mouisturizingId ->
            "/mouisturizing/" ++ Mouisturizing.idToString mouisturizingId