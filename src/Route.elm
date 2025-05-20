module Route exposing (..)

import Url
import Url.Parser exposing ((</>), (<?>))
import Url.Parser.Query


type Route
    = Home
    | Category String
    | Recipe Int
    | Search String (Maybe String)
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
        , Url.Parser.map Category (Url.Parser.s "category" </> Url.Parser.string)
        , Url.Parser.map Recipe (Url.Parser.s "recipe" </> Url.Parser.int)
        , Url.Parser.map Search (Url.Parser.s "search" </> Url.Parser.string <?> Url.Parser.Query.string "searchIndex")
        ]
