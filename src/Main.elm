module Main exposing (..)

import Browser
import Browser.Navigation
import Category
import Html exposing (Html, a, div, footer, header, img, main_, nav, section, span, text)
import Html.Attributes
import Pages.Category
import Pages.Home
import Route
import Shared
import Url


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- Model and Init


type alias Model =
    { key : Browser.Navigation.Key
    , url : Url.Url
    , shared : SharedState
    , page : Pages
    }


type SharedState
    = Preload
    | Ready Shared.Model
    | Failed


{-| Match Pages directory 1:1. Any change to Route type
will most likely be reflected here as well.
-}
type Pages
    = HomePage
    | CategoryPage
    | NotFoundPage


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        model =
            Model key url Preload HomePage
    in
    initByRoute model


initByRoute : Model -> ( Model, Cmd Msg )
initByRoute model =
    let
        route =
            Route.parseUrl model.url

        ( currentPage, mappedCmds ) =
            case route of
                Route.Home ->
                    ( HomePage, Cmd.batch [ Cmd.map LoadCategories Category.getCategories ] )

                Route.Category ->
                    ( CategoryPage, Cmd.batch [ Cmd.map LoadCategories Category.getCategories ] )

                Route.NotFound ->
                    ( NotFoundPage, Cmd.batch [ Cmd.map LoadCategories Category.getCategories ] )
    in
    ( { model | page = currentPage }, mappedCmds )



-- Update


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | LoadCategories Category.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadCategories categoryMsg ->
            case categoryMsg of
                Category.Receive result ->
                    case result of
                        Ok categories ->
                            ( { model | shared = Ready { categories = categories } }, Cmd.none )

                        Err _ ->
                            ( { model | shared = Failed }, Cmd.none )

        LinkClicked url ->
            case url of
                Browser.Internal internalURL ->
                    ( model, Browser.Navigation.pushUrl model.key (Url.toString internalURL) )

                Browser.External _ ->
                    ( model, Cmd.none )

        UrlChanged url ->
            { model | url = url }
                |> initByRoute



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- View


view : Model -> Browser.Document Msg
view model =
    let
        pageContent =
            case model.shared of
                Preload ->
                    [ div [ Html.Attributes.class "vh" ] [ text "Loading ..." ] ]

                Ready sharedData ->
                    [ viewPage sharedData model ]

                Failed ->
                    [ div [] [ text "Failed to load." ] ]
    in
    { title = "ChezChef - Everyday a new taste!"
    , body =
        [ header [ Html.Attributes.class "w-full bg-amber-950 p-4" ]
            [ nav [ Html.Attributes.class "max-w-7xl mx-auto px-10 sm:px-20 text-xl font-serif text-amber-100" ]
                [ a [ Html.Attributes.href "/", Html.Attributes.class "flex flex-col items-center w-24" ]
                    [ img [ Html.Attributes.src "/public/logo.svg", Html.Attributes.class "w-20 h-20" ] []
                    , span [] [ text "Chez-Chef" ]
                    ]
                ]
            ]
        , main_ [ Html.Attributes.class "max-w-7xl mx-auto py-10 px-10 sm:px-20" ] pageContent
        , footer [ Html.Attributes.class "w-full bg-amber-950 py-4" ] [ section [ Html.Attributes.class "max-w-7xl mx-auto px-10 sm:px-20 text-sm font-serif text-amber-100" ] [ text "Chez-Chef - 2025 ©" ] ]
        ]
    }


viewPage : Shared.Model -> Model -> Html Msg
viewPage sharedModel model =
    let
        pageView =
            case model.page of
                HomePage ->
                    Pages.Home.view sharedModel

                CategoryPage ->
                    Pages.Category.view

                NotFoundPage ->
                    div [] [ text "Not found" ]
    in
    div [] [ pageView ]
