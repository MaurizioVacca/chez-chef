module Ui.RecipeCard exposing (..)

import Html exposing (Html, a, article, figcaption, figure, img, text)
import Html.Attributes
import Recipe


overviewCard : Recipe.RecipeOverview -> Html msg
overviewCard recipeOverview =
    article [ Html.Attributes.class "bg-white w-72 sm:w-auto overflow-hidden rounded" ]
        [ a [ Html.Attributes.href ("/recipe/" ++ String.fromInt recipeOverview.id) ]
            [ figure [ Html.Attributes.class "overflow-hidden relative" ]
                [ img
                    [ Html.Attributes.src (recipeOverview.thumb ++ "/medium")
                    , Html.Attributes.class "w-72 h-80 object-cover hover:scale-110 transition-all ease-in-out"
                    ]
                    []
                , figcaption
                    [ Html.Attributes.class "px-2 py-4 text-xl text-white font-semibold absolute bg-gradient-to-t from-gray-900 to-transparent bottom-0 w-full"
                    ]
                    [ text recipeOverview.name ]
                ]
            ]
        ]
