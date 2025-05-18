module Pages.Home exposing (..)

import Html exposing (Html, article, div, h1, h2, img, section, text)
import Html.Attributes
import Shared


view : Shared.Model -> Html msg
view model =
    section [ Html.Attributes.class "flex flex-col gap-4" ]
        [ h1
            [ Html.Attributes.class "text-4xl pb-6 text-amber-950 tracking relative before:absolute before:content-[' '] before:bottom-4 before:left-0 before:w-10 before:h-1 before:bg-amber-400"
            ]
            [ text "Categories" ]
        , div [ Html.Attributes.class "grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-10" ]
            (List.map
                (\category ->
                    article [ Html.Attributes.class "flex flex-col gap-4 overflow-hidden pb-4 bg-white border-b-3 border-amber-400" ]
                        [ img [ Html.Attributes.src category.thumb, Html.Attributes.alt category.description, Html.Attributes.class "object-cover w-full h-auto bg-gray-100" ] []
                        , h2 [ Html.Attributes.class "font-bold text-2xl px-4 tracking-wide text-amber-900" ] [ text category.name ]
                        ]
                )
                model.categories
            )
        ]
