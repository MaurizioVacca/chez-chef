module Ui.Icons exposing (Icons(..), icon)

import Html exposing (Html)
import Svg exposing (circle, line, path, svg)
import Svg.Attributes


type Icons
    = Heart
    | HeartSolid
    | Search


heartShape : Html msg
heartShape =
    svg
        [ Svg.Attributes.width "24"
        , Svg.Attributes.height "24"
        , Svg.Attributes.viewBox "0 0 24 24"
        , Svg.Attributes.fill "none"
        , Svg.Attributes.stroke "currentColor"
        , Svg.Attributes.strokeWidth "2"
        ]
        [ path [ Svg.Attributes.d "M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" ] []
        ]


heartSolid : Html msg
heartSolid =
    svg
        [ Svg.Attributes.width "24"
        , Svg.Attributes.height "24"
        , Svg.Attributes.viewBox "0 0 24 24"
        , Svg.Attributes.fill "currentColor"
        , Svg.Attributes.stroke "currentColor"
        , Svg.Attributes.strokeWidth "2"
        ]
        [ path [ Svg.Attributes.d "M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" ] []
        ]


search : Html msg
search =
    svg
        [ Svg.Attributes.width "24"
        , Svg.Attributes.height "24"
        , Svg.Attributes.viewBox "0 0 24 24"
        , Svg.Attributes.fill "none"
        , Svg.Attributes.stroke "currentColor"
        , Svg.Attributes.strokeWidth "2"
        ]
        [ circle [ Svg.Attributes.cx "11", Svg.Attributes.cy "11", Svg.Attributes.r "8" ] []
        , line [ Svg.Attributes.x1 "21", Svg.Attributes.y1 "21", Svg.Attributes.x2 "16.65", Svg.Attributes.y2 "16.65" ] []
        ]


icon : Icons -> Html msg
icon iconType =
    case iconType of
        Heart ->
            heartShape

        HeartSolid ->
            heartSolid

        Search ->
            search
