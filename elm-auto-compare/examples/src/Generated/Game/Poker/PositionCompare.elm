module Generated.Game.Poker.PositionCompare exposing (comparePosition)

import Game.Poker exposing (Position(..))


comparePosition : Position -> Position -> Order
comparePosition a b =
    case ( a, b ) of
        ( Button, Button ) ->
            EQ

        ( Button, SmallBlind ) ->
            LT

        ( Button, BigBlind ) ->
            LT

        ( Button, UnderTheGun ) ->
            LT

        ( Button, MiddlePosition _ ) ->
            LT

        ( Button, CutOff ) ->
            LT

        ( SmallBlind, SmallBlind ) ->
            EQ

        ( SmallBlind, Button ) ->
            GT

        ( SmallBlind, BigBlind ) ->
            LT

        ( SmallBlind, UnderTheGun ) ->
            LT

        ( SmallBlind, MiddlePosition _ ) ->
            LT

        ( SmallBlind, CutOff ) ->
            LT

        ( BigBlind, BigBlind ) ->
            EQ

        ( BigBlind, Button ) ->
            GT

        ( BigBlind, SmallBlind ) ->
            GT

        ( BigBlind, UnderTheGun ) ->
            LT

        ( BigBlind, MiddlePosition _ ) ->
            LT

        ( BigBlind, CutOff ) ->
            LT

        ( UnderTheGun, UnderTheGun ) ->
            EQ

        ( UnderTheGun, Button ) ->
            GT

        ( UnderTheGun, SmallBlind ) ->
            GT

        ( UnderTheGun, BigBlind ) ->
            GT

        ( UnderTheGun, MiddlePosition _ ) ->
            LT

        ( UnderTheGun, CutOff ) ->
            LT

        ( MiddlePosition a0, MiddlePosition b0 ) ->
            compare a0 b0

        ( MiddlePosition _, Button ) ->
            GT

        ( MiddlePosition _, SmallBlind ) ->
            GT

        ( MiddlePosition _, BigBlind ) ->
            GT

        ( MiddlePosition _, UnderTheGun ) ->
            GT

        ( MiddlePosition _, CutOff ) ->
            LT

        ( CutOff, CutOff ) ->
            EQ

        ( CutOff, Button ) ->
            GT

        ( CutOff, SmallBlind ) ->
            GT

        ( CutOff, BigBlind ) ->
            GT

        ( CutOff, UnderTheGun ) ->
            GT

        ( CutOff, MiddlePosition _ ) ->
            GT