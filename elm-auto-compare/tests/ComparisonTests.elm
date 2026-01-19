module ComparisonTests exposing (suite)

import Expect
import Fuzz exposing (Fuzzer)
import Test exposing (..)

-- Import our types and generated comparison functions
import Simple exposing (..)
import Game.Cards exposing (..)
import Generated.Simple.ColorCompare exposing (compareColor)
import Generated.Simple.ShapeCompare exposing (compareShape)
import Generated.Simple.PointCompare exposing (comparePoint)
import Generated.Simple.PersonCompare exposing (comparePerson)
import Generated.Game.Cards.SuitCompare exposing (compareSuit)
import Generated.Game.Cards.RankCompare exposing (compareRank)
import Generated.Game.Cards.CardCompare exposing (compareCard)


suite : Test
suite =
    describe "Comparison Function Properties"
        [ describe "General comparison properties"
            [ reflexivityTests
            , antisymmetryTests
            , transitivityTests
            , totalityTests
            ]
        , describe "F# ordering rules"
            [ constructorOrderTests
            , recordFieldOrderTests
            ]
        ]


-- Property: Reflexivity - compare x x == EQ
reflexivityTests : Test
reflexivityTests =
    describe "Reflexivity: compare x x == EQ"
        [ fuzz colorFuzzer "Color reflexivity" <|
            \color ->
                compareColor color color
                    |> Expect.equal EQ
        
        , fuzz shapeFuzzer "Shape reflexivity" <|
            \shape ->
                compareShape shape shape
                    |> Expect.equal EQ
        
        , fuzz pointFuzzer "Point reflexivity" <|
            \point ->
                comparePoint point point
                    |> Expect.equal EQ
        
        , fuzz cardFuzzer "Card reflexivity" <|
            \card ->
                compareCard card card
                    |> Expect.equal EQ
        ]


-- Property: Antisymmetry - if compare x y == LT then compare y x == GT
antisymmetryTests : Test
antisymmetryTests =
    describe "Antisymmetry: if compare x y == LT then compare y x == GT"
        [ fuzz2 colorFuzzer colorFuzzer "Color antisymmetry" <|
            \c1 c2 ->
                case compareColor c1 c2 of
                    LT ->
                        compareColor c2 c1
                            |> Expect.equal GT
                    
                    GT ->
                        compareColor c2 c1
                            |> Expect.equal LT
                    
                    EQ ->
                        compareColor c2 c1
                            |> Expect.equal EQ
        
        , fuzz2 cardFuzzer cardFuzzer "Card antisymmetry" <|
            \card1 card2 ->
                case compareCard card1 card2 of
                    LT ->
                        compareCard card2 card1
                            |> Expect.equal GT
                    
                    GT ->
                        compareCard card2 card1
                            |> Expect.equal LT
                    
                    EQ ->
                        compareCard card2 card1
                            |> Expect.equal EQ
        ]


-- Property: Transitivity - if x < y and y < z then x < z
transitivityTests : Test
transitivityTests =
    describe "Transitivity: if x < y and y < z then x < z"
        [ test "Suit transitivity: Clubs < Diamonds < Hearts" <|
            \_ ->
                let
                    clubsDiamonds = compareSuit Clubs Diamonds
                    diamondsHearts = compareSuit Diamonds Hearts
                    clubsHearts = compareSuit Clubs Hearts
                in
                Expect.all
                    [ \_ -> Expect.equal LT clubsDiamonds
                    , \_ -> Expect.equal LT diamondsHearts
                    , \_ -> Expect.equal LT clubsHearts
                    ]
                    ()
        
        , test "Rank transitivity: Two < Three < Four" <|
            \_ ->
                let
                    twoThree = compareRank Two Three
                    threeFour = compareRank Three Four
                    twoFour = compareRank Two Four
                in
                Expect.all
                    [ \_ -> Expect.equal LT twoThree
                    , \_ -> Expect.equal LT threeFour
                    , \_ -> Expect.equal LT twoFour
                    ]
                    ()
        ]


-- Property: Totality - for any x and y, exactly one of x < y, x == y, or x > y holds
totalityTests : Test
totalityTests =
    describe "Totality: exactly one of LT, EQ, GT"
        [ fuzz2 colorFuzzer colorFuzzer "Color totality" <|
            \c1 c2 ->
                compareColor c1 c2
                    |> (\order ->
                        case order of
                            LT -> Expect.pass
                            EQ -> Expect.pass
                            GT -> Expect.pass
                       )
        ]


