module Recipe exposing (..)


type alias RecipeIngredient =
    { name : String, amount : String }


type alias Recipe =
    { id : Int
    , name : String
    , altName : Maybe String
    , categoryName : String
    , areaName : String
    , tags : List String
    , ingredients : List RecipeIngredient
    , instructions : String
    , thumb : String
    , videoUrl : String
    }
