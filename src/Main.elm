module Main exposing (..)

import Browser
import Browser.Navigation
import Category
import Html exposing (Html, a, div, footer, header, input, li, main_, nav, section, span, text, ul)
import Html.Attributes
import Html.Events
import Ingredient
import Json.Decode
import Pages.Category
import Pages.Error
import Pages.Home
import Pages.NotFound
import Pages.Recipe
import Pages.Search
import Ports
import Recipe
import Route
import Shared
import Ui.Icons
import Ui.Pending
import Url
import Utils


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
    , search : SearchState
    , recipeIndex : List Recipe.RecipeOverview
    }


type SearchState
    = Inactive String
    | Active String


type SharedState
    = Preload
    | Ready Shared.Model
    | Failed


{-| Match Pages directory 1:1. Any change to available Routes
will most be reflected here as well.
-}
type Pages
    = HomePage
    | CategoryPage (Maybe Pages.Category.Model)
    | RecipePage (Maybe Pages.Recipe.Model)
    | SearchPage (Maybe Pages.Search.Model)
    | FavouritesPage
    | NotFoundPage


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        model =
            Model
                key
                url
                Preload
                HomePage
                (Inactive "")
                []
    in
    initByRoute model


initByRoute : Model -> ( Model, Cmd Msg )
initByRoute model =
    let
        route =
            Route.parseUrl model.url

        sharedCmd =
            case model.shared of
                Preload ->
                    [ Cmd.map LoadCategories Category.getCategories ]

                _ ->
                    [ Cmd.none ]

        ( currentPage, mappedCmds ) =
            case route of
                Route.Home ->
                    ( HomePage, Cmd.batch sharedCmd )

                Route.Category categoryName ->
                    ( CategoryPage Nothing
                    , Cmd.batch ([ Cmd.map LoadRecipes (Recipe.getRecipesByCategory categoryName) ] ++ sharedCmd)
                    )

                Route.Favourites ->
                    ( FavouritesPage, Cmd.batch sharedCmd )

                Route.Search searchValue queryIndex ->
                    let
                        searchCmd =
                            case queryIndex of
                                Just _ ->
                                    Cmd.map SearchRecipes (Recipe.getRecipesByIngredient searchValue)

                                Nothing ->
                                    Cmd.map SearchRecipes (Recipe.getRecipesByName searchValue)
                    in
                    ( SearchPage Nothing, Cmd.batch (sharedCmd ++ [ searchCmd ]) )

                Route.NotFound ->
                    ( NotFoundPage, Cmd.batch sharedCmd )

                Route.Recipe recipeId ->
                    ( RecipePage Nothing
                    , Cmd.batch (sharedCmd ++ [ Cmd.map LoadRecipes (Recipe.lookupRecipe recipeId) ])
                    )
    in
    ( { model | page = currentPage }, mappedCmds )



-- Update


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | LoadCategories Category.Msg
    | LoadIngredients Ingredient.Msg
    | PageMsg MappedPagesMsg
    | LoadRecipes Recipe.Msg
    | SearchRecipeIndex Recipe.Msg
    | SearchRecipes Recipe.Msg
    | QuerySuggestion String
    | RestoreSearch String
    | CollapseSearchBox
    | ReceiveFavourites (Maybe String)
    | NoOp


