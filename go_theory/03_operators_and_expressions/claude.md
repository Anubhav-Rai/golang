# Task: Create Go Operators and Expressions Theory

## Your Mission
Explain Go operators with focus on what's MISSING vs C++ and why.

## What to Create
Theory files covering:
- Arithmetic operators (type safety enforced)
- NO operator overloading (major C++ difference - why?)
- Bitwise operations (similar but type-safe)
- ++ and -- are STATEMENTS, not expressions (design choice)
- NO pointer arithmetic (safety tradeoff)
- Comparison operators (type-safe, no implicit conversion)
- Logical operators (short-circuit like C/C++)
- Assignment operators
- NO ternary operator ?: (controversial choice)

## Design Analysis Required
- Why remove operator overloading? (Readability vs power)
- Why make ++ and -- statements? (Prevents confusing code)
- What C/C++ bugs does this prevent?
- What conveniences are lost?

## Structure
Create theory.md in subfolders as needed with inline examples.
