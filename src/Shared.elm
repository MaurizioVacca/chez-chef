module Shared exposing (..)

{-| Shared elements
-}

import Category
import Ingredient
import Recipe


type alias Model =
    { categories : List Category.Category
    , favourites : List Recipe.RecipeOverview
    , ingredients : List Ingredient.Ingredient
    }


type Msg
    = LoadFavourites (List Recipe.RecipeOverview)
    | ToggleFavourite Recipe.RecipeOverview
    | SetIngredients (List Ingredient.Ingredient)
    | SetCategories (List Category.Category)
