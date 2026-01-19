module Simple exposing (..)

{-| Simple examples to demonstrate auto-generated comparison functions.
-}


type Color
    = Red
    | Green
    | Blue
    | RGB Int Int Int


type Shape
    = Circle Float
    | Rectangle Float Float
    | Triangle Float Float Float


type alias Point =
    { x : Float
    , y : Float
    }


type alias Person =
    { name : String
    , age : Int
    , height : Float
    }