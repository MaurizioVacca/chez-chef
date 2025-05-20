module Ui.Pending exposing (..)

import Html exposing (Html, div)
import Html.Attributes
import Ui.Icons


indicator : Html msg
indicator =
    div [ Html.Attributes.class "fixed flex w-full h-full bg-white opacity-70 backdrop-blur-lg top-0 left-0 justify-center items-center" ]
        [ div
            [ Html.Attributes.class "animate-pulse text-orange-600 w-32 h-32 rounded-full border-b-orange-600 border-4 flex justify-center items-center"
            ]
            [ Ui.Icons.icon Ui.Icons.Logo ]
        ]
