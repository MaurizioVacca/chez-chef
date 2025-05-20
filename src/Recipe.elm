module Recipe exposing (..)

import Http
import Json.Decode
import Json.Decode.Pipeline as JDPipeline
import Json.Encode
import Ports
import Utils


type alias RecipeIngredient =
    { name : String, amount : String }


type alias Recipe =
    { id : Int
    , name : String
    , categoryName : String
    , areaName : String
    , instructions : String
    , thumb : String
    , videoUrl : String
    , tags : List String
    , ingredients : List RecipeIngredient
    }


type alias RecipeOverview =
    { id : Int
    , name : String
    , thumb : String
    }


type Msg
    = ReceiveRecipes (Result Http.Error (List RecipeOverview))
    | ReceiveRecipeLookup (Result Http.Error (Maybe Recipe))


getRecipesByCategory : String -> Cmd Msg
getRecipesByCategory categoryName =
    Http.get
        { url = Utils.apiUrl ++ "filter.php?c=" ++ categoryName
        , expect = Http.expectJson ReceiveRecipes (Json.Decode.field "meals" (Json.Decode.list recipeOverviewDecoder))
        }


getRecipesByName : String -> Cmd Msg
getRecipesByName name =
    Http.get
        { url = Utils.apiUrl ++ "search.php?s=" ++ name
        , expect = Http.expectJson ReceiveRecipes (Json.Decode.field "meals" (Json.Decode.list recipeOverviewDecoder))
        }


getRecipesByIngredient : String -> Cmd Msg
getRecipesByIngredient ingredient =
    Http.get
        { url = Utils.apiUrl ++ "filter.php?i=" ++ ingredient
        , expect = Http.expectJson ReceiveRecipes (Json.Decode.field "meals" (Json.Decode.list recipeOverviewDecoder))
        }


recipeOverviewDecoder : Json.Decode.Decoder RecipeOverview
recipeOverviewDecoder =
    Json.Decode.succeed RecipeOverview
        |> JDPipeline.required "idMeal" Utils.stringToInt
        |> JDPipeline.required "strMeal" Json.Decode.string
        |> JDPipeline.required "strMealThumb" Json.Decode.string


lookupRecipe : Int -> Cmd Msg
lookupRecipe recipeId =
    Http.get
        { url = Utils.apiUrl ++ "lookup.php?i=" ++ String.fromInt recipeId
        , expect =
            Http.expectJson ReceiveRecipeLookup
                (Json.Decode.field "meals"
                    (Json.Decode.oneOf
                        [ Json.Decode.list recipeDecoder |> Json.Decode.map List.head
                        , Json.Decode.null Nothing
                        ]
                    )
                )
        }


recipeDecoder : Json.Decode.Decoder Recipe
recipeDecoder =
    Json.Decode.succeed Recipe
        |> JDPipeline.required "idMeal" Utils.stringToInt
        |> JDPipeline.required "strMeal" Json.Decode.string
        |> JDPipeline.required "strCategory" Json.Decode.string
        |> JDPipeline.required "strArea" Json.Decode.string
        |> JDPipeline.required "strInstructions" Json.Decode.string
        |> JDPipeline.required "strMealThumb" Json.Decode.string
        |> JDPipeline.required "strYoutube" Json.Decode.string
        |> JDPipeline.optional "strTags" tagsDecoder []
        |> JDPipeline.custom recipeIngredientsDecoder


tagsDecoder : Json.Decode.Decoder (List String)
tagsDecoder =
    Json.Decode.string |> Json.Decode.map (String.split ",")


{-| Decode a set of ingredients expressed as separated fields into a
list of `RecipeIngredient`, matching them by end-digits found in key name.
It recursively calls it self unless there are
no more ingredients found.

      json =
        """
        {"strIngredient1": "Tomato sauce", "strMeasure": "1 tbsp" }
        """

     result = Decode.string json recipeIngredientsDecoder

     -- Ok [{name: "Tomato sauce", amount: "1 tbsp"}]

-}
recipeIngredientsDecoder : Json.Decode.Decoder (List RecipeIngredient)
recipeIngredientsDecoder =
    let
        groupIngredientAndAmount : Int -> List RecipeIngredient -> Json.Decode.Decoder (List RecipeIngredient)
        groupIngredientAndAmount index acc =
            let
                nameKey =
                    "strIngredient" ++ String.fromInt index

                amountKey =
                    "strMeasure" ++ String.fromInt index
            in
            Json.Decode.maybe
                (Json.Decode.succeed RecipeIngredient
                    |> JDPipeline.required nameKey (Json.Decode.oneOf [ Json.Decode.string, Json.Decode.null "" ])
                    |> JDPipeline.required amountKey (Json.Decode.oneOf [ Json.Decode.string, Json.Decode.null "" ])
                )
                |> Json.Decode.andThen
                    (\maybeIngredient ->
                        case maybeIngredient of
                            Just ingredient ->
                                groupIngredientAndAmount (index + 1) (ingredient :: acc)

                            Nothing ->
                                Json.Decode.succeed (List.reverse acc |> List.filter (\item -> item.name /= ""))
                    )
    in
    groupIngredientAndAmount 1 []


isFavourite : RecipeOverview -> List RecipeOverview -> Bool
isFavourite recipe favourites =
    List.member recipe favourites


toggleFavourite : RecipeOverview -> List RecipeOverview -> List RecipeOverview
toggleFavourite recipe favourites =
    if isFavourite recipe favourites then
        List.filter (\item -> item.id /= recipe.id) favourites

    else
        favourites ++ [ recipe ]


{-| Create a recipe overview from a full recipe model.
-}
toRecipeOverview : Recipe -> RecipeOverview
toRecipeOverview recipe =
    RecipeOverview
        recipe.id
        recipe.name
        recipe.thumb


{-| Encode a recipe overview. The result encoded JSON is perfectly compatible with recipeOverviewDecoder
-}
recipeOverviewEncoder : RecipeOverview -> Json.Encode.Value
recipeOverviewEncoder recipeOverview =
    Json.Encode.object
        [ ( "idMeal", Json.Encode.string (String.fromInt recipeOverview.id) )
        , ( "strMeal", Json.Encode.string recipeOverview.name )
        , ( "strMealThumb", Json.Encode.string recipeOverview.thumb )
        ]


saveFavourites : List RecipeOverview -> Cmd msg
saveFavourites recipeOverviewList =
    Json.Encode.list recipeOverviewEncoder recipeOverviewList
        |> Json.Encode.encode 0
        |> Ports.storeFavourites


loadFavourites : String -> List RecipeOverview
loadFavourites storedFavourites =
    let
        favourites =
            Json.Decode.decodeString (Json.Decode.list recipeOverviewDecoder) storedFavourites
    in
    case favourites of
        Ok favouriteList ->
            favouriteList

        -- Unable to decode: invalid/corrupted data
        Err err ->
            let
                _ =
                    Debug.log "-- An error occurred: " err
            in
            []
