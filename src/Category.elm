module Category exposing (..)

import Http
import Json.Decode
import Json.Decode.Pipeline as JDPipeline
import Utils


type alias Category =
    { id : Int
    , name : String
    , description : String
    , thumb : String
    }


type Msg
    = Receive (Result Http.Error (List Category))


getCategories : Cmd Msg
getCategories =
    Http.get { url = Utils.apiUrl ++ "categories.php", expect = Http.expectJson Receive (Json.Decode.field "categories" (Json.Decode.list categoryDecoder)) }


categoryDecoder : Json.Decode.Decoder Category
categoryDecoder =
    Json.Decode.succeed Category
        |> JDPipeline.required "idCategory" Utils.stringToInt
        |> JDPipeline.required "strCategory" Json.Decode.string
        |> JDPipeline.required "strCategoryDescription" Json.Decode.string
        |> JDPipeline.required "strCategoryThumb" Json.Decode.string
