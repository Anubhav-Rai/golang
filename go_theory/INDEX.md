# Go Learning Index - Topic by Topic Guide

## 📋 Complete Topic List

### 🟢 Phase 1: Fundamentals (Start Here!)

#### 01. Basics and Syntax
**Location:** `01_basics_and_syntax/claude.md`
**Key Concepts:**
- Package system vs C++ headers
- No semicolons
- Brace style (mandatory on same line)
- Visibility rules (Capitalization)
- go fmt, go run, go build

**C++ Comparison:**
- No #include → import
- No .h/.cpp → single .go files
- No using namespace → direct package usage

---

#### 02. Data Types and Variables
**Location:** `02_data_types_and_variables/claude.md`
**Key Concepts:**
- Zero values (no uninitialized variables!)
- Type inference with :=
- Immutable strings
- Explicit type conversions
- Constants and iota

**C++ Comparison:**
- No implicit conversions
- byte/rune vs char
- string vs char*/std::string

---

#### 03. Operators and Expressions
**Location:** `03_operators_and_expressions/claude.md`
**Key Concepts:**
- ++ and -- are statements only
- No ternary operator (?:)
- Bit clear operator (&^)
- Comma-ok idiom
- No pointer arithmetic

**C++ Comparison:**
- No operator overloading
- No prefix ++
- Must use if/else instead of ternary

---

#### 04. Control Flow
**Location:** `04_control_flow/claude.md`
**Key Concepts:**
- No parentheses in if/for
- Only 'for' loop (no while!)
- Switch without fall-through
- defer statement (UNIQUE!)
- Range iteration

**C++ Comparison:**
- if/switch simpler syntax
- defer vs RAII
- for covers all loop types

---

#### 05. Functions
**Location:** `05_functions/claude.md`
**Key Concepts:**
- Multiple return values
- Named return values
- Error as return value
- Variadic functions
- First-class functions
- Closures

**C++ Comparison:**
- No function overloading
- Multiple returns vs tuple
- Error values vs exceptions

---

### 🟡 Phase 2: Core Concepts

#### 06. Arrays and Slices
**Location:** `06_arrays_and_slices/claude.md`
**Key Concepts:**
- Arrays are values (size = type)
- Slices are references
- append, copy, cap, len
- Slice internals (ptr, len, cap)
- Slicing operations

**C++ Comparison:**
- Slices ≠ std::vector
- Arrays copy on assignment
- No pointer arithmetic

---

#### 07. Maps
**Location:** `07_maps/claude.md`
**Key Concepts:**
- Built-in hash maps
- Comma-ok for existence check
- Random iteration order
- Map as set
- Reference type

**C++ Comparison:**
- Built-in vs std::map/unordered_map
- Simpler syntax
- No iterators

---

#### 08. Structs
**Location:** `08_structs/claude.md`
**Key Concepts:**
- No classes (only structs)
- Embedding vs inheritance
- Struct tags for metadata
- Constructor pattern
- Functional options

**C++ Comparison:**
- Composition over inheritance
- No constructors/destructors
- Tags for reflection

---

#### 09. Pointers
**Location:** `09_pointers/claude.md`
**Key Concepts:**
- No pointer arithmetic
- Automatic dereferencing (p.field)
- Escape analysis
- Safe to return local addresses
- new() vs make()

**C++ Comparison:**
- Simpler and safer
- No void*
- Garbage collected

---

#### 10. Methods and Interfaces
**Location:** `10_methods_and_interfaces/claude.md`
**Key Concepts:**
- Methods on any type
- Implicit interface implementation
- Empty interface (any)
- Type assertions
- Duck typing

**C++ Comparison:**
- No virtual keyword
- Implicit vs explicit inheritance
- Interface composition

---

### 🟠 Phase 3: Go Idioms

#### 11. Error Handling
**Location:** `11_error_handling/claude.md`
**Key Concepts:**
- Errors as values
- if err != nil pattern
- Error wrapping (%w)
- errors.Is and errors.As
- panic/recover (rare!)

**C++ Comparison:**
- No exceptions!
- Explicit error checking
- Multiple returns

---

#### 12. Packages and Modules
**Location:** `12_packages_and_modules/claude.md`
**Key Concepts:**
- Package system
- go.mod and go.sum
- Dependency management
- internal/ package
- Visibility rules

**C++ Comparison:**
- No header files
- Simple dependency management
- Better than CMake/Make

---

#### 13. Concurrency
**Location:** `13_concurrency/claude.md`
**Key Concepts:**
- Goroutines (lightweight threads)
- go keyword
- WaitGroup
- Mutex, RWMutex
- Race detector

**C++ Comparison:**
- Much lighter than threads
- Built into language
- Simpler synchronization

---

#### 14. Channels
**Location:** `14_channels/claude.md`
**Key Concepts:**
- CSP model
- Buffered vs unbuffered
- Select statement
- Channel directions
- Pipeline patterns

**C++ Comparison:**
- No direct equivalent
- Better than condition variables
- Communication over shared memory

---

#### 15. File I/O
**Location:** `15_file_io/claude.md`
**Key Concepts:**
- os package
- io.Reader/Writer interfaces
- bufio for buffering
- filepath package
- JSON encoding

**C++ Comparison:**
- Simpler API
- Better error handling
- Interface-based design

---

### 🔴 Phase 4: Professional Skills

#### 16. Testing
**Location:** `16_testing/claude.md`
**Key Concepts:**
- Built-in testing
- Table-driven tests
- Benchmarking
- Coverage tools
- httptest package

