app [main!] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.18.0/0APbwVN1_p1mJ96tXjaoiUCr8NBGamr8G8Ac_DrXR-o.tar.br",
    json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.11.0/z45Wzc-J39TLNweQUoLw3IGZtkQiEN3lTBv3BXErRjQ.tar.br",
}

import json.Json
import pf.Stdout

# Show basic examples, varibles, functions, arithmetic, etc., debug printing, type annotion, overflow crashes, fractions, Num a
# assignment, assignment, ..., expression


main! = \_args ->
    Stdout.line! "Hallo Welt"

# Type annotation
bricks : Int a
bricks = 3

expect bricks == 3

squareToString : Int a -> Str where a implements Bool.Eq
squareToString = \x -> 
    y = x * x
    if y == x then
        "One or Zero"
    else
        Num.toStr (x * x)


expect (squareToString 1) == "One or Zero"

typesAreInferred = \x -> 
    x * x

expect (typesAreInferred 3) == 9

someNumbers = [1, 2, 3, 4, 5]

expect List.keepIf someNumbers (\x -> x % 2 == 0) == [2, 4]
expect List.keepIf someNumbers Num.isEven == [2, 4]

expect List.dropAt someNumbers 2 == [1, 2, 4, 5]

pipedLists = \myList ->
    List.keepIf myList Num.isEven
    |> List.map (\x -> x * x)
    |> List.dropAt 1
    |> List.map Num.toStr

expect pipedLists someNumbers == ["4"]


expect List.get someNumbers 2 == Ok 3
expect List.get someNumbers 5 == Err OutOfBounds

expect Result.withDefault (List.get someNumbers 17) 0 == 0

expect Result.try (Str.toU64 "3") (\i -> List.get someNumbers i) == Ok 4

grouped = List.walk someNumbers { evens: [], odds: []} \state, element -> 
    if Num.isEven element then
        { state & evens: List.append state.evens element }
    else
        { state & odds: List.append state.odds element }

expect grouped == { evens: [2, 4], odds: [1, 3, 5] }

summed = List.walk someNumbers 0 \state, element -> state + element

expect summed == 15

patternMatchingOnLists = \x ->
    when x is 
        [] -> "Empty"
        [1, 2, 3] -> "One, Two, Three"
        [1, 2, 3, 4, 5] -> "One to Five"
        [..] -> "Something else"

expect patternMatchingOnLists [] == "Empty"
expect patternMatchingOnLists [1, 2, 3] == "One, Two, Three"
expect patternMatchingOnLists [3, 2, 1] == "Something else"

# tuples, tags, pattern matchin with when, payloads, lists

expect (List.map someNumbers typesAreInferred) == [1, 4, 9, 16, 25]

# mixedTypes = [1, 2, 3, "hello", 5]

mixedTypesWithTags = [N 1, N 3, N 4, S "hello", N 5]

takesTag = \x -> 
    when x is
        N num -> Num.toStr (num * num)
        S str -> str

expect takesTag (N 3) == "9"

expect (List.map mixedTypesWithTags takesTag) == ["1", "9", "16", "hello", "25"]

# Records

Vec3 a : {x: Num a, y: Num a, z: Num a}

crossProduct : Vec3 a, Vec3 a -> Vec3 a
crossProduct = \a, b -> 
    { x: a.y * b.z - a.z * b.y, y: a.z * b.x - a.x * b.z, z: a.x * b.y - a.y * b.x }
    
vec1 = { x: 1, y: 2, z: 3 }
vec2 = { x: 4, y: 5, z: 6 }

expect crossProduct vec1 vec2 == { x: -3, y: 6, z: -3 }



# notAVec = { x: 4, y: 5 , z: 6, w: 7}
# expect crossProduct vec1 notAVec == { x: -3, y: 6, z: -3 }

vecSum = \{x, y, z} -> x + y + z

expect vecSum vec1 == 6

multiply = \{a, b, by ? 1} -> a * b * by

expect multiply {a: 2, b: 3} == 6
expect multiply {a: 2, b: 3, by: 2} == 12


original = { a: 12, b: 3}
copy = { original & b: 0}

expect copy == { a: 12, b: 0}

# Records and type inference, type alias, type parameters, unions
# default-value records, type annotations

tryGet = \maybeNum ->
    index = try Str.toU64 maybeNum
    List.get ["a", "b", "c"] index

expect tryGet "1" == Ok "b"
expect tryGet "3" == Err OutOfBounds
expect tryGet "hello" == Err (InvalidNumStr)

tryGetOld = \maybeNum ->
    index = Str.toU64? maybeNum
    List.get ["a", "b", "c"] index


expect tryGetOld "1" == Ok "b"
expect tryGetOld "3" == Err OutOfBounds
expect tryGetOld "hello" == Err (InvalidNumStr)

# More records: Destructoring, copy

# Error handling with Err/Ok, List.walk, Result type, partial type annotation

# JSON decoding
# https://www.roc-lang.org/examples/Json/README.html


import "test.json" as jsonData : Str

getMessage : Str -> Result Str _
getMessage = \jsonStr -> 
    data = Str.toUtf8 jsonStr
    decoder = Json.utf8
    decoded = Decode.fromBytesPartial data decoder
    when decoded.result is
        Ok value -> Ok value.message
        Err e -> Err e

expect getMessage jsonData == Ok "Hello, World!"

Show implements
    show : x -> Str where x implements Show

showMe : val -> Str where val implements Show 
showMe = \val -> show val

Color := [Red, Green, Blue]
    implements [
        Eq,
        Show {
            show : showColor,
        },
    ]

showColor : Color -> Str
showColor = \@Color color ->
    when color is
        Red -> "Red"
        Green -> "Green"
        Blue -> "Blue"

expect showMe (@Color Red) == "Red"
