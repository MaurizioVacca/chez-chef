module Pages.Home exposing (..)

import Html exposing (Html, a, article, div, figcaption, figure, h1, h2, img, section, text)
import Html.Attributes
import Shared
import Ui.Typography


view : Shared.Model -> Html msg
view model =
    section [ Html.Attributes.class "flex flex-col gap-4" ]
        [ Ui.Typography.mainTitle [ text "Categories" ]
        , Ui.Typography.introParagraph
            [ text """Welcome to our recipe categories — your gateway to culinary inspiration! Whether you're craving comforting classics, exploring international flavors,
            or searching for quick weeknight dinners, we've organized our recipes to make your cooking journey easier and more enjoyable.
            Dive in and discover delicious ideas tailored to every taste, occasion, and skill level.""" ]
        , div [ Html.Attributes.class "grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-10 mt-6" ]
            (List.map
                (\category ->
                    article [ Html.Attributes.class "flex flex-col gap-4 overflow-hidden bg-white rounded-xl shadow" ]
                        [ a [ Html.Attributes.href ("/category/" ++ String.toLower category.name) ]
                            [ figure [ Html.Attributes.class "relative" ]
                                [ img [ Html.Attributes.src category.thumb, Html.Attributes.alt category.description, Html.Attributes.class "object-cover w-full h-auto" ] []
                                , figcaption [ Html.Attributes.class "font-bold text-2xl px-4 py-2 tracking-wide text-white bg-gradient-to-t from-gray-900 to-transparent absolute bottom-0 w-full" ] [ text category.name ]
                                ]
                            ]
                        ]
                )
                model.categories
            )
        ]
