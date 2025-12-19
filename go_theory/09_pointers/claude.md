# Task: Create Go Pointers Theory

## Your Mission
Explain Go's restricted pointers - safer than C/C++ but less flexible.

## What to Create
Theory on:
- Pointers exist but restricted (safety design)
- NO pointer arithmetic (huge difference from C/C++)
- NO void* pointer (type safety)
- Garbage collection (no manual free/delete)
- Nil vs NULL/nullptr
- & and * operators (familiar syntax)
- Automatic dereferencing for struct fields (convenience)
- NO references like C++ (design decision)
- new() function (vs C++ new)
- Can't get address of literals (why?)
- Stack vs heap (compiler decides via escape analysis)
- Unsafe package (escape hatch)

## Safety vs Flexibility Analysis
- What C/C++ pointer bugs are impossible in Go?
- What flexibility is lost without pointer arithmetic?
- How does GC change pointer usage patterns?
- When would you miss C++ manual control?
- Escape analysis and performance

## Structure
Theory.md with memory safety comparisons and examples.
