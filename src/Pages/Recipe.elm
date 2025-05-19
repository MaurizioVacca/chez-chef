module Pages.Recipe exposing (..)

import Html exposing (Html, article, div, figure, h2, header, img, li, section, span, text, ul)
import Html.Attributes
import Recipe exposing (Recipe)
import Ui.Typography


type alias Model =
    { recipe : Recipe }


view : Model -> Html msg
view { recipe } =
    article [ Html.Attributes.class "mt-6 grid grid-cols-12 gap-8" ]
        -- Main heading and tags
        [ section [ Html.Attributes.class "col-span-12 lg:col-span-8 order-1 lg:order-2" ]
            [ header []
                [ Ui.Typography.mainTitle [ text recipe.name ]
                , ul [ Html.Attributes.class "py-4 border-b-1 border-b-amber-900 flex gap-2.5" ]
                    (List.map (\tag -> li [ Html.Attributes.class "inline-block rounded-full px-4 py-2 text-sm border-2 text-pink-700" ] [ text tag ]) recipe.tags)
                ]
            ]

        -- Picture
        , section [ Html.Attributes.class "col-span-12 lg:col-span-4 order-2 lg:order-1 lg:row-1 relative lg:col-start-1 lg:col-end-5" ]
            [ figure [ Html.Attributes.class "lg:absolute" ] [ img [ Html.Attributes.src recipe.thumb, Html.Attributes.class "aspect-video lg:aspect-3/4 object-cover object-center mx-auto" ] [] ] ]

        -- Ingredients
        , section [ Html.Attributes.class "lg:row-start-1 lg:row-end-8 col-span-12 lg:col-start-1 lg:col-end-5 order-3" ]
            [ div [ Html.Attributes.class "lg:mt-[calc(125%+40px)]" ]
                [ h2 [ Html.Attributes.class "text-xl font-semibold text-amber-950" ] [ text "Ingredients" ]
                , ul [ Html.Attributes.class "flex flex-col font-light mt-4 gap-4" ]
                    (List.map (\ingredient -> li [ Html.Attributes.class "flex justify-between" ] [ span [] [ text ingredient.name ], span [] [ text ingredient.amount ] ]) recipe.ingredients)
                ]
            ]

        -- Instructions
        , section [ Html.Attributes.class "col-span-12 lg:col-span-8 order-4 lg:col-start-5" ]
            [ h2 [ Html.Attributes.class "text-2xl mt-2 text-amber-950" ] [ text "Instructions" ]
            , section [ Html.Attributes.class "mt-6" ] [ Ui.Typography.introParagraph [ text recipe.instructions ] ]
            ]
        ]
