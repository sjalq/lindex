module Game.Cards exposing (..)

{-| Card types for Texas Hold'em poker.
-}


type Suit
    = Clubs
    | Diamonds
    | Hearts
    | Spades


type Rank
    = Two
    | Three
    | Four
    | Five
    | Six
    | Seven
    | Eight
    | Nine
    | Ten
    | Jack
    | Queen
    | King
    | Ace


type alias Card =
    { rank : Rank
    , suit : Suit
    }