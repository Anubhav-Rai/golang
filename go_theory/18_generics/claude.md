# Task: Create Go Generics Theory

## Your Mission
Explain Go generics (Go 1.18+) vs C++ templates - simpler but less powerful.

## What to Create
Comprehensive theory on:
- Late addition to Go (why the 13-year delay?)
- Type parameters syntax [T any]
- Generic functions vs C++ function templates
- Generic types vs C++ class templates
- Constraints vs C++ concepts/SFINAE
- Interface-based constraints (Go's approach)
- ~T approximation constraint
- any constraint (vs template<typename T>)
- comparable constraint (built-in)
- Type inference (similar to C++)
- NO template specialization (design choice)
- NO variadic type parameters like C++
- Compile-time instantiation (monomorphization)
- Performance implications

## Design Philosophy Deep Dive
- Why Go waited 13 years to add generics
- Design goals: simplicity over power
- Simpler but less powerful than C++ templates
- No Turing-complete metaprogramming (intentional)
- Tradeoffs: expressiveness vs complexity
- When to use generics vs interfaces?
- What C++ template techniques don't work in Go?

## Structure
Theory.md comparing with C++ templates extensively.
