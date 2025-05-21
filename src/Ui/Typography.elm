module Ui.Typography exposing (..)

import Html exposing (Html, h1, p)
import Html.Attributes


{-| A heading with emphasis.
-}
mainTitle : List (Html msg) -> Html msg
mainTitle children =
    h1
        [ Html.Attributes.class "text-4xl pb-6 text-amber-950 tracking relative before:absolute before:content-[' '] before:bottom-4 before:left-0 before:w-10 before:h-1 before:bg-amber-400"
        , Html.Attributes.attribute "data-cy" "main-title"
        ]
        children


introParagraph : List (Html msg) -> Html msg
introParagraph children =
    p [ Html.Attributes.class "leading-8 text-amber-950", Html.Attributes.attribute "data-cy" "intro-paragraph" ] children
