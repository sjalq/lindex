module TestComparisons exposing (main)

import Browser
import Html exposing (Html, div, h1, h2, h3, p, text, ul, li)
import Html.Attributes exposing (style)

-- Import our types
import Simple exposing (..)
import Game.Cards exposing (..)
import Game.Poker exposing (..)

-- Import generated comparison functions (these would be auto-generated)
-- For demonstration, we'll implement them inline


-- GENERATED COMPARISON FUNCTIONS (these would be auto-generated)

compareColor : Color -> Color -> Order
compareColor a b =
    case ( a, b ) of
        ( Red, Red ) ->
            EQ

        ( Red, Green ) ->
            LT

        ( Red, Blue ) ->
            LT

        ( Red, RGB _ _ _ ) ->
            LT

        ( Green, Red ) ->
            GT

        ( Green, Green ) ->
            EQ

        ( Green, Blue ) ->
            LT

        ( Green, RGB _ _ _ ) ->
            LT

        ( Blue, Red ) ->
            GT

        ( Blue, Green ) ->
            GT

        ( Blue, Blue ) ->
            EQ

        ( Blue, RGB _ _ _ ) ->
            LT

        ( RGB a0 a1 a2, RGB b0 b1 b2 ) ->
            compare a0 b0
                |> compareThen (compare a1 b1)
                |> compareThen (compare a2 b2)

        ( RGB _ _ _, Red ) ->
            GT

        ( RGB _ _ _, Green ) ->
            GT

        ( RGB _ _ _, Blue ) ->
            GT


compareShape : Shape -> Shape -> Order
compareShape a b =
    case ( a, b ) of
        ( Circle a0, Circle b0 ) ->
            compare a0 b0

        ( Circle _, Rectangle _ _ ) ->
            LT

        ( Circle _, Triangle _ _ _ ) ->
            LT

        ( Rectangle a0 a1, Rectangle b0 b1 ) ->
            compare a0 b0
                |> compareThen (compare a1 b1)

        ( Rectangle _ _, Circle _ ) ->
            GT

        ( Rectangle _ _, Triangle _ _ _ ) ->
            LT

        ( Triangle a0 a1 a2, Triangle b0 b1 b2 ) ->
            compare a0 b0
                |> compareThen (compare a1 b1)
                |> compareThen (compare a2 b2)

        ( Triangle _ _ _, Circle _ ) ->
            GT

        ( Triangle _ _ _, Rectangle _ _ ) ->
            GT


comparePoint : Point -> Point -> Order
comparePoint a b =
    compare a.x b.x
        |> compareThen (compare a.y b.y)


comparePerson : Person -> Person -> Order
comparePerson a b =
    compare a.name b.name
        |> compareThen (compare a.age b.age)
        |> compareThen (compare a.height b.height)


compareSuit : Suit -> Suit -> Order
compareSuit a b =
    case ( a, b ) of
        ( Clubs, Clubs ) ->
            EQ

        ( Clubs, _ ) ->
            LT

        ( Diamonds, Clubs ) ->
            GT

        ( Diamonds, Diamonds ) ->
            EQ

        ( Diamonds, _ ) ->
            LT

        ( Hearts, Clubs ) ->
            GT

        ( Hearts, Diamonds ) ->
            GT

        ( Hearts, Hearts ) ->
            EQ

        ( Hearts, Spades ) ->
            LT

        ( Spades, Spades ) ->
            EQ

        ( Spades, _ ) ->
            GT


compareRank : Rank -> Rank -> Order
compareRank a b =
    let
        rankToInt rank =
            case rank of
                Two -> 0
                Three -> 1
                Four -> 2
                Five -> 3
                Six -> 4
                Seven -> 5
                Eight -> 6
                Nine -> 7
                Ten -> 8
                Jack -> 9
                Queen -> 10
                King -> 11
                Ace -> 12
    in
    compare (rankToInt a) (rankToInt b)


compareCard : Card -> Card -> Order
compareCard a b =
    compare a.rank b.rank
        |> compareThen (compare a.suit b.suit)


compareThen : Order -> Order -> Order
compareThen second first =
    case first of
        EQ ->
            second

        _ ->
            first


-- DEMO APPLICATION

type alias Model =
    {}


type Msg
    = NoOp


main : Program () Model Msg
main =
    Browser.sandbox
        { init = {}
        , view = view
        , update = \_ model -> model
        }


