module Pages.Category exposing (..)

import Category exposing (Category)
import Html exposing (Html, a, article, figcaption, figure, h2, img, p, section, text)
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
                    article [ Html.Attributes.class "bg-white w-72 sm:w-auto overflow-hidden rounded" ]
                        [ a [ Html.Attributes.href ("/recipe/" ++ String.fromInt recipeOverview.id) ]
                            [ figure [ Html.Attributes.class "overflow-hidden relative" ]
                                [ img [ Html.Attributes.src (recipeOverview.thumb ++ "/medium"), Html.Attributes.class "w-72 h-80 object-cover hover:scale-110 transition-all ease-in-out" ] []
                                , figcaption [ Html.Attributes.class "px-2 py-4 text-xl text-white font-semibold absolute bg-gradient-to-t from-gray-900 to-transparent bottom-0 w-full" ] [ text recipeOverview.name ]
                                ]
                            ]
                        ]
                )
                model.recipes
            )
        ]
