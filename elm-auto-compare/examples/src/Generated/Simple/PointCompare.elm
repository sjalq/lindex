module Generated.Simple.PointCompare exposing (comparePoint)

import Simple exposing (Point)


comparePoint : Point -> Point -> Order
comparePoint a b =
    compare a.x b.x
        |> compareThen (compare a.y b.y)


compareThen : Order -> Order -> Order
compareThen second first =
    case first of
        EQ ->
            second

        _ ->
            first