view : Model -> Html Msg
view _ =
    div [ style "padding" "20px", style "font-family" "monospace" ]
        [ h1 [] [ text "Elm Auto-Compare Demonstration" ]
        , h2 [] [ text "Simple Examples" ]
        , demoColors
        , demoShapes
        , demoPoints
        , demoPeople
        , h2 [] [ text "Texas Hold'em Examples" ]
        , demoCards
        ]


demoColors : Html Msg
demoColors =
    div []
        [ h3 [] [ text "Color Comparisons" ]
        , ul []
            [ li [] [ text <| "Red vs Green: " ++ orderToString (compareColor Red Green) ++ " (Red < Green)" ]
            , li [] [ text <| "Blue vs Red: " ++ orderToString (compareColor Blue Red) ++ " (Blue > Red)" ]
            , li [] [ text <| "RGB 255 0 0 vs RGB 255 0 1: " ++ orderToString (compareColor (RGB 255 0 0) (RGB 255 0 1)) ++ " (LT)" ]
            , li [] [ text <| "Green vs RGB 0 255 0: " ++ orderToString (compareColor Green (RGB 0 255 0)) ++ " (Green < RGB)" ]
            ]
        ]


demoShapes : Html Msg
demoShapes =
    div []
        [ h3 [] [ text "Shape Comparisons" ]
        , ul []
            [ li [] [ text <| "Circle 5.0 vs Circle 10.0: " ++ orderToString (compareShape (Circle 5.0) (Circle 10.0)) ++ " (LT)" ]
            , li [] [ text <| "Rectangle 5 10 vs Rectangle 5 5: " ++ orderToString (compareShape (Rectangle 5 10) (Rectangle 5 5)) ++ " (GT)" ]
            , li [] [ text <| "Circle 5 vs Rectangle 5 5: " ++ orderToString (compareShape (Circle 5) (Rectangle 5 5)) ++ " (Circle < Rectangle)" ]
            ]
        ]


demoPoints : Html Msg
demoPoints =
    div []
        [ h3 [] [ text "Point Comparisons (Record)" ]
        , ul []
            [ li [] [ text <| "Point {x=1, y=2} vs Point {x=1, y=3}: " ++ orderToString (comparePoint { x = 1, y = 2 } { x = 1, y = 3 }) ++ " (LT)" ]
            , li [] [ text <| "Point {x=2, y=1} vs Point {x=1, y=5}: " ++ orderToString (comparePoint { x = 2, y = 1 } { x = 1, y = 5 }) ++ " (GT - x compared first)" ]
            ]
        ]


demoPeople : Html Msg
demoPeople =
    div []
        [ h3 [] [ text "Person Comparisons (Record)" ]
        , ul []
            [ li [] [ text <| "Alice (25, 5.5) vs Bob (25, 5.5): " ++ orderToString (comparePerson { name = "Alice", age = 25, height = 5.5 } { name = "Bob", age = 25, height = 5.5 }) ++ " (name compared first)" ]
            , li [] [ text <| "Same name, different age: " ++ orderToString (comparePerson { name = "Alice", age = 25, height = 5.5 } { name = "Alice", age = 30, height = 5.5 }) ++ " (LT)" ]
            ]
        ]


demoCards : Html Msg
demoCards =
    div []
        [ h3 [] [ text "Card Comparisons" ]
        , ul []
            [ li [] [ text <| "Ace of Spades vs King of Spades: " ++ orderToString (compareCard { rank = Ace, suit = Spades } { rank = King, suit = Spades }) ++ " (GT - Ace > King)" ]
            , li [] [ text <| "Ten of Hearts vs Ten of Diamonds: " ++ orderToString (compareCard { rank = Ten, suit = Hearts } { rank = Ten, suit = Diamonds }) ++ " (GT - Hearts > Diamonds)" ]
            , li [] [ text <| "Two of Clubs vs Ace of Spades: " ++ orderToString (compareCard { rank = Two, suit = Clubs } { rank = Ace, suit = Spades }) ++ " (LT - rank compared first)" ]
            ]
        , p [] [ text "Note: These comparisons follow F#'s default sorting rules:" ]
        , ul []
            [ li [] [ text "1. For DUs: Compare by constructor order (as defined), then arguments left-to-right" ]
            , li [] [ text "2. For Records: Compare fields in declaration order" ]
            , li [] [ text "3. Constructor order: Clubs < Diamonds < Hearts < Spades (as declared)" ]
            , li [] [ text "4. Rank order: Two < Three < ... < King < Ace (as declared)" ]
            ]
        ]


orderToString : Order -> String
orderToString order =
    case order of
        LT ->
            "LT"

        EQ ->
            "EQ"

        GT ->
            "GT"