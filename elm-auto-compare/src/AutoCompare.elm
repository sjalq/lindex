module AutoCompare exposing (compareThen)

{-| Helper functions for auto-generated comparison functions.

@docs compareThen

-}


{-| Chain comparison operations. If the first comparison is EQ, use the second comparison.
Otherwise, return the first comparison result.

This follows the same pattern as F#'s default comparison for records and DUs.

-}
compareThen : Order -> Order -> Order
compareThen second first =
    case first of
        EQ ->
            second

        _ ->
            first