-- F# Rule: Constructors are ordered by declaration position
constructorOrderTests : Test
constructorOrderTests =
    describe "Constructor order matches declaration order"
        [ test "Color: Red < Green < Blue < RGB" <|
            \_ ->
                Expect.all
                    [ \_ -> compareColor Red Green |> Expect.equal LT
                    , \_ -> compareColor Green Blue |> Expect.equal LT
                    , \_ -> compareColor Blue (RGB 0 0 0) |> Expect.equal LT
                    ]
                    ()
        
        , test "Suit: Clubs < Diamonds < Hearts < Spades" <|
            \_ ->
                Expect.all
                    [ \_ -> compareSuit Clubs Diamonds |> Expect.equal LT
                    , \_ -> compareSuit Diamonds Hearts |> Expect.equal LT
                    , \_ -> compareSuit Hearts Spades |> Expect.equal LT
                    ]
                    ()
        ]


-- F# Rule: Record fields are compared in declaration order
recordFieldOrderTests : Test
recordFieldOrderTests =
    describe "Record fields compared in declaration order"
        [ test "Person: name compared before age" <|
            \_ ->
                let
                    alice25 = { name = "Alice", age = 25, height = 5.5 }
                    alice30 = { name = "Alice", age = 30, height = 5.5 }
                    bob20 = { name = "Bob", age = 20, height = 5.5 }
                in
                Expect.all
                    [ \_ -> 
                        -- Same name, different age
                        comparePerson alice25 alice30 |> Expect.equal LT
                    , \_ -> 
                        -- Different name, age ignored
                        comparePerson alice30 bob20 |> Expect.equal LT
                    ]
                    ()
        
        , test "Card: rank compared before suit" <|
            \_ ->
                let
                    twoClubs = { rank = Two, suit = Clubs }
                    twoSpades = { rank = Two, suit = Spades }
                    aceClubs = { rank = Ace, suit = Clubs }
                in
                Expect.all
                    [ \_ -> 
                        -- Same rank, different suit
                        compareCard twoClubs twoSpades |> Expect.equal LT
                    , \_ -> 
                        -- Different rank, suit ignored
                        compareCard aceClubs twoSpades |> Expect.equal GT
                    ]
                    ()
        ]


-- Fuzzers for property-based testing
colorFuzzer : Fuzzer Color
colorFuzzer =
    Fuzz.oneOf
        [ Fuzz.constant Red
        , Fuzz.constant Green
        , Fuzz.constant Blue
        , Fuzz.map3 RGB 
            (Fuzz.intRange 0 255)
            (Fuzz.intRange 0 255)
            (Fuzz.intRange 0 255)
        ]


shapeFuzzer : Fuzzer Shape
shapeFuzzer =
    Fuzz.oneOf
        [ Fuzz.map Circle (Fuzz.floatRange 0 100)
        , Fuzz.map2 Rectangle 
            (Fuzz.floatRange 0 100)
            (Fuzz.floatRange 0 100)
        , Fuzz.map3 Triangle
            (Fuzz.floatRange 0 100)
            (Fuzz.floatRange 0 100)
            (Fuzz.floatRange 0 100)
        ]


pointFuzzer : Fuzzer Point
pointFuzzer =
    Fuzz.map2 Point
        (Fuzz.floatRange -100 100)
        (Fuzz.floatRange -100 100)


suitFuzzer : Fuzzer Suit
suitFuzzer =
    Fuzz.oneOf
        [ Fuzz.constant Clubs
        , Fuzz.constant Diamonds
        , Fuzz.constant Hearts
        , Fuzz.constant Spades
        ]


rankFuzzer : Fuzzer Rank
rankFuzzer =
    Fuzz.oneOf
        [ Fuzz.constant Two
        , Fuzz.constant Three
        , Fuzz.constant Four
        , Fuzz.constant Five
        , Fuzz.constant Six
        , Fuzz.constant Seven
        , Fuzz.constant Eight
        , Fuzz.constant Nine
        , Fuzz.constant Ten
        , Fuzz.constant Jack
        , Fuzz.constant Queen
        , Fuzz.constant King
        , Fuzz.constant Ace
        ]


cardFuzzer : Fuzzer Card
cardFuzzer =
    Fuzz.map2 Card
        rankFuzzer
        suitFuzzer