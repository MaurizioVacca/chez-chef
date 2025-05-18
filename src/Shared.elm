module Shared exposing (..)

{-| Shared elements
-}

import Category
import GeoArea


type alias Model =
    { categories : List Category.Category
    }


type SearchHitIndex
    = CategoryIndex
    | GeoAreaIndex
    | IngredientIndex


type alias SearchHit =
    { name : String
    , group : SearchHitIndex
    }
