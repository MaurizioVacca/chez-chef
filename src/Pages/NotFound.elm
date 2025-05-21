module Pages.NotFound exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes
import Ui.Typography


view : Html msg
view =
    div [ Html.Attributes.attribute "data-cy" "not-found" ] [ Ui.Typography.mainTitle [ text "Not Found" ] ]
