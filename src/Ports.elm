port module Ports exposing (..)

{-| Available ports
-}


{-| Store favourites leveraging off LocalStorage
-}
port storeFavourites : String -> Cmd mgs


{-| Request to access local storage and get favourites
-}
port requestFavourites : () -> Cmd msg


{-| Receive existing favourites. It may be `Nothing`
-}
port receiveFavourites : (Maybe String -> msg) -> Sub msg
