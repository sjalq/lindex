module GenerateComparisons exposing (run)

import BackendTask exposing (BackendTask)
import BackendTask.File as File
import BackendTask.Glob as Glob
import Cli.Option as Option
import Cli.OptionsParser as OptionsParser
import Cli.Program as Program
import Elm.Parser
import Elm.Processing
import Elm.Syntax.Declaration as Declaration
import Elm.Syntax.File exposing (File)
import Elm.Syntax.Module as Module
import Elm.Syntax.Node as Node exposing (Node)
import Elm.Syntax.Range exposing (Range)
import Elm.Syntax.Type exposing (Type)
import Elm.Syntax.TypeAnnotation as TypeAnnotation
import FatalError exposing (FatalError)
import Json.Decode as Decode
import Pages.Script as Script exposing (Script)
import String.Extra


type alias CliOptions =
    { moduleName : String
    , typeName : String
    , outputDir : String
    }


run : Script
run =
    Script.withCliOptions program
        (\options ->
            generateComparison options
                |> BackendTask.allowFatal
        )


program : Program.Config CliOptions
program =
    Program.config
        |> Program.add
            (OptionsParser.build CliOptions
                |> OptionsParser.with
                    (Option.requiredKeywordArg "module"
                        |> Option.withDoc "Module name (e.g., Game.Cards)"
                    )
                |> OptionsParser.with
                    (Option.requiredKeywordArg "type"
                        |> Option.withDoc "Type name to generate comparison for (e.g., Card)"
                    )
                |> OptionsParser.with
                    (Option.optionalKeywordArg "output"
                        |> Option.withDefault "src/Generated"
                        |> Option.withDoc "Output directory for generated files"
                    )
            )


generateComparison : CliOptions -> BackendTask FatalError ()
generateComparison options =
    let
        modulePath =
            String.replace "." "/" options.moduleName ++ ".elm"
        
        sourceFile =
            "src/" ++ modulePath
    in
    File.rawFile sourceFile
        |> BackendTask.mapError (\_ -> FatalError.fromString ("Could not read file: " ++ sourceFile))
        |> BackendTask.andThen
            (\content ->
                case Elm.Parser.parse content of
                    Err _ ->
                        BackendTask.fail (FatalError.fromString "Failed to parse Elm file")
                    
                    Ok rawFile ->
                        let
                            file =
                                Elm.Processing.process Elm.Processing.init rawFile
                        in
                        case findType options.typeName file of
                            Nothing ->
                                BackendTask.fail (FatalError.fromString ("Type " ++ options.typeName ++ " not found in module"))
                            
                            Just typeInfo ->
                                generateAndWriteComparison options typeInfo
            )


type TypeInfo
    = CustomType String (List VariantInfo)
    | RecordAlias String (List String)


type alias VariantInfo =
    { name : String
    , arguments : List (Node TypeAnnotation.TypeAnnotation)
    }

{-| Edge Cases to Handle:

1. **Types that reference other modules**: 
   - Currently we generate `compare` which won't work for custom types
   - Need to detect and generate appropriate comparison functions

2. **Malformed types**: 
   - Elm.Parser will fail and we return an error

3. **File doesn't compile but types are OK**:
   - We only parse, don't compile, so this should work
   - But generated code might not compile if dependencies are missing
-}


findType : String -> File -> Maybe TypeInfo
findType typeName file =
    file.declarations
        |> List.filterMap
            (\node ->
                case Node.value node of
                    Declaration.CustomTypeDeclaration customType ->
                        if Node.value customType.name == typeName then
                            Just (CustomType typeName (extractVariants customType))
                        else
                            Nothing
                    
                    Declaration.AliasDeclaration typeAlias ->
                        if Node.value typeAlias.name == typeName then
                            case Node.value typeAlias.typeAnnotation of
                                TypeAnnotation.Record fields ->
                                    Just (RecordAlias typeName (extractFieldNames fields))
                                
                                _ ->
                                    Nothing
                        else
                            Nothing
                    
                    _ ->
                        Nothing
            )
        |> List.head


extractVariants : Type -> List VariantInfo
extractVariants customType =
    customType.constructors
        -- Sort by source position to preserve declaration order
        |> List.sortBy
            (\constructor ->
                let
                    range = Node.range constructor
                in
                ( range.start.row, range.start.column )
            )
        |> List.map
            (\node ->
                let
                    constructor = Node.value node
                    -- Check if all arguments are comparable
                    nonComparableArgs = 
                        constructor.arguments
                            |> List.filterMap (\arg ->
                                if not (isComparable (Node.value arg)) then
                                    Just (Node.value constructor.name, typeAnnotationToString (Node.value arg))
                                else
                                    Nothing
                            )
                in
                { name = Node.value constructor.name
                , arguments = constructor.arguments
                }
            )


