# Task: Create Go Reflection Theory

## Your Mission
Explain Go reflection vs C++ RTTI and template metaprogramming.

## What to Create
Theory on:
- Built-in reflection (vs limited C++ RTTI)
- reflect package (Type and Value)
- Runtime type information (vs compile-time C++ templates)
- Inspecting types at runtime
- Modifying values through reflection
- Struct tags usage (JSON, ORM, validation)
- Three laws of reflection
- interface{} and reflection relationship
- TypeOf vs ValueOf
- Kind vs Type distinction
- Performance cost (vs zero-cost C++ compile-time)
- When to use/avoid reflection
- Reflection for generic behavior (before generics)

## Design Tradeoffs
- How reflection enables runtime flexibility
- Runtime cost vs compile-time safety
- Comparison with C++ template metaprogramming
- Why Go needed runtime reflection
- When reflection is appropriate
- Type erasure and type assertions

## Structure
Theory.md with reflection pattern examples and performance discussion.
