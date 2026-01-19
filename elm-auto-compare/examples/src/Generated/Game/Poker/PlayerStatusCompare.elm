module Generated.Game.Poker.PlayerStatusCompare exposing (comparePlayerStatus)

import Game.Poker exposing (PlayerStatus(..))


comparePlayerStatus : PlayerStatus -> PlayerStatus -> Order
comparePlayerStatus a b =
    case ( a, b ) of
        ( Active, Active ) ->
            EQ

        ( Active, Folded ) ->
            LT

        ( Active, AllIn _ ) ->
            LT

        ( Active, SittingOut ) ->
            LT

        ( Folded, Folded ) ->
            EQ

        ( Folded, Active ) ->
            GT

        ( Folded, AllIn _ ) ->
            LT

        ( Folded, SittingOut ) ->
            LT

        ( AllIn a0, AllIn b0 ) ->
            compare a0 b0

        ( AllIn _, Active ) ->
            GT

        ( AllIn _, Folded ) ->
            GT

        ( AllIn _, SittingOut ) ->
            LT

        ( SittingOut, SittingOut ) ->
            EQ

        ( SittingOut, Active ) ->
            GT

        ( SittingOut, Folded ) ->
            GT

        ( SittingOut, AllIn _ ) ->
            GT