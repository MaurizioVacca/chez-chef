module Shared exposing (..)

{-| Shared elements
-}

import Category
import Ingredient
import Recipe


type alias Model =
    { categories : List Category.Category
    , favourites : List Int
    , ingredients : List Ingredient.Ingredient
    }


type Msg
    = LoadFavourites (List Recipe.Recipe)
    | ToggleFavourite Recipe.Recipe
    | SetIngredients (List Ingredient.Ingredient)