**C++ Comparison:**
- No external framework needed
- go test built-in
- Simpler than Google Test

---

#### 17. Reflection
**Location:** `17_reflection/claude.md`
**Key Concepts:**
- reflect.Type and reflect.Value
- Struct tag reading
- Type assertions
- DeepEqual
- Performance cost

**C++ Comparison:**
- More powerful than RTTI
- Used for serialization
- Slower than static typing

---

#### 18. Generics
**Location:** `18_generics/claude.md`
**Key Concepts:**
- Type parameters [T any]
- Constraints
- comparable interface
- Generic types
- Type inference

**C++ Comparison:**
- Simpler than templates
- Compile-time checked
- Less powerful but clearer

---

#### 19. Memory Management
**Location:** `19_memory_management/claude.md`
**Key Concepts:**
- Garbage collection
- Escape analysis
- Memory profiling (pprof)
- sync.Pool
- Common leaks

**C++ Comparison:**
- Automatic GC
- No manual delete
- Trade-off: GC pauses

---

#### 20. Advanced Patterns
**Location:** `20_advanced_patterns/claude.md`
**Key Concepts:**
- Functional options
- Context pattern
- Pipeline pattern
- Worker pool
- Circuit breaker
- Graceful shutdown

**C++ Comparison:**
- Idiomatic Go patterns
- Concurrency patterns
- Production-ready code

---

## 🗺️ Learning Paths

### Path 1: Quick Start (1 week)
1. Topics 1-5: Fundamentals
2. Topic 6: Slices (most important!)
3. Topic 11: Error handling
4. Build a CLI tool

### Path 2: Web Developer (2 weeks)
1. Topics 1-5: Fundamentals
2. Topics 6-10: Core concepts
3. Topic 11: Errors
4. Topic 12: Packages
5. Topic 15: File I/O
6. Topic 16: Testing
7. Build REST API

### Path 3: Systems Programmer (3 weeks)
1. All fundamentals (Topics 1-5)
2. All core concepts (Topics 6-10)
3. Concurrency deep dive (Topics 13-14)
4. Memory management (Topic 19)
5. Advanced patterns (Topic 20)
6. Build concurrent system

### Path 4: Complete Mastery (8 weeks)
Follow the phases in order, spending:
- Week 1-2: Phase 1 (Topics 1-5)
- Week 3-4: Phase 2 (Topics 6-10)
- Week 5-6: Phase 3 (Topics 11-15)
- Week 7-8: Phase 4 (Topics 16-20)

## 📚 How to Use Each Topic

### Step 1: Read claude.md
Open the topic's `claude.md` file and read through:
- C/C++ comparisons
- Key differences
- Common pitfalls
- Learning path

### Step 2: Create Examples
Create your own examples in:
- `basic/` - Simple examples
- `intermediate/` - More complex examples
- `advanced/` - Advanced usage

### Step 3: Practice
Work through exercises and build small programs using the concepts.

### Step 4: Move to Next Topic
Once comfortable, move to the next topic.

## 🎯 Must-Know Topics (Priority Order)

1. **01 - Basics** - Foundation
2. **02 - Data Types** - Type system
3. **05 - Functions** - Multiple returns!
4. **06 - Slices** - Most used data structure
5. **08 - Structs** - Data modeling
6. **10 - Interfaces** - Polymorphism
7. **11 - Error Handling** - Go way of errors
8. **13 - Concurrency** - Go's superpower
9. **14 - Channels** - Communication
10. **16 - Testing** - Professional development

## 🔍 Quick Lookup

**Need to understand:**
- How packages work? → Topic 12
- Error handling? → Topic 11
- Concurrency? → Topics 13 & 14
- Testing? → Topic 16
- Memory issues? → Topic 19
- Design patterns? → Topic 20

**Coming from C++ and wondering:**
- Where are templates? → Topic 18 (Generics)
- How do I inherit? → Topic 10 (Interfaces) & 08 (Embedding)
- What about RAII? → Topic 04 (defer)
- Memory management? → Topic 19
- Exceptions? → Topic 11 (Error values)

## 📊 Difficulty Levels

**Easy (Start here):**
- 01, 02, 03, 04, 05

**Medium:**
- 06, 07, 08, 09, 10, 11, 12, 15, 16

**Advanced:**
- 13, 14, 17, 18, 19, 20

## 💡 Study Tips

1. **Don't skip fundamentals** - They're different from C++
2. **Practice with code** - Reading isn't enough
3. **Use go fmt** - Let the tool format
4. **Read stdlib** - Well-written Go code
5. **Build projects** - Apply knowledge
6. **Check errors** - Always!
7. **Use context** - Cancel operations
8. **Test everything** - It's built-in

## ✅ Completion Checklist

Create a file to track your progress:

```
[ ] 01 - Basics and Syntax
[ ] 02 - Data Types and Variables
[ ] 03 - Operators and Expressions
[ ] 04 - Control Flow
[ ] 05 - Functions
[ ] 06 - Arrays and Slices
[ ] 07 - Maps
[ ] 08 - Structs
[ ] 09 - Pointers
[ ] 10 - Methods and Interfaces
[ ] 11 - Error Handling
[ ] 12 - Packages and Modules
[ ] 13 - Concurrency
[ ] 14 - Channels
[ ] 15 - File I/O
[ ] 16 - Testing
[ ] 17 - Reflection
[ ] 18 - Generics
[ ] 19 - Memory Management
[ ] 20 - Advanced Patterns
```

---

**Start with Topic 01 and work your way through!** 🚀

Each topic builds on previous ones, so follow the order for best results.
