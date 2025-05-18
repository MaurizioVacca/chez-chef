module Route exposing (..)

import Url
import Url.Parser


type Route
    = Home
    | Category
    | NotFound


parseUrl : Url.Url -> Route
parseUrl url =
    case Url.Parser.parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Url.Parser.Parser (Route -> a) a
matchRoute =
    Url.Parser.oneOf
        [ Url.Parser.map Home Url.Parser.top
        , Url.Parser.map Category (Url.Parser.s "category")
        ]
