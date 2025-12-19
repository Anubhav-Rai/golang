# Go Language Learning Guide for C/C++ Developers

Welcome to your comprehensive Go learning journey! This guide is specifically designed for developers with C/C++ syntax knowledge.

## 📚 Structure

Each topic folder contains:
- **claude.md** - Complete learning context for that topic (work with AI assistant)
- **basic/** - Beginner level code examples
- **intermediate/** - Intermediate level code examples  
- **advanced/** - Advanced level code examples

## 🗺️ Learning Path

### Phase 1: Fundamentals (Weeks 1-2)
1. **01_basics_and_syntax** - Start here! Program structure, packages, visibility
2. **02_data_types_and_variables** - Types, zero values, constants
3. **03_operators_and_expressions** - Operators and their differences from C++
4. **04_control_flow** - if, for, switch, defer
5. **05_functions** - Multiple returns, named returns, closures

### Phase 2: Core Concepts (Weeks 3-4)
6. **06_arrays_and_slices** - Go's most important data structure
7. **07_maps** - Built-in hash maps
8. **08_structs** - Composition over inheritance
9. **09_pointers** - Simpler and safer than C++
10. **10_methods_and_interfaces** - Go's polymorphism

### Phase 3: Go Idioms (Weeks 5-6)
11. **11_error_handling** - No exceptions, explicit errors
12. **12_packages_and_modules** - Code organization, go.mod
13. **13_concurrency** - Goroutines and sync primitives
14. **14_channels** - CSP model for communication
15. **15_file_io** - Reading, writing, paths

### Phase 4: Professional Skills (Weeks 7-8)
16. **16_testing** - Built-in testing, benchmarking
17. **17_reflection** - Runtime type inspection
18. **18_generics** - Type parameters (Go 1.18+)
19. **19_memory_management** - GC, profiling, optimization
20. **20_advanced_patterns** - Production-ready patterns

## 🎯 How to Use This Guide

### Working with claude.md files

Each `claude.md` file is designed to work with Claude (or any AI assistant) to provide focused learning context:

```bash
# Open a topic's claude.md
cd 01_basics_and_syntax
cat claude.md

# Work with Claude using this context
# The file contains:
# - C/C++ comparisons
# - Key differences
# - Common pitfalls
# - Practice exercises
```

### Creating Your Examples

Add your code examples to the appropriate folders:

```
01_basics_and_syntax/
├── claude.md         # Theory and context
├── basic/
│   ├── hello.go      # Your first program
│   └── variables.go  # Basic examples
├── intermediate/
│   └── packages.go   # Package examples
└── advanced/
    └── build.go      # Build optimization
```

## 📖 Quick Start

### Day 1: Hello Go
```bash
cd 01_basics_and_syntax/basic
```

Create `hello.go`:
```go
package main

import "fmt"

func main() {
    fmt.Println("Hello from Go!")
}
```

Run it:
```bash
go run hello.go
```

### Day 2: Understanding the Differences

Read through `01_basics_and_syntax/claude.md` and compare:
- No semicolons
- Package system vs headers
- Capitalization for visibility
- defer vs RAII

## 🔑 Key Differences from C/C++ (Quick Reference)

| Feature | C/C++ | Go |
|---------|-------|-----|
| **Headers** | .h/.hpp files | No headers, single .go files |
| **Memory** | Manual (new/delete) | Garbage collected |
| **Polymorphism** | Inheritance, virtual | Interfaces (implicit) |
| **Concurrency** | Threads, complex | Goroutines, channels |
| **Error Handling** | Exceptions | Return values |
| **Generics** | Templates | Type parameters (1.18+) |
| **Namespaces** | namespace keyword | Packages |
| **Visibility** | public/private | Capitalization |
| **Constructors** | Constructor functions | Factory functions |
| **Destructors** | Automatic (RAII) | defer keyword |

## 🚀 Command Reference

```bash
# Run program
go run main.go

# Build executable
go build

# Run tests
go test ./...

# Format code (ALWAYS do this!)
go fmt ./...

# Get dependencies
go get package-name

# Initialize module
go mod init module-name

# Tidy dependencies
go mod tidy

# View documentation
go doc package-name

# Run with race detector
go run -race main.go

# Build with optimization
go build -ldflags="-s -w"

# Check for issues
go vet ./...
```

## 💡 Daily Practice Routine

### Week 1-2 (Basics)
- **Day 1-3:** Topics 1-3 (basics, types, operators)
- **Day 4-5:** Topics 4-5 (control flow, functions)
- **Day 6-7:** Build small CLI tools, practice

### Week 3-4 (Core)
- **Day 1-2:** Topics 6-7 (slices, maps)
- **Day 3-4:** Topics 8-9 (structs, pointers)
- **Day 5:** Topic 10 (interfaces)
- **Day 6-7:** Build data structure library

### Week 5-6 (Concurrency)
- **Day 1-2:** Topics 11-12 (errors, packages)
- **Day 3-4:** Topic 13 (concurrency)
- **Day 5:** Topic 14 (channels)
- **Day 6:** Topic 15 (file I/O)
- **Day 7:** Build concurrent program

### Week 7-8 (Advanced)
- **Day 1-2:** Topics 16-17 (testing, reflection)
- **Day 3-4:** Topics 18-19 (generics, memory)
- **Day 5-7:** Topic 20 and build complete project

## 📝 Project Ideas by Level

### Basic Level
- Command-line calculator
- File reader/writer
- Simple HTTP client
- JSON parser/generator

### Intermediate Level
- Web server with REST API
- Concurrent file processor
- Chat application
- Database CRUD application

### Advanced Level
- Distributed task queue
- Real-time data processor
- Microservice with monitoring
- Custom testing framework

## 🔍 Resources

### Official
- [Go Tour](https://go.dev/tour/) - Interactive tutorial
- [Go Documentation](https://go.dev/doc/) - Official docs
- [Go by Example](https://gobyexample.com/) - Code examples
- [Effective Go](https://go.dev/doc/effective_go) - Best practices

### Community
- [Go Forum](https://forum.golangbridge.org/)
- [r/golang](https://reddit.com/r/golang)
- [Gophers Slack](https://gophers.slack.com/)

### Books
- "The Go Programming Language" - Donovan & Kernighan
- "Go in Action" - Kennedy, Ketelsen, Martin
- "Concurrency in Go" - Katherine Cox-Buday

## ⚠️ Common Mistakes (Avoid These!)

1. **Unused imports/variables** - Compilation error!
2. **Not checking errors** - ALWAYS check `if err != nil`
3. **Copying mutex values** - Use pointers
4. **Range loop gotcha** - `for _, v := range` creates copies
5. **Goroutine leaks** - Always have exit strategy
6. **Premature optimization** - Profile first
7. **Not using `go fmt`** - Format code always

## 🎓 Learning Tips

1. **Read code daily** - Browse stdlib source
2. **Write tests** - Practice TDD
3. **Use go fmt** - Let the tool format
4. **Read Effective Go** - Learn idioms
5. **Build projects** - Apply knowledge
6. **Join community** - Ask questions
7. **Compare with C++** - Understand tradeoffs

## 📊 Progress Tracking

Create a progress.md file to track:
- [ ] Completed basic level of each topic
- [ ] Completed intermediate level
- [ ] Completed advanced level
- [ ] Built 3 small projects
- [ ] Built 1 medium project
- [ ] Contributed to open source

## 🤝 Getting Help

When stuck:
1. **Check claude.md** - Topic-specific context
2. **Read error messages** - Go errors are clear
3. **Use `go doc`** - Built-in documentation
4. **Search Go Tour** - Interactive examples
5. **Ask on forums** - Community is helpful
6. **Compare with C++** - Find similar patterns

## 🎯 Next Steps After Completion

1. **Read "Effective Go"** - Master idioms
2. **Contribute to projects** - Real experience
3. **Learn web frameworks** - Gin, Echo, Fiber
4. **Study stdlib** - Well-written code
5. **Build production app** - Deploy something
6. **Learn profiling** - pprof mastery
7. **Explore ecosystem** - gRPC, protobuf, etc.

## 📌 Important Notes

- **Go is not C++** - Don't force C++ patterns
- **Simplicity is key** - Go prefers simple solutions
- **Concurrency is built-in** - Use goroutines
- **Composition over inheritance** - No classes
- **Interfaces are implicit** - No "implements"
- **Error handling is explicit** - No exceptions

---

**Remember:** Go is designed for simplicity and productivity. Embrace the idioms, don't fight them. Happy learning! 🚀

*Created for C/C++ developers transitioning to Go*
