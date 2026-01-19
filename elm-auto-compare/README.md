# elm-auto-compare

A CLI tool that generates comparison functions for Elm types following F#'s default sorting rules. Built with elm-pages scripts for pure Elm code generation.

## Quick Start

```bash
# Run directly with npx (no installation needed)
npx elm-auto-compare --module Game.Cards --type Card

# Generate comparison for a type with custom output directory
npx elm-auto-compare --module MyModule --type MyType --output src/Compare

# Get help
npx elm-auto-compare --help
```

## Installation

```bash
# Install globally
npm install -g elm-auto-compare

# Or as a dev dependency
npm install --save-dev elm-auto-compare
```

## Usage

The tool generates comparison functions by analyzing your Elm source code:

```bash
elm-auto-compare --module Game.Cards --type Suit
```

This will:
1. Read `src/Game/Cards.elm`
2. Find the `Suit` type definition
3. Generate `src/Generated/Game/Cards/SuitCompare.elm` with a `compareSuit` function

## Features

- Automatically generates `compare` functions for specified types
- Follows F#'s default comparison rules:
  - **For Custom Types (DUs)**: Compares by constructor order (as defined in type), then constructor arguments left-to-right
  - **For Records**: Compares fields in declaration order
- Generated code is placed in a separate `Generated/` directory to keep it segregated from user code
- Supports complex nested types and multiple arguments

## F# Sorting Rules Implementation

This library implements F#'s default structural comparison behavior:

1. **Discriminated Unions (Custom Types)**:
   - Constructors are ordered by their declaration position (first declared = smallest)
   - When constructors match, arguments are compared left-to-right
   - The first non-equal comparison determines the result

2. **Records**:
   - Fields are compared in declaration order
   - The first non-equal field comparison determines the result
   - All fields must be comparable

3. **Comparison Chain**:
   - Uses the `compareThen` helper to chain comparisons
   - If the first comparison is `EQ`, it proceeds to the next
   - Otherwise, it returns the first non-`EQ` result

## Project Structure

```
elm-auto-compare/
├── src/
│   └── AutoCompare.elm          # Main library module with compareThen helper
├── review/
│   └── src/
│       ├── ReviewConfig.elm     # elm-review configuration
│       └── AutoCompare/
│           └── GenerateComparison.elm  # The elm-review rule
├── examples/
│   └── src/
│       ├── Simple.elm           # Simple example types
│       ├── Game/
│       │   ├── Cards.elm        # Card types for poker
│       │   └── Poker.elm        # Texas Hold'em types
│       └── TestComparisons.elm  # Demo application
└── tests/                       # Test directory
```

## Installation

1. Install this package in your elm-review configuration:
```bash
cd review  # Your elm-review directory
elm install your-username/elm-auto-compare
```

2. Or add it to an existing Elm project that will use the generated functions:
```bash
elm install your-username/elm-auto-compare
```

## How It Works

The elm-review rule:
1. Analyzes types you specify in the configuration
2. **Sorts constructors by their source position (row, column)** to preserve declaration order
3. Generates comparison functions that follow F#'s sorting rules

### Key Innovation: Source Position Sorting

```elm
sortedConstructors =
    List.sortBy 
        (\constructor -> 
            let 
                range = Node.range constructor
            in
            ( range.start.row, range.start.column )
        ) 
        customType.constructors
```

This ensures declaration order is preserved even if elm-syntax provides constructors in a different order.

## Examples

### Simple Color Type

```elm
type Color
    = Red
    | Green  
    | Blue
    | RGB Int Int Int
```

Generates:
- `Red < Green < Blue < RGB` (constructor order)
- `RGB` values compared by R, then G, then B

### Record Type

```elm
type alias Person =
    { name : String
    , age : Int
    , height : Float
    }
```

Generates comparison by:
1. `name` first
2. `age` if names are equal
3. `height` if names and ages are equal

### Texas Hold'em Card Example

```elm
type Suit = Clubs | Diamonds | Hearts | Spades
type Rank = Two | Three | ... | King | Ace

type alias Card =
    { rank : Rank
    , suit : Suit
    }
```

Compares by rank first, then suit if ranks are equal.

## Running the Examples

```bash
cd examples
elm reactor
# Open http://localhost:8000/src/TestComparisons.elm
```

## Design Decisions

1. **Generated Code Location**: Placed under `src/Generated/` mirroring the source structure to clearly separate generated code
2. **Function Naming**: Uses `compareTypeName` convention
3. **Helper Functions**: The `compareThen` helper is included inline when needed (for types with multiple fields/arguments)
4. **Type Safety**: All generated functions have proper type signatures

## Limitations

- Currently supports only custom types and record type aliases
- Requires manual configuration of types to generate
- Generated code needs to be committed or regenerated in CI

## Future Enhancements

- Support for generic types
- Automatic detection of types needing comparison
- Configuration options for comparison order
- Integration with elm-format for generated code