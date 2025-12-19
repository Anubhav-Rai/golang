# Task: Create Go Functions Theory

## Your Mission
Deep dive into Go functions and what's different from C/C++.

## What to Create
Theory on:
- Function syntax (return type after params - why this order?)
- Multiple return values (built-in vs C++ tuple/pair hacks)
- Named return values (clarity vs implicit behavior)
- Error handling via returns (vs exceptions - huge design choice)
- Variadic functions (vs C va_list, vs C++ variadic templates)
- First-class functions (vs C function pointers, C++ std::function)
- Closures (vs C++11 lambdas - similarities and differences)
- NO default parameters (design choice - why?)
- NO function overloading (design philosophy)
- Defer in functions (cleanup patterns)

## Critical Design Discussions
- Why no overloading? (Complexity vs convenience)
- How do multiple returns simplify error handling vs exceptions?
- What are the tradeoffs of no default params?
- How does this affect API design?

## Structure
Theory.md in basic/intermediate/advanced with inline examples.
