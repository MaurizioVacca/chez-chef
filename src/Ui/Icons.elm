module Ui.Icons exposing (Icons(..), icon)

import Html exposing (Html)
import Svg exposing (circle, g, line, path, svg)
import Svg.Attributes


type Icons
    = Heart
    | HeartSolid
    | Logo
    | Search
    | Book


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


logo : Html msg
logo =
    svg
        [ Svg.Attributes.width "100%"
        , Svg.Attributes.height "100%"
        , Svg.Attributes.viewBox "0 0 640 640"
        , Svg.Attributes.fill "currentColor"
        ]
        [ g [ Svg.Attributes.transform "matrix(1,0,0,1,-1400,-500)" ]
            [ g [ Svg.Attributes.transform "matrix(1,0,0,1,907.5,270)" ]
                [ path
                    [ Svg.Attributes.d "M762.454,325.704C754.857,347.811 762.842,356.961 771.964,367.968C779.575,377.151 789.332,400.017 767.659,412.356C767.847,391.595 764.242,388.107 750,374.064C738.417,362.643 739.219,329.141 762.454,325.704Z"
                    ]
                    []
                , g [ Svg.Attributes.transform "matrix(1.30899,0,0,1.41204,-172.253,-171.087)" ]
                    [ path [ Svg.Attributes.d "M763.218,326.539C755.621,348.646 761.314,356.252 768.908,364.427C773.123,368.964 781.762,381.344 780.885,390.276C780.066,398.621 773.019,407.231 762.55,413.191C762.739,392.429 764.242,388.107 750,374.064C738.417,362.643 739.982,329.975 763.218,326.539Z" ] [] ]
                , g [ Svg.Attributes.transform "matrix(1.85304,0,0,1.09091,-548.091,-63.6364)" ]
                    [ path [ Svg.Attributes.d "M656,700L734.25,590L812.5,700L812.5,773.333C812.5,773.333 787.55,769.368 776.073,773.333C762.807,777.917 748.371,800.833 732.901,800.833C718.51,800.833 702.545,777.917 689.728,773.333C679.142,769.548 656,773.333 656,773.333L656,700ZM737.374,656L737.374,701.833L758.96,701.833L758.96,692.667C758.96,672.43 749.288,656 737.374,656ZM737.218,709.167L737.218,755L758.804,755L758.804,709.167L737.218,709.167ZM731.822,656C719.908,656 710.235,672.43 710.235,692.667L710.235,701.833L731.822,701.833L731.822,656ZM731.822,709.167L710.235,709.167L710.235,755L731.822,755L731.822,709.167ZM655.067,681.667L651.737,653.928C627.57,649.503 608.78,616.856 608.78,577.294C608.78,534.716 630.543,500.149 657.349,500.149C666.681,500.149 675.402,504.338 682.806,511.596C687.903,477.838 709.014,443.333 734.25,443.333C759.486,443.333 780.597,477.838 785.694,511.596C793.098,504.338 801.819,500.149 811.151,500.149C837.957,500.149 859.72,534.716 859.72,577.294C859.72,616.856 840.93,649.503 816.763,653.928L813.433,681.667L734.25,573.102L655.067,681.667Z" ] [] ]
                ]
            ]
        ]


bookShape : Html msg
bookShape =
    svg
        [ Svg.Attributes.width "100%"
        , Svg.Attributes.height "100%"
        , Svg.Attributes.viewBox "0 0 24 24"
        , Svg.Attributes.fill "none"
        , Svg.Attributes.stroke "currentColor"
        , Svg.Attributes.strokeWidth "2"
        ]
        [ path [ Svg.Attributes.d "M4 19.5A2.5 2.5 0 0 1 6.5 17H20" ] [], path [ Svg.Attributes.d "M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z" ] [] ]


icon : Icons -> Html msg
icon iconType =
    case iconType of
        Heart ->
            heartShape

        HeartSolid ->
            heartSolid

        Search ->
            search

        Logo ->
            logo

        Book ->
            bookShape
