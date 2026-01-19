module Generated.Simple.ColorCompare exposing (compareColor)

import Simple exposing (Color(..))


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

        ( Green, Green ) ->
            EQ

        ( Green, Red ) ->
            GT

        ( Green, Blue ) ->
            LT

        ( Green, RGB _ _ _ ) ->
            LT

        ( Blue, Blue ) ->
            EQ

        ( Blue, Red ) ->
            GT

        ( Blue, Green ) ->
            GT

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


compareThen : Order -> Order -> Order
compareThen second first =
    case first of
        EQ ->
            second

        _ ->
            first