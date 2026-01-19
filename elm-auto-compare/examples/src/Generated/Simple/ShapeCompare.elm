module Generated.Simple.ShapeCompare exposing (compareShape)

import Simple exposing (Shape(..))


compareShape : Shape -> Shape -> Order
compareShape a b =
    case ( a, b ) of
        ( Circle a0, Circle b0 ) ->
            compare a0 b0

        ( Circle _, Rectangle _ _ ) ->
            LT

        ( Circle _, Triangle _ _ _ ) ->
            LT

        ( Rectangle a0 a1, Rectangle b0 b1 ) ->
            compare a0 b0
                |> compareThen (compare a1 b1)

        ( Rectangle _ _, Circle _ ) ->
            GT

        ( Rectangle _ _, Triangle _ _ _ ) ->
            LT

        ( Triangle a0 a1 a2, Triangle b0 b1 b2 ) ->
            compare a0 b0
                |> compareThen (compare a1 b1)
                |> compareThen (compare a2 b2)

        ( Triangle _ _ _, Circle _ ) ->
            GT

        ( Triangle _ _ _, Rectangle _ _ ) ->
            GT


compareThen : Order -> Order -> Order
compareThen second first =
    case first of
        EQ ->
            second

        _ ->
            first