extractFieldNames : List (Node TypeAnnotation.RecordField) -> List String
extractFieldNames fields =
    fields
        |> List.map
            (\field ->
                case Node.value field of
                    ( nameNode, _ ) ->
                        Node.value nameNode
            )


getCompareFunction : TypeAnnotation.TypeAnnotation -> String
getCompareFunction typeAnnotation =
    if not (isComparable typeAnnotation) then
        "-- ERROR: Cannot compare " ++ typeAnnotationToString typeAnnotation
    else
        case typeAnnotation of
            TypeAnnotation.Typed node _ ->
                let
                    (moduleName, typeName) = Node.value node
                in
                -- Check if it's a custom type (starts with uppercase)
                case typeName of
                    [] ->
                        "compare"
                    
                    name :: _ ->
                        if String.left 1 name == String.toUpper (String.left 1 name) then
                            -- Custom type - generate compare function name
                            "compare" ++ name
                        else
                            "compare"
            
            _ ->
                -- For all other types, use default compare
                "compare"


isComparable : TypeAnnotation.TypeAnnotation -> Bool
isComparable typeAnnotation =
    case typeAnnotation of
        TypeAnnotation.FunctionTypeAnnotation _ _ ->
            False  -- Functions are never comparable
        
        TypeAnnotation.Unit ->
            True
        
        TypeAnnotation.Tupled nodes ->
            List.all (Node.value >> isComparable) nodes
        
        TypeAnnotation.Record fields ->
            List.all (\field ->
                case Node.value field of
                    (_, fieldType) -> Node.value fieldType |> isComparable
            ) fields
        
        TypeAnnotation.GenericRecord _ fields ->
            Node.value fields
                |> List.all (\field ->
                    case Node.value field of
                        (_, fieldType) -> Node.value fieldType |> isComparable
                )
        
        TypeAnnotation.Typed node args ->
            let
                (moduleName, typeName) = Node.value node
            in
            case (moduleName, typeName) of
                ([], ["Int"]) -> True
                ([], ["Float"]) -> True
                ([], ["String"]) -> True
                ([], ["Char"]) -> True
                ([], ["Bool"]) -> True
                ([], ["List"]) -> List.all (Node.value >> isComparable) args
                ([], ["Array"]) -> List.all (Node.value >> isComparable) args
                ([], ["Set"]) -> List.all (Node.value >> isComparable) args
                ([], ["Dict"]) -> List.all (Node.value >> isComparable) args
                ([], ["Maybe"]) -> List.all (Node.value >> isComparable) args
                ([], ["Result"]) -> List.all (Node.value >> isComparable) args
                -- Non-comparable types
                ([], ["Task"]) -> False
                ([], ["Cmd"]) -> False
                ([], ["Sub"]) -> False
                ([], ["Program"]) -> False
                -- For custom types, we assume they might be comparable
                -- (user needs to ensure this)
                _ -> True
        
        TypeAnnotation.GenericType _ ->
            -- Type variables - we can't know if they're comparable
            False


typeAnnotationToString : TypeAnnotation.TypeAnnotation -> String
typeAnnotationToString typeAnnotation =
    case typeAnnotation of
        TypeAnnotation.FunctionTypeAnnotation _ _ ->
            "function type"
        TypeAnnotation.GenericType name ->
            "type variable '" ++ name ++ "'"
        _ ->
            "non-comparable type"


generateAndWriteComparison : CliOptions -> TypeInfo -> BackendTask FatalError ()
generateAndWriteComparison options typeInfo =
    let
        generatedCode =
            case typeInfo of
                CustomType name variants ->
                    generateCustomTypeComparison options.moduleName name variants
                
                RecordAlias name fields ->
                    generateRecordComparison options.moduleName name fields
        
        outputPath =
            options.outputDir 
                ++ "/" 
                ++ String.replace "." "/" options.moduleName 
                ++ "/" 
                ++ options.typeName 
                ++ "Compare.elm"
    in
    File.write outputPath generatedCode
        |> BackendTask.mapError (\_ -> FatalError.fromString ("Failed to write file: " ++ outputPath))


