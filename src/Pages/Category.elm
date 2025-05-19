module Pages.Category exposing (..)

import Category exposing (Category)
import Html exposing (Html, a, article, figure, h2, img, p, section, text)
import Html.Attributes
import Recipe
import Route
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
                    article [ Html.Attributes.class "bg-white pb-6 w-72 sm:w-auto border-b-[3px] border-b-amber-300" ]
                        [ a [ Html.Attributes.href ("/recipe/" ++ String.fromInt recipeOverview.id) ]
                            [ figure [ Html.Attributes.class "overflow-hidden" ] [ img [ Html.Attributes.src (recipeOverview.thumb ++ "/medium"), Html.Attributes.class "w-72 h-80 object-cover hover:scale-110 transition-all ease-in-out" ] [] ]
                            , h2 [ Html.Attributes.class "px-2 pt-4 text-xl text-amber-900 font-semibold" ] [ text recipeOverview.name ]
                            ]
                        ]
                )
                model.recipes
            )
        ]
