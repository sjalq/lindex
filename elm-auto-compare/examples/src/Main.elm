module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, h2, h3, p, text, ul, li, pre)
import Html.Attributes exposing (style)

-- Import our types
import Simple exposing (..)
import Game.Cards exposing (..)
import Game.Poker exposing (..)

-- Import generated comparison functions
import Generated.Simple.ColorCompare exposing (compareColor)
import Generated.Simple.ShapeCompare exposing (compareShape)
import Generated.Simple.PointCompare exposing (comparePoint)
import Generated.Simple.PersonCompare exposing (comparePerson)
import Generated.Game.Cards.SuitCompare exposing (compareSuit)
import Generated.Game.Cards.RankCompare exposing (compareRank)
import Generated.Game.Cards.CardCompare exposing (compareCard)
import Generated.Game.Poker.PositionCompare exposing (comparePosition)
import Generated.Game.Poker.PlayerStatusCompare exposing (comparePlayerStatus)


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
        [ h1 [] [ text "Elm Auto-Compare Test Suite" ]
        , p [] [ text "Testing auto-generated comparison functions following F# rules" ]
        , h2 [] [ text "Simple Type Tests" ]
        , testColors
        , testShapes
        , testPoints
        , testPeople
        , h2 [] [ text "Texas Hold'em Tests" ]
        , testSuits
        , testRanks
        , testCards
        , testPositions
        , testPlayerStatus
        ]


testColors : Html Msg
testColors =
    div []
        [ h3 [] [ text "Color Comparisons" ]
        , ul []
            [ testComparison "Red vs Green" compareColor Red Green LT
            , testComparison "Blue vs Red" compareColor Blue Red GT
            , testComparison "Green vs Green" compareColor Green Green EQ
            , testComparison "RGB 100 50 25 vs RGB 100 50 30" compareColor (RGB 100 50 25) (RGB 100 50 30) LT
            , testComparison "RGB 100 50 25 vs RGB 100 40 25" compareColor (RGB 100 50 25) (RGB 100 40 25) GT
            , testComparison "Red vs RGB 255 0 0" compareColor Red (RGB 255 0 0) LT
            ]
        ]


testShapes : Html Msg
testShapes =
    div []
        [ h3 [] [ text "Shape Comparisons" ]
        , ul []
            [ testComparison "Circle 5 vs Circle 10" compareShape (Circle 5) (Circle 10) LT
            , testComparison "Rectangle 5 5 vs Rectangle 5 10" compareShape (Rectangle 5 5) (Rectangle 5 10) LT
            , testComparison "Circle 5 vs Rectangle 5 5" compareShape (Circle 5) (Rectangle 5 5) LT
            , testComparison "Triangle 3 4 5 vs Triangle 3 4 5" compareShape (Triangle 3 4 5) (Triangle 3 4 5) EQ
            ]
        ]


testPoints : Html Msg
testPoints =
    div []
        [ h3 [] [ text "Point Comparisons (Record)" ]
        , ul []
            [ testComparison "Point {x=1, y=2} vs Point {x=1, y=3}" comparePoint { x = 1, y = 2 } { x = 1, y = 3 } LT
            , testComparison "Point {x=2, y=1} vs Point {x=1, y=5}" comparePoint { x = 2, y = 1 } { x = 1, y = 5 } GT
            , testComparison "Point {x=3, y=4} vs Point {x=3, y=4}" comparePoint { x = 3, y = 4 } { x = 3, y = 4 } EQ
            ]
        ]


testPeople : Html Msg
testPeople =
    div []
        [ h3 [] [ text "Person Comparisons (Record)" ]
        , ul []
            [ testComparison "Alice(25,5.5) vs Bob(25,5.5)" comparePerson 
                { name = "Alice", age = 25, height = 5.5 } 
                { name = "Bob", age = 25, height = 5.5 } 
                LT
            , testComparison "Same name, different age" comparePerson 
                { name = "Alice", age = 25, height = 5.5 } 
                { name = "Alice", age = 30, height = 5.5 } 
                LT
            , testComparison "Same name and age, different height" comparePerson 
                { name = "Bob", age = 30, height = 6.0 } 
                { name = "Bob", age = 30, height = 5.8 } 
                GT
            ]
        ]


testSuits : Html Msg
testSuits =
    div []
        [ h3 [] [ text "Suit Comparisons" ]
        , ul []
            [ testComparison "Clubs vs Diamonds" compareSuit Clubs Diamonds LT
            , testComparison "Hearts vs Diamonds" compareSuit Hearts Diamonds GT
            , testComparison "Spades vs Hearts" compareSuit Spades Hearts GT
            , testComparison "Diamonds vs Diamonds" compareSuit Diamonds Diamonds EQ
            ]
        ]


testRanks : Html Msg
testRanks =
    div []
        [ h3 [] [ text "Rank Comparisons" ]
        , ul []
            [ testComparison "Two vs Three" compareRank Two Three LT
            , testComparison "King vs Ace" compareRank King Ace LT
            , testComparison "Jack vs Ten" compareRank Jack Ten GT
            , testComparison "Five vs Five" compareRank Five Five EQ
            ]
        ]


testCards : Html Msg
testCards =
    div []
        [ h3 [] [ text "Card Comparisons" ]
        , ul []
            [ testComparison "2♣ vs 3♣" compareCard 
                { rank = Two, suit = Clubs } 
                { rank = Three, suit = Clubs } 
                LT
            , testComparison "K♠ vs K♥" compareCard 
                { rank = King, suit = Spades } 
                { rank = King, suit = Hearts } 
                GT
            , testComparison "A♦ vs 2♠" compareCard 
                { rank = Ace, suit = Diamonds } 
                { rank = Two, suit = Spades } 
                GT
            ]
        ]


testPositions : Html Msg
testPositions =
    div []
        [ h3 [] [ text "Position Comparisons" ]
        , ul []
            [ testComparison "Button vs SmallBlind" comparePosition Button SmallBlind LT
            , testComparison "BigBlind vs UnderTheGun" comparePosition BigBlind UnderTheGun LT
            , testComparison "MiddlePosition 1 vs MiddlePosition 2" comparePosition (MiddlePosition 1) (MiddlePosition 2) LT
            , testComparison "CutOff vs Button" comparePosition CutOff Button GT
            ]
        ]


testPlayerStatus : Html Msg
testPlayerStatus =
    div []
        [ h3 [] [ text "PlayerStatus Comparisons" ]
        , ul []
            [ testComparison "Active vs Folded" comparePlayerStatus Active Folded LT
            , testComparison "AllIn 100 vs AllIn 200" comparePlayerStatus (AllIn 100) (AllIn 200) LT
            , testComparison "SittingOut vs AllIn 500" comparePlayerStatus SittingOut (AllIn 500) GT
            ]
        ]


testComparison : String -> (a -> a -> Order) -> a -> a -> Order -> Html Msg
testComparison description compareFn a b expected =
    let
        actual = compareFn a b
        passed = actual == expected
        icon = if passed then "✓" else "✗"
        color = if passed then "green" else "red"
    in
    li [ style "color" color ]
        [ text (icon ++ " " ++ description ++ " → " ++ orderToString actual ++ 
                (if passed then "" else " (expected " ++ orderToString expected ++ ")"))
        ]


orderToString : Order -> String
orderToString order =
    case order of
        LT -> "LT"
        EQ -> "EQ"
        GT -> "GT"