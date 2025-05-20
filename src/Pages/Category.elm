module Pages.Category exposing (..)

import Category exposing (Category)
import Html exposing (Html, article, section, text)
import Html.Attributes
import Recipe
import Route
import Ui.RecipeCard
import Ui.Typography
import Url


type alias Model =
    { recipes : List Recipe.RecipeOverview
    }


findCategoryBySlug : Url.Url -> List Category -> Maybe Category
findCategoryBySlug url categories =
    let
        route =
            Route.parseUrl url

        category =
            case route of
                Route.Category categorySlug ->
                    List.head <| List.filter (\item -> String.toLower item.name == categorySlug) categories

                _ ->
                    Nothing
    in
    category


view : Category -> Model -> Html msg
view category model =
    article []
        [ Ui.Typography.mainTitle [ text <| String.join " " <| [ category.name, "Recipes" ] ]
        , Ui.Typography.introParagraph [ text category.description ]
        , section [ Html.Attributes.class "grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 pb-4 gap-6 md:gap-8 mt-10" ]
            (List.map
                (\recipeOverview ->
                    Ui.RecipeCard.overviewCard recipeOverview
                )
                model.recipes
            )
        ]
