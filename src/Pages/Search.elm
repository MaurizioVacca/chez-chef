module Pages.Search exposing (..)

import Html exposing (Html, article, section, text)
import Html.Attributes
import Recipe
import Ui.RecipeCard
import Ui.Typography


type alias Model =
    { recipes : List Recipe.RecipeOverview
    , title : String
    }


view : Model -> Html msg
view { recipes, title } =
    article []
        [ Ui.Typography.mainTitle [ text title ]
        , section [ Html.Attributes.class "grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 pb-4 gap-6 md:gap-8 mt-10" ]
            (List.map
                (\recipeOverview ->
                    Ui.RecipeCard.overviewCard recipeOverview
                )
                recipes
            )
        ]
