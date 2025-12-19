#!/usr/bin/env python3
"""
Generate comprehensive Go theory files with C/C++ comparisons and design rationale
"""

import os
import json

TOPICS = [
    {
        "num": "01",
        "name": "basics_and_syntax",
        "title": "Basics and Syntax",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "02",
        "name": "data_types_and_variables",
        "title": "Data Types and Variables",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "03",
        "name": "operators_and_expressions",
        "title": "Operators and Expressions",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "04",
        "name": "control_flow",
        "title": "Control Flow",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "05",
        "name": "functions",
        "title": "Functions",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "06",
        "name": "arrays_and_slices",
        "title": "Arrays and Slices",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "07",
        "name": "maps",
        "title": "Maps",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "08",
        "name": "structs",
        "title": "Structs",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "09",
        "name": "pointers",
        "title": "Pointers",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "10",
        "name": "methods_and_interfaces",
        "title": "Methods and Interfaces",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "11",
        "name": "error_handling",
        "title": "Error Handling",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "12",
        "name": "packages_and_modules",
        "title": "Packages and Modules",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "13",
        "name": "concurrency",
        "title": "Concurrency",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "14",
        "name": "channels",
        "title": "Channels",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "15",
        "name": "file_io",
        "title": "File I/O",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "16",
        "name": "testing",
        "title": "Testing",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "17",
        "name": "reflection",
        "title": "Reflection",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "18",
        "name": "generics",
        "title": "Generics",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "19",
        "name": "memory_management",
        "title": "Memory Management",
        "needs_intermediate": True,
        "needs_advanced": True
    },
    {
        "num": "20",
        "name": "advanced_patterns",
        "title": "Advanced Patterns",
        "needs_intermediate": True,
        "needs_advanced": True
    }
]

# Theory content templates with C/C++ comparisons and design rationale

