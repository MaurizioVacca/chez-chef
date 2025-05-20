module Utils exposing (..)

import Json.Decode


{-| -}
appName : String
appName =
    "Chez-Chef"


{-| Define API URL.
In more advanced situations, this may be put on a dedicated .env file instead.
-}
apiUrl : String
apiUrl =
    "https://www.themealdb.com/api/json/v1/1/"


{-| Decode a string value into an int one.
-}
stringToInt : Json.Decode.Decoder Int
stringToInt =
    let
        toInt : String -> Json.Decode.Decoder Int
        toInt s =
            case String.toInt s of
                Just n ->
                    Json.Decode.succeed n

                Nothing ->
                    Json.Decode.fail (s ++ " is not an Int")
    in
    Json.Decode.string |> Json.Decode.andThen toInt


toSafeString : String -> String
toSafeString s =
    String.replace " " "_" s


toRecipePage : { a | id : Int, name : String } -> String
toRecipePage { id } =
    [ "/recipe", String.fromInt id ] |> String.join "/"


toSearchPage : { a | id : Int, name : String } -> String
toSearchPage { name } =
    [ "/recipes", name ] |> String.join "/"
