module Generated.Simple.PersonCompare exposing (comparePerson)

import Simple exposing (Person)


comparePerson : Person -> Person -> Order
comparePerson a b =
    compare a.name b.name
        |> compareThen (compare a.age b.age)
        |> compareThen (compare a.height b.height)


compareThen : Order -> Order -> Order
compareThen second first =
    case first of
        EQ ->
            second

        _ ->
            first