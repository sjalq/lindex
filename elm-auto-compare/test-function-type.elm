module TestFunctionType exposing (..)

-- This will break our comparison generator!
type Stuff a b c
    = A (a -> b)  -- Function type - NOT comparable!
    | B c         -- Type variable - might be comparable

-- Also problematic:
type Problem
    = HasFunction (Int -> String)
    | HasRecord { x : Int, y : Int }
    | HasList (List Int)
    | HasDict (Dict String Int)
    | HasTask (Task Http.Error String)