THEORY_CONTENT = {
    "01_basics_and_syntax": {
        "basic": """# Go Basics and Syntax - Basic Level

## Overview
Go (Golang) is a statically typed, compiled language designed at Google in 2007 by Robert Griesemer, Rob Pike, and Ken Thompson. It was created to address shortcomings in C++ while maintaining its performance benefits.

## Why Go Was Created (vs C/C++)

### Problems with C/C++ that Go Solves:
1. **Slow compilation times**: C++ templates and header files cause exponential build times
2. **Complex dependency management**: #include system leads to circular dependencies
3. **No built-in concurrency**: pthreads are low-level and error-prone
4. **Manual memory management**: malloc/free and new/delete cause memory leaks
5. **Overly complex**: C++ has grown to have too many features (multiple inheritance, operator overloading, etc.)

### Go's Design Philosophy:
- **Simplicity**: Deliberately limited feature set
- **Fast compilation**: No header files, explicit dependencies
- **Built-in concurrency**: Goroutines and channels as first-class citizens
- **Garbage collection**: Automatic memory management
- **Strong standard library**: Batteries included

## Program Structure

### Basic Hello World

**Go:**
```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```

**C++:**
```cpp
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
```

### Design Rationale: Package Declaration

**Why `package main` instead of nothing?**

In C/C++, there's no explicit package/module declaration. This causes:
- **Global namespace pollution**: All symbols are global unless namespaced
- **No enforced organization**: Files can include anything
- **Circular dependency hell**: Hard to detect and prevent

Go's `package` keyword:
- **Explicit organization**: Every file must declare its package
- **Namespace isolation**: Packages prevent name collisions
- **Clear dependencies**: Import graph is explicit and acyclic
- **Better compilation**: Compiler knows package boundaries

**Why `package main` is special?**
- Only `package main` with `func main()` creates an executable
- Other packages are libraries
- Clear distinction between application entry points and libraries
- In C/C++, any file with `int main()` can be an entry point (ambiguous)

### Design Rationale: Import System

**C/C++ includes:**
```cpp
#include <iostream>    // System header
#include "myheader.h"  // Local header
```

Problems:
- **Textual inclusion**: Entire header file is copied (slow)
- **Multiple inclusion**: Need include guards or #pragma once
- **Order dependent**: Includes must be in correct order
- **Transitive**: Including A includes everything A includes

**Go imports:**
```go
import "fmt"
import "mypackage"
```

Benefits:
- **Binary imports**: Imports compiled package objects (fast)
- **No multiple inclusion issues**: Each package compiled once
- **Order independent**: Imports can be in any order
- **Non-transitive**: Importing A doesn't import A's imports
- **Unused import error**: Forces clean dependencies

**Why grouped imports?**
```go
import (
    "fmt"
    "os"
)
```
- Cleaner syntax for multiple imports
- Standard formatting (gofmt enforces this)
- Easy to see all dependencies at once

### Design Rationale: Main Function

**C/C++:**
```cpp
int main() {
    return 0;  // Return value to OS
}

int main(int argc, char** argv) {
    // Access command-line arguments
}
```

**Go:**
```go
func main() {
    // No return value
    // Use os.Exit(code) if needed
}
```

**Why no return value in Go's main?**
- **Simplicity**: Most programs don't need custom exit codes
- **Explicit is better**: Use `os.Exit(1)` when you need it
- **Default success**: Implicit return 0 on normal exit
- **Panic for errors**: Unhandled panics automatically exit with non-zero

**Why no argc/argv parameters?**
- **Better API**: Use `os.Args` (slice of strings)
- **No pointer arithmetic**: os.Args[0] vs argv[0]
- **No count needed**: Slices know their length
- **Type safe**: []string vs char**

## Comments

### Single-line Comments

**Both Go and C/C++:**
```go
// This is a comment
x := 42  // Inline comment
```

### Multi-line Comments

**Both Go and C/C++:**
```go
/*
 * Multi-line comment
 * Works the same
 */
```

### Design Rationale: Comment Style

Go inherits C-style comments because:
- **Familiar**: Every C/C++ developer knows them
- **Tool-friendly**: Easy to parse
- **No ambiguity**: Clear start and end markers

**Go-specific: Documentation Comments**
```go
// Package fmt implements formatted I/O.
package fmt

// Println formats using the default formats for its operands and writes to standard output.
// Spaces are always added between operands and a newline is appended.
func Println(a ...interface{}) (n int, err error) {
```

**Why this matters:**
- **godoc tool**: Automatically generates documentation
- **No special syntax**: Just regular comments before declarations
- **Better than C++**: No Doxygen needed, built into language
- **Standardized**: Everyone documents the same way

## Semicolons

### The Big Difference

**C/C++ (required):**
```cpp
int x = 5;
cout << x;
return 0;
```

**Go (automatic):**
```go
x := 5
fmt.Println(x)
return
```

### Design Rationale: Automatic Semicolon Insertion

**Why Go made semicolons optional:**
1. **Reduce clutter**: Semicolons add noise
2. **Prevent bugs**: Missing semicolons are a common error in C/C++
3. **Cleaner code**: More readable
4. **Automatic formatting**: gofmt handles it

**How it works:**
The Go lexer automatically inserts semicolons after:
- An identifier
- A literal (number, string, etc.)
- Keywords: break, continue, fallthrough, return
- Operators: ++, --
- Closing brackets: ), ], }

**This is why opening braces can't be on next line:**
```go
// WRONG - semicolon inserted after )
func main()
{  // Error: unexpected {
}

// CORRECT
func main() {
}
```

In C/C++, you can write:
```cpp
int main()
{  // This works in C/C++
}
```

Go forces K&R brace style for consistency and to avoid semicolon insertion issues.

## Naming Conventions

### Variable and Function Names

**C/C++ (various styles):**
```cpp
int myVariable;      // camelCase
int my_variable;     // snake_case
int MyVariable;      // PascalCase
```

**Go (enforced):**
```go
var myVariable int        // private (lowercase start)
var MyVariable int        // public/exported (uppercase start)
```

### Design Rationale: Case-based Visibility

**Why case determines visibility instead of keywords?**

**C/C++ approach:**
```cpp
class MyClass {
public:
    int publicVar;
private:
    int privateVar;
protected:
    int protectedVar;
};
```

**Go approach:**
```go
type MyStruct struct {
    PublicField  int  // Exported (uppercase)
    privateField int  // Unexported (lowercase)
}
```

**Benefits of Go's approach:**
1. **No keywords needed**: Simpler language
2. **Immediate visibility**: See at a glance what's public
3. **No protected**: Simplifies object model
4. **Package-level privacy**: Not class-level like C++
5. **Consistent rule**: Works for types, functions, variables

**Trade-offs:**
- **Can't override**: In C++, you can access private with friend
- **No fine-grained control**: Only two levels (public/private)
- **Naming restrictions**: Must follow case rules

### Identifier Rules

**Go:**
- Must start with letter or underscore
- Can contain letters, digits, underscores
- Case-sensitive
- Can use Unicode (but discouraged in exported names)

**Same as C/C++** except:
- No $ allowed (unlike some C compilers)
- Unicode support is first-class
- Reserved words are different

## Code Organization

### File Structure

**C/C++ (header and implementation):**
```cpp
// myclass.h
#ifndef MYCLASS_H
#define MYCLASS_H

class MyClass {
public:
    void doSomething();
};

#endif

// myclass.cpp
#include "myclass.h"

void MyClass::doSomething() {
    // Implementation
}
```

**Go (single file):**
```go
// mypackage.go
package mypackage

type MyStruct struct {
    field int
}

func (m *MyStruct) DoSomething() {
    // Implementation right here
}
```

### Design Rationale: No Header Files

**Why Go eliminated header files:**

1. **Compilation speed**: 
   - C++: Parse headers in every translation unit
   - Go: Compile each package once, import binary

2. **DRY principle violation**:
   - C++: Declare in .h, define in .cpp (duplicate effort)
   - Go: Define once

3. **Maintenance burden**:
   - C++: Update two files, keep them in sync
   - Go: Update one file

4. **No include guards needed**:
   - C++: #ifndef/#define boilerplate
   - Go: Not needed

5. **Circular dependencies**:
   - C++: Require forward declarations and careful structuring
   - Go: Prevented by design (import cycles are compile errors)

**How Go achieves fast linking without headers:**
- Exports metadata in compiled package
- Importers read only what they need
- Dependency graph is explicit and acyclic

## Zero Values

### Default Initialization

**C/C++ (undefined behavior):**
```cpp
int x;           // Undefined value!
int* ptr;        // Undefined pointer!
char* str;       // Undefined!

// Must explicitly initialize:
int x = 0;
int* ptr = nullptr;
```

**Go (always zero):**
```go
var x int        // 0
var ptr *int     // nil
var str string   // ""
var b bool       // false
```

### Design Rationale: Zero Values

**Why Go initializes everything to zero:**

1. **Safety**: Eliminates undefined behavior
2. **Predictability**: Every variable has known state
3. **No null pointer exceptions from uninitialized variables**
4. **Simpler code**: Don't need explicit initialization
5. **Performance**: Zero initialization is optimized by compiler

**C/C++ issues Go solves:**
```cpp
int x;  // What's the value?
if (x > 0) {  // Undefined behavior!
    // Could be anything
}

char buffer[100];  // Garbage data
printf("%s", buffer);  // Could print garbage or crash
```

**Go guarantees:**
```go
var x int  // Always 0
if x > 0 {  // Safe, will be false
}

var buffer [100]byte  // All zeros
fmt.Printf("%s", buffer)  // Safe, empty string
```

**Zero values by type:**
- Numeric types (int, float64, etc.): 0
- bool: false
- string: "" (empty string)
- Pointers, slices, maps, channels, functions: nil
- Structs: All fields are zero-valued

## Type System Basics

### Type Declaration

**C/C++:**
```cpp
int x;              // Type before name
int* ptr;           // * attached to type (confusing)
int *ptr;           // Or attached to name
int *p1, *p2, *p3;  // Multiple pointers
```

**Go:**
```go
var x int           // Name before type
var ptr *int        // * attached to type (clear)
var p1, p2, p3 *int // All are pointers (consistent)
```

### Design Rationale: Type Syntax

**Why Go puts type after name:**

1. **Clearer for complex types**:
```cpp
// C++: Read right-to-left, inside-out
int (*(*fp)(int))[10];  // fp is pointer to function returning pointer to array of 10 ints

// Go: Read left-to-right
var fp func(int) *[10]int  // fp is function taking int, returning pointer to array of 10 ints
```

2. **Multiple declarations are clearer**:
```cpp
// C++: Only the last one is a pointer!
int* a, b, c;  // a is int*, b and c are int (gotcha!)

// Go: All have same type
var a, b, c *int  // All are *int
```

3. **Consistent with function syntax**:
```go
func add(x int, y int) int  // Reads naturally
```

4. **Makes parsing easier**: Type is in predictable position

### No Implicit Conversions

**C/C++ (implicit):**
```cpp
int i = 42;
float f = i;       // Implicit conversion
bool b = i;        // Implicit (0 is false, non-zero is true)
void* p = &i;      // Implicit
```

**Go (explicit):**
```go
var i int = 42
var f float64 = float64(i)  // Must be explicit
var b bool = (i != 0)       // Must compare
// No void* pointer type
```

### Design Rationale: No Implicit Conversions

**Why Go requires explicit conversions:**

1. **Clarity**: Conversions are visible
2. **Safety**: No accidental precision loss
3. **No surprises**: What you see is what you get
4. **Prevents bugs**: Common source of C/C++ bugs

**Common C/C++ pitfalls Go prevents:**
```cpp
// C++: Silent truncation
double d = 3.14159;
int i = d;  // i = 3, lost precision, no warning

unsigned u = 10;
int i = -5;
if (u < i) {  // Always false! i converted to unsigned
    // This code never runs
}
```

**Go forces explicit intent:**
```go
d := 3.14159
i := int(d)  // Explicit: I know I'm truncating

var u uint = 10
var i int = -5
// if u < i {  // Compile error!
if int(u) < i {  // Must explicitly convert
```

## Summary: Key Design Differences from C/C++

| Feature | C/C++ | Go | Rationale |
|---------|-------|-----|-----------|
| **Headers** | Required | None | Faster compilation, simpler |
| **Semicolons** | Required | Optional | Cleaner code |
| **Initialization** | Undefined | Zero values | Safety |
| **Visibility** | Keywords (public/private) | Case (uppercase/lowercase) | Simpler |
| **Conversions** | Implicit | Explicit | Safety, clarity |
| **Type syntax** | Type before name | Name before type | Readability |
| **Memory** | Manual (malloc/free) | Garbage collected | Safety, simplicity |
| **Concurrency** | pthread library | Built-in goroutines | First-class feature |

## Next Steps

After mastering basic syntax, you'll learn:
- Type inference with `:=`
- Multiple return values
- Defer statements
- How Go's simplicity enables powerful patterns

The key insight: **Go deliberately removes features to improve software engineering at scale.**
""",
        "intermediate": """# Go Basics and Syntax - Intermediate Level

## Advanced Program Structure

### Multiple File Packages

**C/C++ approach:**
```cpp
// util.h
#ifndef UTIL_H
#define UTIL_H
void helper();
#endif

// util.cpp
#include "util.h"
void helper() { }

// main.cpp
#include "util.h"
int main() { helper(); }
```

**Go approach:**
```go
// util.go
package main

func helper() {
    // Implementation
}

// main.go
package main

func main() {
    helper()  // Can call directly, same package
}
```

### Design Rationale: Package Organization

**Why Go's package model differs from C++ namespaces:**

1. **File-level organization**:
   - C++: One namespace can span many headers
   - Go: One package per directory (all files in directory)
   
2. **No circular dependencies**:
   - C++: Allowed with forward declarations
   - Go: Compile error (forces better design)

3. **Initialization order**:
   - C++: Undefined across translation units
   - Go: Deterministic based on dependency graph

4. **Internal packages**:
```go
// myproject/internal/secret/secret.go
package secret  // Can only be imported by myproject/*

// myproject/internal/helper.go  
package helper  // Also internal to myproject
```

This feature doesn't exist in C++. Benefits:
- Prevents external dependencies on internal code
- Refactor internals without breaking external users
- Clear API boundaries

### Build Tags and Conditional Compilation

**C/C++ preprocessor:**
```cpp
#ifdef WINDOWS
    #include <windows.h>
#elif defined(LINUX)
    #include <unistd.h>
#endif

#if DEBUG
    #define LOG(x) cout << x
#else
    #define LOG(x)
#endif
```

**Go build tags:**
```go
// +build linux darwin

package mypackage

// This file only compiled on Linux and macOS
```

```go
// +build !windows

package mypackage

// This file compiled on all platforms except Windows
```

### Design Rationale: Build Tags vs Preprocessor

**Why Go replaced preprocessor with build tags:**

1. **No macro system**: Go deliberately has no macros
   - Macros cause debugging nightmares
   - Hide control flow
   - Can create illegal syntax

2. **File-level granularity**: 
   - C++: `#ifdef` sprinkled throughout code
   - Go: Entire files included/excluded
   - Result: Cleaner code, easier to read

3. **Standard tool support**:
```bash
go build -tags debug  # Build with debug tag
```

4. **Platform-specific files**:
```go
// file_linux.go     - Linux only
// file_windows.go   - Windows only  
// file_darwin.go    - macOS only
```

Automatic based on filename, no tags needed.

**What you lose from C++ preprocessor:**
- Text replacement macros
- Computed constants
- Token pasting
- Include guards (not needed anyway)

**What you gain:**
- No hidden code
- Clear build logic
- Better refactoring
- Easier testing

### Package Initialization

**C++ static initialization:**
```cpp
// Undefined order across translation units!
static int x = expensiveComputation();
static MyClass obj;  // Constructor runs before main()
```

**Go init functions:**
```go
var cache map[string]string

func init() {
    cache = make(map[string]string)
    cache["key"] = loadFromDatabase()
}

func init() {
    // Can have multiple init functions
    // Run in order declared in file
}
```

### Design Rationale: Init Functions

**Why Go's init() is better than C++ static initialization:**

1. **Deterministic order**:
   - Within a file: Declaration order
   - Across files: Alphabetical by filename
   - Across packages: Dependency order

2. **No static initialization fiasco**:
```cpp
// C++ problem:
// file1.cpp
static int x = 10;

// file2.cpp  
static int y = x + 5;  // What if file2 is initialized before file1?
```

Go prevents this entirely.

3. **Explicit initialization**:
   - C++: Hidden in constructors
   - Go: Clear init() functions

4. **Testing-friendly**:
```go
func TestInit() {
    // init() already ran
    // Tests run in predictable state
}
```

## Type Aliasing and Definitions

**C/C++ typedef:**
```cpp
typedef unsigned long ulong;
typedef int (*funcptr)(int, int);

using ulong = unsigned long;  // C++11
using funcptr = int(*)(int, int);
```

**Go type aliases and definitions:**
```go
// Type alias (Go 1.9+)
type MyInt = int  // MyInt and int are identical

// Type definition (new type)
type MyInt int    // MyInt is distinct from int
```

### Design Rationale: Type Aliases vs Definitions

**Why Go distinguishes between alias and definition:**

1. **Type safety with definitions**:
```go
type Celsius float64
type Fahrenheit float64

var temp1 Celsius = 100
var temp2 Fahrenheit = 100

// temp1 = temp2  // Compile error! Different types
temp1 = Celsius(temp2)  // Must convert explicitly
```

This prevents mixing incompatible units, unlike C++:
```cpp
typedef float Celsius;
typedef float Fahrenheit;

Celsius c = 100;
Fahrenheit f = 100;
c = f;  // No error! Just floats
```

2. **Methods on custom types**:
```go
type Age int

func (a Age) IsAdult() bool {
    return a >= 18
}

// Can't add methods to builtin int
```

3. **Gradual code migration**:
```go
type MyInt = int  // Alias for refactoring

// Later, change to new type:
type MyInt int    // Now distinct type
```

## Constants

**C/C++ constants:**
```cpp
#define MAX_SIZE 100        // Preprocessor (no type)
const int MAX_SIZE = 100;   // Typed constant
enum { MAX_SIZE = 100 };    // Enum constant

constexpr int square(int x) { return x * x; }  // C++11
```

**Go constants:**
```go
const MaxSize = 100         // Untyped constant
const MaxSize int = 100     // Typed constant
const (
    A = 1
    B = 2
    C = 3
)
```

### Design Rationale: Untyped Constants

**Go's untyped constants are unique:**

```go
const x = 42  // Untyped constant

var i int = x      // Works: x becomes int
var f float64 = x  // Works: x becomes float64
var c complex128 = x  // Works: x becomes complex128
```

**Why this matters:**

1. **High precision**:
```go
const Pi = 3.14159265358979323846264338327950288419716939937510

var f32 float32 = Pi  // Truncated to float32 precision
var f64 float64 = Pi  // Full float64 precision
```

Constants are represented with 256 bits of precision internally.

2. **No type conversion needed**:
```cpp
// C++: Need different constants for different types
const int MaxInt = 100;
const long MaxLong = 100L;
const float MaxFloat = 100.0f;
```

```go
// Go: One constant works everywhere
const Max = 100

var i int = Max
var l int64 = Max  
var f float64 = Max
```

3. **Compile-time computation**:
```go
const (
    _  = iota             // 0 (ignored)
    KB = 1 << (10 * iota) // 1 << 10 = 1024
    MB                     // 1 << 20 = 1048576
    GB                     // 1 << 30
    TB                     // 1 << 40
)
```

### Iota Enumerator

**C++ enums:**
```cpp
enum Day {
    SUNDAY = 0,
    MONDAY = 1,
    TUESDAY = 2,
    // ... repetitive
};

enum Flag {
    READ   = 1 << 0,  // 1
    WRITE  = 1 << 1,  // 2
    EXECUTE = 1 << 2,  // 4
};
```

**Go iota:**
```go
type Day int

const (
    Sunday Day = iota  // 0
    Monday             // 1
    Tuesday            // 2
    // ... automatic
)

const (
    Read   = 1 << iota  // 1
    Write               // 2
    Execute             // 4
)
```

### Design Rationale: Iota

**Why iota is better than C++ enums:**

1. **Less repetition**: Values automatically increment
2. **Flexible expressions**: Any expression can use iota
3. **No implicit conversions**: Day and Flag are distinct types
4. **Can create complex patterns**:

```go
const (
    _           = iota // ignore first value
    KB ByteSize = 1 << (10 * iota)
    MB
    GB
    TB
    PB
)
```

## Import Variants

**Standard imports:**
```go
import "fmt"              // Use as fmt.Println
import f "fmt"            // Alias: f.Println
import . "fmt"            // Dot import: Println (discouraged)
import _ "image/png"      // Side-effect only (runs init())
```

### Design Rationale: Import Variants

**Aliasing:**
```go
import (
    "crypto/rand"
    "math/rand"
)

// Without alias: can't use both!
// With alias:
import (
    cryptorand "crypto/rand"
    mathrand "math/rand"
)
```

**Blank identifier for side effects:**
```go
import _ "image/png"  // Registers PNG decoder

// Allows image.Decode() to handle PNG
img, _ := image.Decode(file)
```

**Why dot imports are discouraged:**
```go
import . "fmt"

Println("Hello")  // Where does Println come from?
```

Goes against Go's explicitness principle. Only use in tests.

## Code Organization Best Practices

### Project Structure

**Go standard layout:**
```
myproject/
├── cmd/
│   ├── myapp/
│   │   └── main.go         // Application entry point
│   └── helper/
│       └── main.go         // Utility command
├── internal/
│   └── secret/             // Internal packages
│       └── secret.go
├── pkg/
│   └── public/             // Public library code
│       └── public.go
├── go.mod                  // Module definition
└── README.md
```

### Design Rationale: Project Layout

**Why this structure:**

1. **cmd/**: Multiple binaries from one project
2. **internal/**: Cannot be imported by external projects
3. **pkg/**: Can be imported by external projects
4. **Flat is better than nested**: Unlike Java's deep hierarchies

**Compared to C++:**
```
cpp-project/
├── include/        // Public headers
│   └── mylib/
│       └── public.h
├── src/           // Implementation
│   └── mylib/
│       └── public.cpp
└── tests/         // Tests separate
```

Go integrates tests with code:
```
mypackage/
├── mycode.go
└── mycode_test.go  // Test file alongside code
```

## Documentation

**C++ Doxygen:**
```cpp
/**
 * @brief Adds two numbers
 * @param a First number
 * @param b Second number
 * @return Sum of a and b
 */
int add(int a, int b) {
    return a + b;
}
```

**Go godoc:**
```go
// Add returns the sum of a and b.
//
// Example usage:
//     result := Add(2, 3)  // result is 5
func Add(a, b int) int {
    return a + b
}
```

### Design Rationale: Documentation

**Why Go's approach is simpler:**

1. **No special syntax**: Just comments
2. **Tool generates docs**: `go doc` or pkg.go.dev
3. **Examples are runnable**:

```go
// In file: example_test.go
func ExampleAdd() {
    fmt.Println(Add(2, 3))
    // Output: 5
}
```

4. **First sentence is summary**: Displayed in listings
5. **Complete sentences**: Forces clarity

## Name Visibility Gotchas

```go
type MyStruct struct {
    PublicField  int  // Exported
    privateField int  // Not exported
}

// External package:
s := other.MyStruct{}
s.PublicField = 42   // OK
// s.privateField = 42  // Compile error
```

**JSON encoding example:**
```go
type Config struct {
    Timeout int  // Exported: will be in JSON
    secret  int  // NOT exported: ignored by JSON
}

// JSON: {"Timeout": 30}
```

**Common pitfall:**
```go
type config struct {  // Lowercase type name
    Timeout int
}

// Other packages can't use config type at all!
// Even though Timeout is uppercase
```

## Summary: Intermediate Concepts

- **Package organization**: One package per directory, no circular imports
- **Build tags**: File-level conditional compilation
- **Init functions**: Deterministic initialization order
- **Type definitions**: Create distinct types for safety
- **Untyped constants**: High precision, flexible usage
- **Iota**: Automatic enumeration
- **Import aliasing**: Handle name conflicts
- **Documentation**: Simple comments, powerful tools

These features enable:
- Large-scale codebases
- Clear dependencies
- Type safety
- Maintainable code

Next level: Advanced patterns using these fundamentals.
""",
        "advanced": """# Go Basics and Syntax - Advanced Level

## Deep Dive: Compilation Model

### Comparison with C/C++

**C/C++ compilation phases:**
1. Preprocessing: Expand macros, includes
2. Compilation: Source → assembly
3. Assembly: Assembly → object files
4. Linking: Object files → executable

**Go compilation:**
1. Parsing: Source → AST (all files in package)
2. Type checking: Verify types across package
3. Compilation: AST → machine code
4. Linking: Combine packages → executable

### Why Go Compiles Faster

**Key differences from C++:**

1. **No preprocessor**:
   - C++: Re-parse headers in every translation unit
   - Go: Parse each file once

2. **Explicit dependencies**:
   - C++: Includes can pull in thousands of headers
   - Go: Import only what's explicitly listed

3. **Non-transitive dependencies**:
   - C++: Including A.h includes everything A.h includes
   - Go: Importing A doesn't import A's imports

4. **Separate compilation**:
   - C++: Template instantiation happens per-translation-unit
   - Go: Each package compiled independently

5. **Export data**:
   - C++: Re-parse declarations in headers
   - Go: Read binary export data from compiled package

**Example of the difference:**

```cpp
// C++: iostream includes ~100 other headers
#include <iostream>

// Each .cpp file that includes iostream:
// - Parses all ~100 headers
// - Processes ~30,000 lines of code
// - Takes ~0.5 seconds just for includes
```

```go
// Go: fmt is pre-compiled
import "fmt"

// Compiler reads binary export data:
// - ~100 exported identifiers
// - Takes ~0.01 seconds
```

### Package Export Format

When you compile a Go package, the compiler generates:
1. Object code (executable machine code)
2. Export data (what other packages need to import this)

**Export data includes:**
- Public type definitions
- Public function signatures
- Public constants
- Inline function bodies (for optimization)

**Does NOT include:**
- Private (unexported) declarations
- Function implementations (except inlineable ones)
- Comments or formatting

This is fundamentally different from C++ headers which include everything.

## Advanced Type System

### Type Identity and Assignability

**Go's strict type rules:**

```go
type Celsius float64
type Fahrenheit float64
type Kelvin float64

var c Celsius = 100
var f Fahrenheit = 100
var k Kelvin = 100

// All three are float64, but:
// c = f  // Compile error!
// c = k  // Compile error!

// Must explicitly convert:
c = Celsius(f)  // OK
```

**Why this matters in large codebases:**

```go
// user.go
type UserID int

// order.go  
type OrderID int

func GetUser(id UserID) User { ... }
func GetOrder(id OrderID) Order { ... }

var uid UserID = 123
var oid OrderID = 456

// GetUser(oid)  // Compile error! Can't pass OrderID as UserID
// This prevents bugs at compile time
```

**C++ doesn't provide this:**
```cpp
typedef int UserID;
typedef int OrderID;

User GetUser(UserID id);
Order GetOrder(OrderID id);

UserID uid = 123;
OrderID oid = 456;

GetUser(oid);  // No error! Just ints
// Bug waiting to happen
```

### Named vs Unnamed Types

**Named types:**
```go
type MyInt int
```

**Unnamed types:**
```go
var x struct {
    name string
    age  int
}
```

**Assignability rules:**

```go
type Point struct {
    X, Y int
}

var p1 Point
var p2 struct {
    X, Y int
}

// p1 = p2  // Compile error! Different types
// Even though they have identical structure

// Must convert:
p1 = Point(p2)  // OK, underlying types are identical
```

**Structural typing for interfaces:**

```go
type Writer interface {
    Write([]byte) (int, error)
}

type MyWriter struct {}
func (m MyWriter) Write(b []byte) (int, error) { ... }

var w Writer = MyWriter{}  // OK, implements implicitly
```

### Design Rationale: Named Type Distinctions

**Why Go makes named types distinct:**

1. **Type safety**: Prevent mixing incompatible concepts
2. **Documentation**: Type name conveys meaning
3. **Methods**: Can attach methods to named types
4. **Refactoring**: Change underlying type without changing API

**Example of safe refactoring:**
```go
// Version 1
type UserID int

// Version 2 - need more than 32 bits
type UserID int64  // All code using UserID still works

// Version 3 - need string IDs
type UserID string  // Compiler finds all places needing updates
```

## Advanced Constants

### Constant Expressions

Go constants can use limited compile-time computations:

```go
const (
    // Basic arithmetic
    Size = 10 * 20  // 200
    
    // Bit operations
    Mask = (1 << 8) - 1  // 255
    
    // Boolean logic
    Valid = true && !false  // true
    
    // String operations
    Greeting = "Hello, " + "World!"
    
    // Type conversions
    Pi32 = float32(3.14159265358979323846)
)
```

**What you CANNOT do:**
```go
const (
    // Banned = len("hello")  // Error: len() is not allowed
    // Time = time.Now()       // Error: function calls not allowed
    // Size = make([]int, 10)  // Error: runtime allocation not allowed
)
```

**Why these restrictions:**
- Constants must be computed at compile time
- No runtime dependencies
- Reproducible builds
- Fast compilation

### High-Precision Constants

```go
const (
    // Exact rational arithmetic
    Third = 1.0 / 3.0
    
    // Stays precise until assigned to variable
    var f float64 = Third  // Now rounded to float64 precision
)
```

**Precision comparison:**

```cpp
// C++
const double third = 1.0 / 3.0;  // Rounded immediately
```

```go
// Go
const Third = 1.0 / 3.0  // Exact until used

const Result = Third * 3  // Exactly 1.0

var d float64 = Third * 3  // Computed at float64 precision
```

### Iota Advanced Patterns

**Bit flags:**
```go
type Permission uint

const (
    Read Permission = 1 << iota  // 1
    Write                         // 2
    Execute                       // 4
    Admin                         // 8
)

// Usage:
func hasPermission(user Permission, required Permission) bool {
    return user&required == required
}
```

**Skip values:**
```go
const (
    _           = iota  // Skip 0
    First              // 1
    Second             // 2
    _                  // Skip 3
    Fourth             // 4
)
```

**Complex expressions:**
```go
const (
    _        = iota                   // 0
    _                                 // 1
    Century  = iota * 100             // 200
    Millenium                         // 300
    _                                 // 400
    HalfMilennium = iota * 100 / 2   // 250
)
```

**Reset iota:**
```go
const (
    A = iota  // 0
    B         // 1
)

const (
    C = iota  // 0 - iota resets in new const block
    D         // 1
)
```

## Advanced Package Concepts

### Vendor Directory

**Problem in large projects:**
- Dependencies can change
- Need reproducible builds
- Want to lock dependency versions

**Go solution (pre-modules):**
```
myproject/
├── vendor/
│   └── github.com/
│       └── other/
│           └── pkg/
└── main.go
```

**With modules (Go 1.11+):**
```
myproject/
├── go.mod    // Dependency versions
├── go.sum    // Cryptographic checksums
└── main.go
```

### Internal Packages

**Special rule:**
```
myproject/
├── internal/
│   └── secret/
│       └── secret.go  // Can only be imported by myproject
├── cmd/
│   └── app/
│       └── main.go    // Can import internal/secret
└── go.mod
```

```go
// Another project:
// import "github.com/me/myproject/internal/secret"  // Compile error!
```

**Why this matters:**

1. **Clear API boundaries**: Internal code is truly internal
2. **Refactoring freedom**: Change internals without breaking others
3. **Semantic versioning**: Only public API is versioned
4. **Better than C++ private**: Enforced at import time, not compile time

### Package vs Internal Tests

**External tests (_test package):**
```go
// mypackage/code.go
package mypackage

func exported() int { return privateHelper() }
func privateHelper() int { return 42 }
```

```go
// mypackage/code_test.go
package mypackage_test  // Different package!

import "mypackage"

func TestExported(t *testing.T) {
    // Can only access exported functions
    mypackage.exported()
    // mypackage.privateHelper()  // Compile error
}
```

**Internal tests (same package):**
```go
// mypackage/code_internal_test.go
package mypackage  // Same package

func TestPrivateHelper(t *testing.T) {
    // Can access unexported functions
    privateHelper()
}
```

**Why both exist:**

1. **External tests**: Test public API (what users see)
2. **Internal tests**: Test implementation details
3. **Forces good API design**: If hard to test externally, API might be bad

## Blank Identifier Deep Dive

The blank identifier `_` is special:

**Ignore values:**
```go
value, _ := functionReturningTwo()  // Ignore second return
_, err := functionReturningTwo()    // Ignore first return

for _, item := range slice {        // Ignore index
}

for range slice {                   // Ignore both index and value
}
```

**Import for side effects:**
```go
import _ "image/png"  // Runs init(), doesn't use package
```

**Ensure interface implementation:**
```go
type MyWriter struct{}

func (m *MyWriter) Write(b []byte) (int, error) { ... }

// Compile-time check that MyWriter implements io.Writer
var _ io.Writer = (*MyWriter)(nil)

// If MyWriter doesn't implement io.Writer, compile error
```

**Why the last pattern is powerful:**

```go
// In C++, you find out at runtime if you implemented interface correctly
// In Go, compile-time check:

type Stringer interface {
    String() string
}

type MyType struct{}

// Forgot to implement String()

var _ Stringer = (*MyType)(nil)  // Compile error!
// MyType doesn't implement Stringer
```

## Build Constraints Advanced

**Multiple conditions:**
```go
// +build linux,386 darwin,!cgo

// This means: (linux AND 386) OR (darwin AND NOT cgo)
```

**Common patterns:**
```go
// +build ignore

// This file is never built, used for examples or templates
```

**Go 1.17+ syntax:**
```go
//go:build linux && 386 || darwin && !cgo

// More readable boolean expressions
```

**File name suffixes:**
```
file_linux_amd64.go      // Linux AND amd64
file_windows.go          // Windows (any architecture)
file_test.go             // Test files
file_darwin_arm64.go     // macOS on ARM
```

## Compiler Directives

**Inline hints:**
```go
//go:noinline
func expensiveFunction() {
    // Prevent inlining
}
```

**No bounds checking:**
```go
//go:nobounds
func unsafeAccess(slice []int, i int) int {
    return slice[i]  // No bounds check (dangerous!)
}
```

**Link names (internal use):**
```go
//go:linkname localname importpath.name
// Link to another package's private function (very dangerous)
```

**Why these exist:**
- Runtime package implementation
- Performance-critical code
- Low-level system interaction

**Warning**: Using these makes your code fragile and non-portable.

## Empty Interface Mechanics

```go
interface{}  // Empty interface, matches any type
```

**How it works internally:**

```go
var x interface{} = 42

// Runtime representation:
type eface struct {
    _type *_type        // Type information
    data  unsafe.Pointer // Pointer to actual data
}
```

**Type switches:**
```go
func process(x interface{}) {
    switch v := x.(type) {
    case int:
        fmt.Println("Integer:", v)
    case string:
        fmt.Println("String:", v)
    case nil:
        fmt.Println("Nil")
    default:
        fmt.Printf("Unknown type: %T\n", v)
    }
}
```

**Performance implications:**

```go
// Direct call (fast):
func add(a, b int) int { return a + b }

// Through interface (slower):
func addInterface(a, b interface{}) interface{} {
    return a.(int) + b.(int)  // Type assertion overhead
}
```

**Why slower:**
1. Boxing: Put value on heap
2. Type information: Store type metadata
3. Indirection: Extra pointer dereference
4. Type assertions: Runtime type checks

## Optimization Insights

### Escape Analysis

Go compiler determines if variable escapes to heap:

```go
// Stays on stack (fast):
func stackAlloc() int {
    x := 42
    return x
}

// Escapes to heap (slower):
func heapAlloc() *int {
    x := 42
    return &x  // x escapes - pointer returned
}
```

**Check with:**
```bash
go build -gcflags=-m
```

### Inlining

Small functions are inlined automatically:

```go
func add(a, b int) int {  // Usually inlined
    return a + b
}

func complex() {
    // Many lines...
    // Won't be inlined
}
```

**Check inlining decisions:**
```bash
go build -gcflags=-m
```

### Constant Folding

```go
const Size = 100

var array [Size]int  // Size must be constant

// Compiler computes at compile time:
const Result = 10 * 20 + 5  // = 205
```

## Summary: Advanced Concepts

**Compilation:**
- No preprocessor = fast compilation
- Explicit dependencies = clear build
- Export data = efficient imports

**Type system:**
- Named types are distinct = type safety
- Structural typing for interfaces = flexibility
- No implicit conversions = clarity

**Constants:**
- Compile-time computation = zero runtime cost
- High precision = accurate math
- Iota patterns = maintainable enums

**Packages:**
- Internal packages = clear boundaries
- Vendor/modules = reproducible builds
- No circular imports = better architecture

**Optimization:**
- Escape analysis = efficient allocation
- Inlining = fast function calls
- Constant folding = zero-cost abstractions

These advanced features enable Go to be:
- Fast to compile
- Fast to run
- Easy to maintain
- Safe by default

The key insight: **Go's simplicity at the surface enables sophisticated optimization underneath.**
"""
    }
}

