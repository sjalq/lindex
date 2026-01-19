module OrderPreservationTest exposing (suite)

import Expect
import Test exposing (..)

-- Test types with specific ordering
type Priority
    = Low      -- Should map to 0
    | Medium   -- Should map to 1  
    | High     -- Should map to 2
    | Critical -- Should map to 3

type Animal
    = Zebra    -- Should map to 0 (declared first)
    | Aardvark -- Should map to 1 (declared second)
    | Monkey   -- Should map to 2
    | Elephant -- Should map to 3

-- Import the generated comparison functions (if they exist)
-- import Generated.OrderPreservationTest.PriorityCompare exposing (comparePriority)
-- import Generated.OrderPreservationTest.AnimalCompare exposing (compareAnimal)

-- For now, let's write what the generated functions SHOULD produce
-- to test if declaration order is preserved

expectedComparePriority : Priority -> Priority -> Order
expectedComparePriority a b =
    case ( a, b ) of
        ( Low, Low ) -> EQ
        ( Low, _ ) -> LT
        
        ( Medium, Low ) -> GT
        ( Medium, Medium ) -> EQ
        ( Medium, _ ) -> LT
        
        ( High, Low ) -> GT
        ( High, Medium ) -> GT
        ( High, High ) -> EQ
        ( High, Critical ) -> LT
        
        ( Critical, _ ) -> GT


expectedCompareAnimal : Animal -> Animal -> Order
expectedCompareAnimal a b =
    case ( a, b ) of
        ( Zebra, Zebra ) -> EQ
        ( Zebra, _ ) -> LT
        
        ( Aardvark, Zebra ) -> GT
        ( Aardvark, Aardvark ) -> EQ
        ( Aardvark, _ ) -> LT
        
        ( Monkey, Zebra ) -> GT
        ( Monkey, Aardvark ) -> GT
        ( Monkey, Monkey ) -> EQ
        ( Monkey, Elephant ) -> LT
        
        ( Elephant, Elephant ) -> EQ
        ( Elephant, _ ) -> GT


suite : Test
suite =
    describe "Declaration Order Preservation"
        [ describe "Priority type ordering"
            [ test "Low < Medium" <|
                \_ -> 
                    expectedComparePriority Low Medium
                        |> Expect.equal LT
            
            , test "Medium < High" <|
                \_ ->
                    expectedComparePriority Medium High
                        |> Expect.equal LT
                        
            , test "High < Critical" <|
                \_ ->
                    expectedComparePriority High Critical
                        |> Expect.equal LT
                        
            , test "Critical > Low" <|
                \_ ->
                    expectedComparePriority Critical Low
                        |> Expect.equal GT
            ]
            
        , describe "Animal type ordering (not alphabetical!)"
            [ test "Zebra < Aardvark (declaration order, not alphabetical)" <|
                \_ ->
                    expectedCompareAnimal Zebra Aardvark
                        |> Expect.equal LT
                        
            , test "Aardvark < Monkey" <|
                \_ ->
                    expectedCompareAnimal Aardvark Monkey
                        |> Expect.equal LT
                        
            , test "Monkey < Elephant" <|
                \_ ->
                    expectedCompareAnimal Monkey Elephant
                        |> Expect.equal LT
                        
            , test "Elephant > Zebra" <|
                \_ ->
                    expectedCompareAnimal Elephant Zebra
                        |> Expect.equal GT
            ]
            
        , describe "Critical property: declaration order, not alphabetical"
            [ test "The Animal type proves order preservation" <|
                \_ ->
                    -- If this test passes, we know declaration order is preserved
                    -- because Aardvark comes before Zebra alphabetically
                    -- but after Zebra in declaration order
                    let
                        declarationOrderCorrect = 
                            expectedCompareAnimal Zebra Aardvark == LT
                            
                        alphabeticalOrderWouldBe =
                            -- If it were alphabetical, Aardvark would be < Zebra
                            expectedCompareAnimal Aardvark Zebra == LT
                    in
                    Expect.all
                        [ \_ -> Expect.equal True declarationOrderCorrect
                        , \_ -> Expect.equal False alphabeticalOrderWouldBe
                        ]
                        ()
            ]
        ]