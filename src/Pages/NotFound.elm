module Pages.NotFound exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes


view : Html msg
view =
    div [ Html.Attributes.attribute "data-cy" "not-found" ] [ text "Not found" ]
