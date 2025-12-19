#!/usr/bin/env python3
"""
Comprehensive Go Theory Generator
Creates detailed theory files for all Go topics with C/C++ comparisons and design rationale
"""

import os
import sys

def create_theory_file(topic_path, level, content):
    """Create a theory.md file with the given content"""
    filepath = os.path.join(topic_path, level, "theory.md")
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    
    with open(filepath, 'w') as f:
        f.write(content)
    
    print(f"✓ Created: {filepath}")

def generate_all_theories():
    """Generate all theory files"""
    
    # Topic 01: Basics and Syntax
    print("\n=== Generating Topic 01: Basics and Syntax ===")
    
    # Already created basic, now create intermediate and advanced
    
    intermediate_01 = """# Go Basics and Syntax - Intermediate Level

## Overview
This covers package organization, visibility rules, build tags, and more advanced syntax features.

---

## 1. Package Organization

### Package Structure
```go
// File: myapp/utils/strings.go
package utils

import "strings"

// Exported function
func Capitalize(s string) string {
    return strings.ToUpper(s)
}

// unexported helper
func helper() {
    // only visible within package
}
```

### C/C++ Comparison
```cpp
// header.h
#ifndef HEADER_H
#define HEADER_H

class Utils {
public:
    static std::string Capitalize(const std::string& s);
private:
    static void helper();
};

#endif
```

### Design Rationale

**Package as Compilation Unit**
- **Why**: All files in a package share the same namespace
- **C/C++ Difference**: Each .cpp file is independent; must include headers
- **Benefit**: No need to declare functions before use within package
- **Trade-off**: All files must agree on package name

**No Circular Imports**
- **Why**: Import graph must be acyclic (DAG)
- **Enforced**: Compile-time error if circular import detected
- **C/C++ Problem**: Header files can have circular dependencies (solved with forward declarations)
- **Go Solution**: Forces better architecture - if A needs B and B needs A, extract interface to C

**Internal Packages**
```go
// Directory structure:
// myapp/
//   internal/
//     helper/
//       helper.go    // Can only be imported by myapp or its subpackages
```

- **Why**: Enforce encapsulation at directory level
- **Design Choice**: Prevent external packages from depending on internal implementation
- **C/C++ Comparison**: No equivalent; relies on documentation/"do not use" comments

---

## 2. Multiple Files in Package

### How It Works
```go
// File: math/add.go
package math

func Add(a, b int) int {
    return a + b
}

// File: math/multiply.go
package math

func Multiply(a, b int) int {
    return a * b
}

// File: math/helpers.go
package math

func helper() int {
    // visible to add.go and multiply.go
    return 42
}
```

### Design Rationale

**Shared Package Namespace**
- **Why**: Split large packages across files without imports
- **C/C++ Difference**: Would need headers and forward declarations
- **Benefit**: Natural code organization by functionality
- **Convention**: Separate concerns (types in one file, methods in another)

**No Header Files**
- **Why**: Each source file is self-contained with imports
- **C/C++ Problem**: Header duplication, include order dependencies, header guards
- **Go Solution**: Compiler handles dependencies through imports

---

## 3. Init Functions

### Syntax
```go
package database

import "database/sql"

var db *sql.DB

func init() {
    // Runs automatically before main()
    // Runs once per package
    db, _ = sql.Open("postgres", "connection_string")
}

func init() {
    // Can have multiple init functions
    // Execute in order of appearance
    setupLogging()
}
```

### C/C++ Comparison
```cpp
// C++ has global constructors
class DatabaseInitializer {
public:
    DatabaseInitializer() {
        // Runs before main(), but order between translation units is undefined!
        initDatabase();
    }
};

DatabaseInitializer globalInit;  // Static initialization
```

### Design Rationale

**Why init()?**
- **Purpose**: Package initialization (open connections, register drivers, etc.)
- **Timing**: After all variable initialization, before main()
- **Order**: Well-defined (import order determines execution order)

**C/C++ Problem**:
- Static initialization order fiasco (undefined order across translation units)
- No control over initialization timing
- Can lead to bugs when global A depends on global B

**Go Solution**:
- Deterministic order: imports first, then variable declarations, then init()
- Multiple init() in same file: run in order
- Multiple packages: run in import dependency order

**Best Practices**:
- Keep init() simple
- Avoid init() if possible (prefer explicit initialization)
- Don't rely on side effects from imported packages

---

## 4. Build Tags (Conditional Compilation)

### Syntax
```go
//go:build linux
// +build linux

package myapp

func platformSpecific() {
    // Linux-specific code
}
```

```go
//go:build windows
// +build windows

package myapp

func platformSpecific() {
    // Windows-specific code
}
```

### C/C++ Comparison
```cpp
#ifdef _WIN32
    // Windows code
#elif __linux__
    // Linux code
#elif __APPLE__
    // macOS code
#endif
```

### Design Rationale

**Why Build Tags Instead of #ifdef?**
- **Go Approach**: Separate files for different platforms
- **C/C++ Approach**: Preprocessor conditionals within files
- **Design Choice**: Cleaner code - no mixed platform code in one file

**Advantages**:
1. **No Preprocessor**: Simpler language (no #ifdef maze)
2. **Whole File**: Entire file is included or excluded
3. **Multiple Conditions**: Can combine (linux AND amd64)
4. **Tooling**: `go build` handles automatically

**Common Build Tags**:
```go
//go:build (linux || darwin) && amd64
//go:build !cgo
//go:build integration
```

**Tag Combinations**:
- AND: `&&` or space
- OR: `||` or comma
- NOT: `!`

---

## 5. Blank Identifier (_)

### Usage
```go
// Ignore return values
value, _ := functionThatReturnsError()

// Import for side effects only
import _ "database/sql/driver"  // Runs init() but doesn't use exports

// Enforce interface implementation at compile time
var _ io.Reader = (*MyType)(nil)

// Ignore loop variables
for _, value := range slice {
    // Don't need index
}
```

### C/C++ Comparison
```cpp
// C++17: structured bindings with [[maybe_unused]]
auto [value, [[maybe_unused]] error] = function();

// Or just ignore
auto value = function().first;  // If returning std::pair
```

### Design Rationale

**Why Blank Identifier?**
- **Unused Variables**: Go compiler error on unused variables
- **Problem**: Sometimes you don't need all return values
- **Solution**: Explicit ignore with `_`

**Design Philosophy**:
- **Explicit over implicit**: Must deliberately ignore values
- **No Silent Bugs**: Can't accidentally ignore errors by forgetting variable
- **Trade-off**: More verbose than C/C++, but safer

**Import for Side Effects**:
```go
import _ "net/http/pprof"  // Registers debug handlers
```
- **Why**: Package init() registers itself, but you don't call its functions
- **C/C++ Comparison**: No equivalent (would need explicit init call)

---

## 6. Type Assertions and Type Switches

### Type Assertions
```go
var i interface{} = "hello"

// Type assertion
s := i.(string)        // Panics if wrong type
s, ok := i.(string)    // Safe: ok is false if wrong type

if str, ok := i.(string); ok {
    fmt.Println(str)
}
```

### Type Switch
```go
func describe(i interface{}) {
    switch v := i.(type) {
    case int:
        fmt.Printf("Integer: %d\n", v)
    case string:
        fmt.Printf("String: %s\n", v)
    case bool:
        fmt.Printf("Boolean: %t\n", v)
    default:
        fmt.Printf("Unknown type: %T\n", v)
    }
}
```

### C/C++ Comparison
```cpp
// C++: dynamic_cast (only for polymorphic types)
class Base { virtual ~Base() {} };
class Derived : public Base {};

Base* b = new Derived();
Derived* d = dynamic_cast<Derived*>(b);
if (d != nullptr) {
    // Cast succeeded
}

// Or typeid for runtime type info
if (typeid(*b) == typeid(Derived)) {
    // ...
}
```

### Design Rationale

**Why Type Assertions?**
- **Interface Values**: Can hold any concrete type
- **Need**: Sometimes must extract concrete type
- **Safety**: Two forms - panic on error or return bool

**Go vs C++ RTTI**:
- **C++ RTTI**: Only works with polymorphic types (virtual functions)
- **Go**: Works with all interface values
- **C++ Cost**: RTTI has runtime overhead, often disabled
- **Go Cost**: Interfaces always have type information

**Type Switch Design**:
- **Unique to Go**: No equivalent in C/C++
- **Pattern Matching**: Switch on type, not value
- **Variable Binding**: Each case gets correctly-typed variable

---

## 7. Package Aliases

### Syntax
```go
import (
    "fmt"
    "math/rand"
    
    mrand "math/rand"      // Alias
    crand "crypto/rand"    // Avoid conflict
    
    . "fmt"                // Dot import (use with caution!)
)

func example() {
    mrand.Intn(100)        // math/rand
    crand.Read(buffer)     // crypto/rand
    
    Println("hello")       // fmt.Println via dot import
}
```

### Design Rationale

**Import Aliases**
- **Problem**: Package name conflicts
- **Solution**: Rename at import site
- **C/C++ Comparison**: C++ namespace aliases (`namespace m = math;`)

**Dot Import (.)** - Controversial!
```go
import . "fmt"

func main() {
    Println("No package prefix needed")
}
```

**Why Discouraged**:
- **Namespace Pollution**: Unclear where identifiers come from
- **Valid Use**: Testing (test file imports package being tested with dot)
- **Philosophy**: Explicit is better than implicit

---

## 8. Embedding and Composition

### Embedding Structs
```go
type Engine struct {
    HP int
}

func (e Engine) Start() {
    fmt.Println("Engine starting...")
}

type Car struct {
    Engine  // Embedded (anonymous field)
    Brand string
}

func main() {
    c := Car{
        Engine: Engine{HP: 200},
        Brand: "Toyota",
    }
    
    c.Start()      // Promoted from Engine
    c.Engine.Start()  // Or explicit
}
```

### C/C++ Comparison
```cpp
// C++: Inheritance
class Engine {
public:
    int HP;
    void Start() {
        std::cout << "Engine starting..." << std::endl;
    }
};

class Car : public Engine {  // Inheritance
public:
    std::string Brand;
};

int main() {
    Car c;
    c.HP = 200;
    c.Start();  // Inherited method
}
```

### Design Rationale

**Why Embedding Instead of Inheritance?**
- **Go Philosophy**: "Composition over inheritance"
- **No Subtyping**: Car is not a "kind of" Engine
- **Method Promotion**: Engine's methods available on Car, but not polymorphic
- **Explicit**: Can always use `c.Engine.Start()` for clarity

**C++ Problems Go Avoids**:
1. **Diamond Problem**: Multiple inheritance ambiguity
2. **Fragile Base Class**: Changing base breaks derived classes
3. **Deep Hierarchies**: Complex inheritance trees are hard to understand
4. **Virtual Function Overhead**: V-tables and dynamic dispatch cost

**Go Solution**:
- **Interfaces for Polymorphism**: Not inheritance
- **Embedding for Code Reuse**: Not subtyping
- **Clear Semantics**: Always know which method is called

---

## 9. Constants and Iota

### Advanced Iota Usage
```go
type ByteSize float64

const (
    _           = iota  // ignore first value
    KB ByteSize = 1 << (10 * iota)  // 1 << 10 = 1024
    MB                                 // 1 << 20
    GB                                 // 1 << 30
    TB                                 // 1 << 40
    PB                                 // 1 << 50
)

type Flags uint

const (
    FlagRead Flags = 1 << iota  // 1
    FlagWrite                    // 2
    FlagExec                     // 4
)
```

### C/C++ Comparison
```cpp
// C++ enum
enum ByteSize {
    KB = 1024,
    MB = 1024 * 1024,
    GB = 1024 * 1024 * 1024,
    // Must calculate manually!
};

// Or with bitwise
enum Flags {
    FlagRead  = 1 << 0,
    FlagWrite = 1 << 1,
    FlagExec  = 1 << 2,
};
```

### Design Rationale

**Iota Design**
- **Purpose**: Generate related constants
- **Auto-increment**: Increments for each const in block
- **Reset**: Resets to 0 in each const block
- **Power**: Can use in expressions

**Why Iota?**
- **DRY Principle**: Don't repeat pattern
- **Error Prevention**: Easy to miss a number in sequence
- **Refactoring**: Can reorder without renumbering

**C/C++ Comparison**:
- C has enums, but less powerful
- Must manually calculate values
- Go's iota is more flexible (not just integers)

---

## Summary: Intermediate Go Features

| Feature | C/C++ | Go | Design Reason |
|---------|-------|-----|---------------|
| **Package Organization** | Headers + Sources | Package namespace | Faster compilation |
| **Circular Dependencies** | Possible (with forward declarations) | Compile error | Force better design |
| **Init Functions** | Static constructors (undefined order) | Deterministic init() | Predictable initialization |
| **Conditional Compilation** | #ifdef preprocessor | Build tags | Cleaner code separation |
| **Type Assertions** | dynamic_cast (limited) | Universal for interfaces | Flexible, type-safe |
| **Composition** | Inheritance (is-a) | Embedding (has-a) | Simplicity, avoid fragile base class |
| **Constants** | enum, #define | const + iota | Powerful, type-safe |

**Philosophy**: Go emphasizes explicit, simple solutions over C/C++'s flexible but complex features.
