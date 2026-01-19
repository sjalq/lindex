module Generated.Game.Cards.RankCompare exposing (compareRank)

import Game.Cards exposing (Rank(..))


compareRank : Rank -> Rank -> Order
compareRank a b =
    case ( a, b ) of
        ( Two, Two ) ->
            EQ

        ( Two, Three ) ->
            LT

        ( Two, Four ) ->
            LT

        ( Two, Five ) ->
            LT

        ( Two, Six ) ->
            LT

        ( Two, Seven ) ->
            LT

        ( Two, Eight ) ->
            LT

        ( Two, Nine ) ->
            LT

        ( Two, Ten ) ->
            LT

        ( Two, Jack ) ->
            LT

        ( Two, Queen ) ->
            LT

        ( Two, King ) ->
            LT

        ( Two, Ace ) ->
            LT

        ( Three, Three ) ->
            EQ

        ( Three, Two ) ->
            GT

        ( Three, Four ) ->
            LT

        ( Three, Five ) ->
            LT

        ( Three, Six ) ->
            LT

        ( Three, Seven ) ->
            LT

        ( Three, Eight ) ->
            LT

        ( Three, Nine ) ->
            LT

        ( Three, Ten ) ->
            LT

        ( Three, Jack ) ->
            LT

        ( Three, Queen ) ->
            LT

        ( Three, King ) ->
            LT

        ( Three, Ace ) ->
            LT

        ( Four, Four ) ->
            EQ

        ( Four, Two ) ->
            GT

        ( Four, Three ) ->
            GT

        ( Four, Five ) ->
            LT

        ( Four, Six ) ->
            LT

        ( Four, Seven ) ->
            LT

        ( Four, Eight ) ->
            LT

        ( Four, Nine ) ->
            LT

        ( Four, Ten ) ->
            LT

        ( Four, Jack ) ->
            LT

        ( Four, Queen ) ->
            LT

        ( Four, King ) ->
            LT

        ( Four, Ace ) ->
            LT

        ( Five, Five ) ->
            EQ

        ( Five, Two ) ->
            GT

        ( Five, Three ) ->
            GT

        ( Five, Four ) ->
            GT

        ( Five, Six ) ->
            LT

        ( Five, Seven ) ->
            LT

        ( Five, Eight ) ->
            LT

        ( Five, Nine ) ->
            LT

        ( Five, Ten ) ->
            LT

        ( Five, Jack ) ->
            LT

        ( Five, Queen ) ->
            LT

        ( Five, King ) ->
            LT

        ( Five, Ace ) ->
            LT

        ( Six, Six ) ->
            EQ

        ( Six, Two ) ->
            GT

        ( Six, Three ) ->
            GT

        ( Six, Four ) ->
            GT

        ( Six, Five ) ->
            GT

        ( Six, Seven ) ->
            LT

        ( Six, Eight ) ->
            LT

        ( Six, Nine ) ->
            LT

        ( Six, Ten ) ->
            LT

        ( Six, Jack ) ->
            LT

        ( Six, Queen ) ->
            LT

        ( Six, King ) ->
            LT

        ( Six, Ace ) ->
            LT

        ( Seven, Seven ) ->
            EQ

        ( Seven, Two ) ->
            GT

        ( Seven, Three ) ->
            GT

        ( Seven, Four ) ->
            GT

        ( Seven, Five ) ->
            GT

        ( Seven, Six ) ->
            GT

        ( Seven, Eight ) ->
            LT

        ( Seven, Nine ) ->
            LT

        ( Seven, Ten ) ->
            LT

        ( Seven, Jack ) ->
            LT

        ( Seven, Queen ) ->
            LT

        ( Seven, King ) ->
            LT

        ( Seven, Ace ) ->
            LT

        ( Eight, Eight ) ->
            EQ

        ( Eight, Two ) ->
            GT

        ( Eight, Three ) ->
            GT

        ( Eight, Four ) ->
            GT

        ( Eight, Five ) ->
            GT

        ( Eight, Six ) ->
            GT

        ( Eight, Seven ) ->
            GT

        ( Eight, Nine ) ->
            LT

        ( Eight, Ten ) ->
            LT

        ( Eight, Jack ) ->
            LT

        ( Eight, Queen ) ->
            LT

        ( Eight, King ) ->
            LT

        ( Eight, Ace ) ->
            LT

        ( Nine, Nine ) ->
            EQ

        ( Nine, Two ) ->
            GT

        ( Nine, Three ) ->
            GT

        ( Nine, Four ) ->
            GT

        ( Nine, Five ) ->
            GT

        ( Nine, Six ) ->
            GT

        ( Nine, Seven ) ->
            GT

        ( Nine, Eight ) ->
            GT

        ( Nine, Ten ) ->
            LT

        ( Nine, Jack ) ->
            LT

        ( Nine, Queen ) ->
            LT

        ( Nine, King ) ->
            LT

        ( Nine, Ace ) ->
            LT

        ( Ten, Ten ) ->
            EQ

        ( Ten, Two ) ->
            GT

        ( Ten, Three ) ->
            GT

        ( Ten, Four ) ->
            GT

        ( Ten, Five ) ->
            GT

        ( Ten, Six ) ->
            GT

        ( Ten, Seven ) ->
            GT

        ( Ten, Eight ) ->
            GT

        ( Ten, Nine ) ->
            GT

        ( Ten, Jack ) ->
            LT

        ( Ten, Queen ) ->
            LT

        ( Ten, King ) ->
            LT

        ( Ten, Ace ) ->
            LT

        ( Jack, Jack ) ->
            EQ

        ( Jack, Two ) ->
            GT

        ( Jack, Three ) ->
            GT

        ( Jack, Four ) ->
            GT

        ( Jack, Five ) ->
            GT

        ( Jack, Six ) ->
            GT

        ( Jack, Seven ) ->
            GT

        ( Jack, Eight ) ->
            GT

        ( Jack, Nine ) ->
            GT

        ( Jack, Ten ) ->
            GT

        ( Jack, Queen ) ->
            LT

        ( Jack, King ) ->
            LT

        ( Jack, Ace ) ->
            LT

        ( Queen, Queen ) ->
            EQ

        ( Queen, Two ) ->
            GT

        ( Queen, Three ) ->
            GT

        ( Queen, Four ) ->
            GT

        ( Queen, Five ) ->
            GT

        ( Queen, Six ) ->
            GT

        ( Queen, Seven ) ->
            GT

        ( Queen, Eight ) ->
            GT

        ( Queen, Nine ) ->
            GT

        ( Queen, Ten ) ->
            GT

        ( Queen, Jack ) ->
            GT

        ( Queen, King ) ->
            LT

        ( Queen, Ace ) ->
            LT

        ( King, King ) ->
            EQ

        ( King, Two ) ->
            GT

        ( King, Three ) ->
            GT

        ( King, Four ) ->
            GT

        ( King, Five ) ->
            GT

        ( King, Six ) ->
            GT

        ( King, Seven ) ->
            GT

        ( King, Eight ) ->
            GT

        ( King, Nine ) ->
            GT

        ( King, Ten ) ->
            GT

        ( King, Jack ) ->
            GT

        ( King, Queen ) ->
            GT

        ( King, Ace ) ->
            LT

        ( Ace, Ace ) ->
            EQ

        ( Ace, Two ) ->
            GT

        ( Ace, Three ) ->
            GT

        ( Ace, Four ) ->
            GT

        ( Ace, Five ) ->
            GT

        ( Ace, Six ) ->
            GT

        ( Ace, Seven ) ->
            GT

        ( Ace, Eight ) ->
            GT

        ( Ace, Nine ) ->
            GT

        ( Ace, Ten ) ->
            GT

        ( Ace, Jack ) ->
            GT

        ( Ace, Queen ) ->
            GT

        ( Ace, King ) ->
            GT