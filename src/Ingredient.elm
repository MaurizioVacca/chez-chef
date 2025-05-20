module Ingredient exposing (..)

import Http
import Json.Decode
import Json.Decode.Pipeline as JDPipeline
import Utils


type alias Ingredient =
    { id : Int
    , name : String
    }


type Msg
    = Receive (Result Http.Error (List Ingredient))


getIngredients : Cmd Msg
getIngredients =
    Http.get { url = Utils.apiUrl ++ "list.php?i=list", expect = Http.expectJson Receive (Json.Decode.field "meals" (Json.Decode.list ingredientDecoder)) }


ingredientDecoder : Json.Decode.Decoder Ingredient
ingredientDecoder =
    Json.Decode.succeed Ingredient
        |> JDPipeline.required "idIngredient" Utils.stringToInt
        |> JDPipeline.required "strIngredient" Json.Decode.string
