# Task: Create Go Testing Theory

## Your Mission
Explain Go's built-in testing vs C++ external frameworks.

## What to Create
Theory on:
- Built-in testing (vs gtest, catch2, boost.test)
- testing package simplicity
- Naming conventions (*_test.go, Test*)
- go test command integration
- Table-driven tests (idiomatic Go pattern)
- t.Error vs t.Fatal
- Subtests (t.Run for organizing tests)
- Test coverage built-in (vs gcov, lcov)
- Benchmarking built-in (testing.B)
- Example tests (documentation + verification)
- TestMain for setup/teardown
- Test helpers and t.Helper()
- Parallel tests (t.Parallel)
- Mocking strategies (interfaces enable easy mocking)

## Design Philosophy
- Why built-in testing? (Convention over configuration)
- Simplicity vs C++ testing framework complexity
- Table-driven tests pattern (data-driven testing)
- How interface design enables testability
- Benchmark as first-class citizen

## Structure
Theory.md with test pattern examples and comparisons.
