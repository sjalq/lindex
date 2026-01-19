module Game.Poker exposing (..)

import Game.Cards exposing (Card, Rank, Suit)


{-| Texas Hold'em poker types.
-}


type HandRank
    = HighCard Card Card Card Card Card
    | Pair Rank Card Card Card
    | TwoPair Rank Rank Card
    | ThreeOfAKind Rank Card Card
    | Straight Rank
    | Flush Suit Card Card Card Card Card
    | FullHouse Rank Rank
    | FourOfAKind Rank Card
    | StraightFlush Rank Suit
    | RoyalFlush Suit


type alias Player =
    { name : String
    , holeCards : ( Card, Card )
    , chips : Int
    , position : Position
    , status : PlayerStatus
    }


type Position
    = Button
    | SmallBlind
    | BigBlind
    | UnderTheGun
    | MiddlePosition Int
    | CutOff


type PlayerStatus
    = Active
    | Folded
    | AllIn Int
    | SittingOut