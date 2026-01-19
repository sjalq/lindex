module Generated.Game.Cards.SuitCompare exposing (compareSuit)

import Game.Cards exposing (Suit(..))


compareSuit : Suit -> Suit -> Order
compareSuit a b =
    case ( a, b ) of
        ( Clubs, Clubs ) ->
            EQ

        ( Clubs, Diamonds ) ->
            LT

        ( Clubs, Hearts ) ->
            LT

        ( Clubs, Spades ) ->
            LT

        ( Diamonds, Diamonds ) ->
            EQ

        ( Diamonds, Clubs ) ->
            GT

        ( Diamonds, Hearts ) ->
            LT

        ( Diamonds, Spades ) ->
            LT

        ( Hearts, Hearts ) ->
            EQ

        ( Hearts, Clubs ) ->
            GT

        ( Hearts, Diamonds ) ->
            GT

        ( Hearts, Spades ) ->
            LT

        ( Spades, Spades ) ->
            EQ

        ( Spades, Clubs ) ->
            GT

        ( Spades, Diamonds ) ->
            GT

        ( Spades, Hearts ) ->
            GT