# Note: Due to length, I'll create a function to generate similar content for all topics
# This is just the template structure

def create_topic_content(topic_num, topic_name, topic_title):
    """Generate comprehensive theory content for a topic"""
    
    # Create claude.md for topic context
    claude_md = f"""# {topic_title} - Topic Context

This directory contains comprehensive Go theory for **{topic_title}** with detailed comparisons to C/C++ and design rationale.

## Directory Structure

- `basic/` - Fundamental concepts with C/C++ comparisons
- `intermediate/` - Advanced usage patterns and design decisions
- `advanced/` - Deep dives into implementation and optimization

## Learning Approach

Each subdirectory contains:
- `theory.md` - Detailed theoretical explanations
- `examples/` - Practical code examples
- Comparisons to C/C++ throughout
- Design rationale for Go's choices

## How to Use This Context

When working with Claude:
1. Open this topic directory as your working context
2. Reference the theory files as needed
3. Run examples to understand concepts
4. Ask Claude questions specific to this topic

## Key Questions to Explore

- Why did Go choose this design vs C/C++?
- What problems does this solve?
- What are the trade-offs?
- How does this enable better software engineering?

Start with `basic/theory.md` and progress through the levels.
"""
    
    return claude_md

def create_all_topics():
    """Create comprehensive structure for all topics"""
    
    base_path = "/media/usb/anrai/golang/go_theory"
    
    for topic in TOPICS:
        topic_dir = f"{topic['num']}_{topic['name']}"
        topic_path = os.path.join(base_path, topic_dir)
        
        # Create directories
        os.makedirs(os.path.join(topic_path, "basic", "examples"), exist_ok=True)
        if topic.get('needs_intermediate', True):
            os.makedirs(os.path.join(topic_path, "intermediate", "examples"), exist_ok=True)
        if topic.get('needs_advanced', True):
            os.makedirs(os.path.join(topic_path, "advanced", "examples"), exist_ok=True)
        
        # Create claude.md
        claude_content = create_topic_content(topic['num'], topic['name'], topic['title'])
        with open(os.path.join(topic_path, "claude.md"), 'w') as f:
            f.write(claude_content)
        
        print(f"Created structure for {topic['title']}")

if __name__ == "__main__":
    create_all_topics()
    print("\nAll topic structures created!")
    print("Now run the comprehensive content generator...")
