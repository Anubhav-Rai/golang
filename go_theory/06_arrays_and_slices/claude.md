# Task: Create Go Arrays and Slices Theory

## Your Mission
Explain Go's array/slice dichotomy and how it prevents C/C++ memory bugs.

## What to Create
Comprehensive theory on:
- Arrays as VALUE types (vs C/C++ array decay to pointer)
- Size as part of array type (design implication)
- Slices as references (vs C++ vector)
- Slice internals (ptr, len, cap - three-word structure)
- Why this three-part structure?
- Dynamic growth strategy (vs vector reallocation)
- Copy semantics (deep vs shallow)
- NO pointer arithmetic (safety)
- Built-in functions: make, append, copy, len, cap
- Subslicing and memory sharing (gotchas)
- Pass by value vs pass by reference behavior

## Design Deep Dive
- Why separate arrays and slices? (Flexibility + safety)
- How does this prevent buffer overflows?
- What C/C++ bugs are impossible in Go?
- Performance implications of slice growth
- Memory diagrams essential

## Structure
Theory.md files with memory diagrams and comparative examples.
