# Task: Create Go Data Types and Variables Theory

## Your Mission
Create comprehensive theory on Go's type system for C/C++ developer interested in language design.

## What to Create
Subfolders with theory.md files covering:
- Why explicit int sizes (int8, int16, int32, int64) AND platform-dependent int
- Zero values design (safety implications vs C/C++)
- Type inference (:= vs C++11 auto) - similarities and differences
- NO implicit type conversions (design choice)
- Strings as first-class types (vs char* in C)
- UTF-8 by default (modern design)
- Runes vs chars (Unicode handling)
- Type aliases vs type definitions
- Named vs unnamed types

## Deep Design Questions to Answer
- Why force explicit conversions? (Safety vs convenience)
- Why zero values? (Prevents entire class of bugs)
- How does this make Go safer than C/C++?
- What flexibility is lost vs gained?

## Structure
basic/, intermediate/, advanced/ theory.md as needed.
Theory + examples in same file.
