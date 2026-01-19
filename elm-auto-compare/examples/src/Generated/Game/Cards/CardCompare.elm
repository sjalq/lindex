module Generated.Game.Cards.CardCompare exposing (compareCard)

import Game.Cards exposing (Card)
import Generated.Game.Cards.RankCompare exposing (compareRank)
import Generated.Game.Cards.SuitCompare exposing (compareSuit)


compareCard : Card -> Card -> Order
compareCard a b =
    compareRank a.rank b.rank
        |> compareThen (compareSuit a.suit b.suit)


compareThen : Order -> Order -> Order
compareThen second first =
    case first of
        EQ ->
            second

        _ ->
            first