type MappedPagesMsg
    = RecipePageMsg Pages.Recipe.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadCategories categoryMsg ->
            case categoryMsg of
                Category.Receive result ->
                    case result of
                        Ok categories ->
                            let
                                ( sharedState, sharedCmd ) =
                                    updateSharedState model.shared (Shared.SetCategories categories)
                            in
                            ( { model | shared = sharedState }, sharedCmd )

                        Err _ ->
                            ( { model | shared = Failed }, Cmd.none )

        LoadIngredients ingredientMsg ->
            case ingredientMsg of
                Ingredient.Receive result ->
                    case result of
                        Ok ingredients ->
                            let
                                ( sharedState, _ ) =
                                    updateSharedState model.shared (Shared.SetIngredients ingredients)
                            in
                            ( { model | shared = sharedState }, Cmd.none )

                        Err _ ->
                            ( model, Cmd.none )

        PageMsg pageMsg ->
            case pageMsg of
                RecipePageMsg recipePageMsg ->
                    case recipePageMsg of
                        Pages.Recipe.SharedMsg sharedMsg ->
                            let
                                ( sharedState, sharedCmd ) =
                                    updateSharedState model.shared sharedMsg
                            in
                            ( { model | shared = sharedState }, sharedCmd )

        LoadRecipes recipeMsg ->
            case recipeMsg of
                Recipe.ReceiveRecipes result ->
                    case result of
                        Ok value ->
                            ( { model | page = CategoryPage (Just (Pages.Category.Model value)) }, Cmd.none )

                        Err _ ->
                            ( { model | page = NotFoundPage }, Cmd.none )

                Recipe.ReceiveRecipeLookup result ->
                    case result of
                        Ok value ->
                            case value of
                                Just recipe ->
                                    ( { model
                                        | page = RecipePage (Just (Pages.Recipe.Model recipe))
                                        , search = Inactive ""
                                      }
                                    , Cmd.none
                                    )

                                Nothing ->
                                    ( { model | page = NotFoundPage }, Cmd.none )

                        Err _ ->
                            ( { model | page = NotFoundPage }, Cmd.none )

        LinkClicked url ->
            case url of
                Browser.Internal internalURL ->
                    ( model, Browser.Navigation.pushUrl model.key (Url.toString internalURL) )

                -- Not needed currently, as we're don't have any external href, but it can be useful (e.g. YouTube links)
                Browser.External _ ->
                    ( model, Cmd.none )

        UrlChanged url ->
            { model | url = url }
                |> initByRoute

        SearchRecipeIndex recipeMsg ->
            case recipeMsg of
                Recipe.ReceiveRecipes result ->
                    case result of
                        Ok recipes ->
                            ( { model | recipeIndex = recipes }, Cmd.none )

                        Err _ ->
                            ( model, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        SearchRecipes recipeMsg ->
            case recipeMsg of
                Recipe.ReceiveRecipes result ->
                    case result of
                        Ok recipes ->
                            ( { model | page = SearchPage (Just (Pages.Search.Model recipes "Search Results")) }, Cmd.none )

                        Err _ ->
                            ( { model | page = NotFoundPage }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        QuerySuggestion queryString ->
            ( { model | search = Active queryString }, Cmd.map SearchRecipeIndex (Recipe.getRecipesByName queryString) )

        RestoreSearch queryString ->
            ( { model | search = Active queryString }, Cmd.none )

        CollapseSearchBox ->
            case model.search of
                Inactive _ ->
                    ( model, Cmd.none )

                Active string ->
                    ( { model | search = Inactive string }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        ReceiveFavourites storedFavourites ->
            case storedFavourites of
                Just val ->
                    let
                        favourites =
                            Recipe.loadFavourites val

                        ( sharedState, _ ) =
                            updateSharedState model.shared (Shared.LoadFavourites favourites)
                    in
                    ( { model | shared = sharedState }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )


updateSharedState : SharedState -> Shared.Msg -> ( SharedState, Cmd Msg )
updateSharedState sharedModel sharedMsg =
    case sharedMsg of
        Shared.LoadFavourites favourites ->
            case sharedModel of
                Ready model ->
                    ( Ready { model | favourites = favourites }, Cmd.none )

                _ ->
                    ( sharedModel, Cmd.none )

        Shared.ToggleFavourite recipe ->
            case sharedModel of
                Ready model ->
                    let
                        favourites =
                            Recipe.toggleFavourite recipe model.favourites
                    in
                    ( Ready { model | favourites = favourites }, Recipe.saveFavourites favourites )

                _ ->
                    ( sharedModel, Cmd.none )

        Shared.SetCategories categories ->
            case sharedModel of
                Preload ->
                    ( Ready { categories = categories, favourites = [], ingredients = [] }, Cmd.batch [ Cmd.map LoadIngredients Ingredient.getIngredients, Ports.requestFavourites () ] )

                _ ->
                    ( sharedModel, Cmd.none )

        Shared.SetIngredients ingredients ->
            case sharedModel of
                Ready model ->
                    ( Ready { model | ingredients = ingredients }, Cmd.none )

                _ ->
                    ( sharedModel, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Ports.receiveFavourites ReceiveFavourites



-- View


view : Model -> Browser.Document Msg
view model =
    let
        ( pageContent, searchBox ) =
            case model.shared of
                Preload ->
                    ( [ Ui.Pending.indicator ], text "" )

                Ready sharedData ->
                    ( [ viewPage sharedData model ], viewSearchBox sharedData model )

                Failed ->
                    ( [ Pages.Error.view ], text "" )

        query =
            case model.search of
                Inactive val ->
                    val

                Active val ->
                    val
    in
    { title = Utils.appName ++ " - Everyday a new taste!"
    , body =
        [ div [ Html.Attributes.class "flex flex-col h-full", Html.Events.onClick CollapseSearchBox ]
            -- Header
            [ header [ Html.Attributes.class "w-full bg-amber-950 py-2" ]
                [ nav [ Html.Attributes.class "mx-auto px-4 sm:px-10 text-xl font-serif text-amber-100 flex justify-start items-center" ]
                    [ a [ Html.Attributes.href "/", Html.Attributes.class "flex flex-col items-center pr-2 sm:px-6" ]
                        [ span [ Html.Attributes.class "w-12 h-12 sm:w-18 sm:h-18" ] [ Ui.Icons.icon Ui.Icons.Logo ]
                        , span [ Html.Attributes.class "hidden sm:block text-sm" ] [ text Utils.appName ]
                        ]
                    , div [ Html.Attributes.class "flex-1 flex justify-center" ]
                        [ div [ Html.Attributes.class "bg-white rounded-full h-12 flex px-4 py-2 text-amber-950 shadow-2xl sm:w-[400px] relative" ]
                            [ input
                                [ Html.Attributes.type_ "text"
                                , Html.Attributes.class "outline-0 w-full"
                                , Html.Events.onInput QuerySuggestion
                                , Html.Attributes.value query
                                , Html.Events.onFocus (RestoreSearch query)
                                , Html.Attributes.attribute "data-cy" "search-box"
                                , onInputSearchClick NoOp
                                ]
                                []
                            , a
                                [ Html.Attributes.class "text-white bg-orange-600 rounded-full px-1 cursor-pointer hover:bg-orange-400 transition-colors ease-in-out inline-flex items-center"
                                , Html.Attributes.href ("/search/" ++ query)
                                ]
                                [ Ui.Icons.icon Ui.Icons.Search ]
                            , searchBox
                            ]
                        ]
                    , a
                        [ Html.Attributes.href "/favourites"
                        , Html.Attributes.class "flex flex-col items-center pl-2 sm:px-6 gap-2 sm:self-end"
                        , Html.Attributes.attribute "data-cy" "favourites-link"
                        ]
                        [ span [ Html.Attributes.class "w-8 h-8" ] [ Ui.Icons.icon Ui.Icons.Book ]
                        , span [ Html.Attributes.class "hidden sm:block text-sm" ] [ text "Favourites" ]
                        ]
                    ]
                ]

            -- Page Content
            , main_ [ Html.Attributes.class "w-full max-w-7xl mx-auto py-10 px-4 sm:px-20" ] pageContent

            -- Footer
            , footer [ Html.Attributes.class "w-full bg-amber-950 py-4 mt-auto" ]
                [ section [ Html.Attributes.class "mx-auto px-10 text-sm font-serif text-amber-100" ] [ text ("© 2025, " ++ Utils.appName) ]
                ]
            ]
        ]
    }


onInputSearchClick : Msg -> Html.Attribute Msg
onInputSearchClick msg =
    Html.Events.stopPropagationOn "click" (Json.Decode.succeed ( msg, True ))


type SearchHitIndex
    = RecipeIndex (List Recipe.RecipeOverview)
    | IngredientIndex (List Ingredient.Ingredient)


viewSearchBox : Shared.Model -> Model -> Html Msg
viewSearchBox { ingredients } { search, recipeIndex } =
    case search of
        Inactive _ ->
            text ""

        Active searchValue ->
            if String.length searchValue > 0 then
                div [ Html.Attributes.class "absolute z-10 bg-white w-full top-14 left-0 shadow-xl rounded-2xl px-4 py-6 flex flex-col gap-5" ]
                    -- Matches recipes index
                    [ viewSearchHits (RecipeIndex recipeIndex) searchValue 5
                    , viewSearchHits (IngredientIndex ingredients) searchValue 3
                    ]

            else
                text ""


viewSearchHits : SearchHitIndex -> String -> Int -> Html msg
viewSearchHits searchHitIndex query limit =
    let
        toHtml : String -> Int -> ({ a | id : Int, name : String } -> String) -> List { a | id : Int, name : String } -> List (Html msg)
        toHtml hitGroup searchLimit linkTo searchIndex =
            searchIndex
                |> List.filter (\hit -> String.toLower hit.name |> String.contains (String.toLower query))
                |> List.take searchLimit
                |> List.map
                    (\hit ->
                        li [ Html.Attributes.class "text-base", Html.Attributes.attribute "data-cy" <| hitGroup ++ "-hit" ]
                            [ a [ Html.Attributes.href (linkTo hit) ] [ text hit.name ]
                            ]
                    )

        ( title, hits, accentClass ) =
            case searchHitIndex of
                RecipeIndex recipes ->
                    ( "Recipes", recipes |> toHtml "recipe" limit Utils.toRecipePage, "border-b-pink-400" )

                IngredientIndex ingredients ->
                    ( "Ingredients", ingredients |> toHtml "ingredient" limit (Utils.toSearchPage (Just "searchIndex=ingredients")), "border-b-amber-400" )
    in
    -- Matches recipes index
    section []
        [ header [ Html.Attributes.class <| String.join " " <| [ "text-sm capitalize pb-2 border-b font-sans", accentClass ] ] [ text title ]
        , ul [ Html.Attributes.class "flex flex-col gap-4 mt-2" ] hits
        ]


viewPage : Shared.Model -> Model -> Html Msg
viewPage sharedModel model =
    let
        pageView =
            case model.page of
                HomePage ->
                    Pages.Home.view sharedModel

                CategoryPage values ->
                    let
                        maybeCategory =
                            Pages.Category.findCategoryBySlug model.url sharedModel.categories
                    in
                    case ( values, maybeCategory ) of
                        ( Just pageModel, Just category ) ->
                            Pages.Category.view category pageModel

                        _ ->
                            Ui.Pending.indicator

                FavouritesPage ->
                    Pages.Search.view <| { recipes = sharedModel.favourites, title = "Your Favourites" }

                SearchPage maybeModel ->
                    case maybeModel of
                        Just recipes ->
                            Pages.Search.view recipes

                        _ ->
                            Ui.Pending.indicator

                NotFoundPage ->
                    Pages.NotFound.view

                RecipePage maybeModel ->
                    case maybeModel of
                        Just recipe ->
                            Pages.Recipe.view sharedModel recipe |> Html.map (PageMsg << RecipePageMsg)

                        _ ->
                            Ui.Pending.indicator
    in
    div [] [ pageView ]
