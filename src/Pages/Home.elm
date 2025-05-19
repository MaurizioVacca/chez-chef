module Pages.Home exposing (..)

import Html exposing (Html, a, article, div, h1, h2, img, section, text)
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
                    article [ Html.Attributes.class "flex flex-col gap-4 overflow-hidden bg-white border-b-[3px] border-amber-400 pb-4" ]
                        [ a [ Html.Attributes.href ("/category/" ++ String.toLower category.name) ]
                            [ img [ Html.Attributes.src category.thumb, Html.Attributes.alt category.description, Html.Attributes.class "object-cover w-full h-auto bg-gray-100" ] []
                            , h2 [ Html.Attributes.class "font-bold text-2xl px-4 pt-2 tracking-wide text-amber-900" ] [ text category.name ]
                            ]
                        ]
                )
                model.categories
            )
        ]
