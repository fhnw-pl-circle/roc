# roc

"A fast, friendly, functional language"


## Fast
- all I/O is async -> overhead, but potential performance benefits
- types only tracked at compile time, generics, records, uinions have the same runtime overhead as C++ or Rust

### Memory Management

Roc is designed to run on "Platforms", which are responsible for managing memory, this allows domain specific optimizations.

Nea is a platform for web servers and uses "arena allocation", where all allocations for a request are put in one region of memory, which is deallocated when the request is finished.

A platform could also choose to skip deallocations completely for shortlived programs like command line scripts.

## Friendly

- Simple syntax
- Few indirections (no inhertiance, no subclassing, no proxying)
- No mutable variables, no reassingments, no shadowing
- String interpolation with $()
- roc format for consistent code style (no configuration)
- "helfpul compiler"
- serialization inference -> explained later
- expect keyword for testing, similar to assertions (but no crash at runtime)

## Functional

- Small number of simple language primitives
- "Opportunistic mutation", mutation if it is efficient and safe to do so
- Semantically everything is immutable
  - functions tend to be chainable
- No reassignment, no shadowing
- No loop syntax, but recursion with tail call optimization -> Purity inference
- No side effects, but "managed effects" (Tasks)
- All functions are pure, because of immutability and lack of side effects
- Optimizations based on this: loop fusion, compile time evaluation, hoisting
- Some work for supporting a more imperative style


## Platforms

Apps are built on a platform. A platform needs to provide memory management and I/O primitives, as well as the high level roc api.

Example platforms:
- https://github.com/roc-lang/basic-cli
- https://github.com/roc-lang/basic-webserver
- https://github.com/Billzabob/roc-clock/ (Using GPIO on a Raspberry Pi)
- https://github.com/bhansconnect/roc-microbit (On a microbit, using embassy, but not not actively maintained)
- https://github.com/tweedegolf/nea/ (NEver Allocate)

There are also templates for different languages:

- https://github.com/lukewilliamboswell/roc-platform-template-zig
- https://github.com/lukewilliamboswell/roc-platform-template-rust
- https://github.com/lukewilliamboswell/roc-platform-template-go
- https://github.com/lukewilliamboswell/roc-platform-template-swift
- https://github.com/lukewilliamboswell/roc-platform-template-c

## Development status

- Actively developed
- Many changes to the language happen and will happen
- Dec 16 2024: snake_case_identifiers are now used by roc format
- Purity inference: https://www.youtube.com/watch?v=42TUAKhzlRI
- New keywords: try instead of '?', return