generateCustomTypeComparison : String -> String -> List VariantInfo -> String
generateCustomTypeComparison moduleName typeName variants =
    let
        functionName =
            "compare" ++ typeName
        
        patterns =
            variants
                |> List.indexedMap (generatePattern variants)
                |> List.concat
                |> String.join "\n\n"
        
        needsCompareThen =
            List.any (\v -> List.length v.arguments > 1) variants
        
        compareThenHelper =
            if needsCompareThen then
                "\n\n\ncompareThen : Order -> Order -> Order\ncompareThen second first =\n    case first of\n        EQ ->\n            second\n\n        _ ->\n            first"
            else
                ""
    in
    """module Generated.""" ++ moduleName ++ """.""" ++ typeName ++ """Compare exposing (""" ++ functionName ++ """)

import """ ++ moduleName ++ """ exposing (""" ++ typeName ++ """(..))


""" ++ functionName ++ """ : """ ++ typeName ++ """ -> """ ++ typeName ++ """ -> Order
""" ++ functionName ++ """ a b =
    case ( a, b ) of
""" ++ patterns ++ compareThenHelper


generatePattern : List VariantInfo -> Int -> VariantInfo -> List String
generatePattern allVariants index variant =
    let
        sameConstructorPattern =
            if List.isEmpty variant.arguments then
                "        ( " ++ variant.name ++ ", " ++ variant.name ++ " ) ->\n            EQ"
            
            else
                let
                    args1 =
                        List.indexedMap (\i _ -> "a" ++ String.fromInt i) variant.arguments
                    
                    args2 =
                        List.indexedMap (\i _ -> "b" ++ String.fromInt i) variant.arguments
                    
                    pattern1 =
                        variant.name ++ " " ++ String.join " " args1
                    
                    pattern2 =
                        variant.name ++ " " ++ String.join " " args2
                    
                    comparisons =
                        List.indexedMap
                            (\i argNode ->
                                let
                                    compareFunc = getCompareFunction (Node.value argNode)
                                    comparison = compareFunc ++ " a" ++ String.fromInt i ++ " b" ++ String.fromInt i
                                in
                                if i == 0 then
                                    comparison
                                
                                else
                                    "                |> compareThen (" ++ comparison ++ ")"
                            )
                            variant.arguments
                            |> String.join "\n"
                in
                "        ( " ++ pattern1 ++ ", " ++ pattern2 ++ " ) ->\n            " ++ comparisons
        
        differentConstructorPatterns =
            allVariants
                |> List.indexedMap
                    (\otherIndex otherVariant ->
                        if otherIndex < index then
                            let
                                args1 = if List.isEmpty variant.arguments then "" else " _"
                                args2 = if List.isEmpty otherVariant.arguments then "" else " _"
                            in
                            Just ("        ( " ++ variant.name ++ args1 ++ ", " ++ otherVariant.name ++ args2 ++ " ) ->\n            GT")
                        
                        else if otherIndex > index then
                            let
                                args1 = if List.isEmpty variant.arguments then "" else " _"
                                args2 = if List.isEmpty otherVariant.arguments then "" else " _"
                            in
                            Just ("        ( " ++ variant.name ++ args1 ++ ", " ++ otherVariant.name ++ args2 ++ " ) ->\n            LT")
                        
                        else
                            Nothing
                    )
                |> List.filterMap identity
    in
    sameConstructorPattern :: differentConstructorPatterns


generateRecordComparison : String -> String -> List String -> String
generateRecordComparison moduleName typeName fields =
    let
        functionName =
            "compare" ++ typeName
        
        comparisons =
            fields
                |> List.indexedMap
                    (\i field ->
                        if i == 0 then
                            "compare a." ++ field ++ " b." ++ field
                        
                        else
                            "        |> compareThen (compare a." ++ field ++ " b." ++ field ++ ")"
                    )
                |> String.join "\n"
        
        needsCompareThen =
            List.length fields > 1
        
        compareThenHelper =
            if needsCompareThen then
                "\n\n\ncompareThen : Order -> Order -> Order\ncompareThen second first =\n    case first of\n        EQ ->\n            second\n\n        _ ->\n            first"
            else
                ""
    in
    """module Generated.""" ++ moduleName ++ """.""" ++ typeName ++ """Compare exposing (""" ++ functionName ++ """)

import """ ++ moduleName ++ """ exposing (""" ++ typeName ++ """)


""" ++ functionName ++ """ : """ ++ typeName ++ """ -> """ ++ typeName ++ """ -> Order
""" ++ functionName ++ """ a b =
    """ ++ comparisons ++ compareThenHelper