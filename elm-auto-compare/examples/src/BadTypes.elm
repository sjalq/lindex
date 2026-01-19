module BadTypes exposing (..)

-- These types should fail to generate valid comparison functions

type WithFunction
    = HasFunction (Int -> String)
    | JustInt Int

type WithTypeVar a
    = Something a
    | Nothing

type WithTask
    = Loading
    | Loaded (Task Http.Error String)

type NestedBad
    = Good String
    | Bad WithFunction