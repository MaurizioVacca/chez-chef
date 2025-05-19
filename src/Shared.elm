module Shared exposing (..)

{-| Shared elements
-}

import Category
import GeoArea
import Recipe


type alias Model =
    { categories : List Category.Category
    , favourites : List Int
    }


type SearchHitIndex
    = CategoryIndex
    | GeoAreaIndex
    | IngredientIndex


type alias SearchHit =
    { name : String
    , group : SearchHitIndex
    }


type Msg
    = LoadFavourites (List Recipe.Recipe)
    | ToggleFavourite Recipe.Recipe
