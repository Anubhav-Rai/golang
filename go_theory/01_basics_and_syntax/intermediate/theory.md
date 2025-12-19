# Go Basics and Syntax - Intermediate Level

## Package Organization & Advanced Syntax

### 1. Multiple Files in Same Package

**Go Approach:**
```go
// File: utils/string.go
package utils
func ToUpper(s string) string { return strings.ToUpper(s) }

// File: utils/number.go  
package utils
func Double(n int) int { return n * 2 }
```

**C/C++ Comparison:**
```cpp
// string_utils.h
#ifndef STRING_UTILS_H
#define STRING_UTILS_H
std::string ToUpper(const std::string& s);
#endif

// string_utils.cpp
#include "string_utils.h"
std::string ToUpper(const std::string& s) { /* ... */ }
```

**Design Rationale:**
- **Why**: No header files needed - all files in package share namespace
- **C/C++ Problem**: Header/source split, include guards, forward declarations
- **Go Benefit**: Files can reference each other without imports
- **Trade-off**: All files must be in same directory with same package name

### 2. Init Functions

**Go:**
```go
var db *sql.DB

func init() {
    db, _ = sql.Open("postgres", "connstring")
}

func init() {  // Multiple init functions allowed
    setupLogging()
}
```

**C/C++:**
```cpp
// Global constructor - order undefined between translation units!
class Init {
public:
    Init() { setupDatabase(); }
};
Init globalInit;  // Runs before main(), but when exactly?
```

**Design Rationale:**
- **Why**: Predictable initialization order (imports → vars → init → main)
- **C/C++ Problem**: Static initialization order fiasco
- **Benefit**: Deterministic, no race conditions
- **Best Practice**: Keep init() simple, prefer explicit initialization

### 3. Build Tags

**Go:**
```go
//go:build linux
package myapp

func platformCode() { /* Linux version */ }
```

```go
//go:build windows  
package myapp

func platformCode() { /* Windows version */ }
```

**C/C++:**
```cpp
#ifdef _WIN32
    // Windows code
#elif __linux__
    // Linux code  
#endif
```

**Design Rationale:**
- **Why**: Separate files instead of preprocessor
- **C/C++ Problem**: #ifdef maze, hard to read
- **Benefit**: Clean separation, entire file included/excluded
- **Philosophy**: No preprocessor = simpler language

### 4. Internal Packages

**Directory Structure:**
```
myapp/
  internal/
    helper/  # Only importable by myapp/
  public/    # Importable by anyone
```

**Design Rationale:**
- **Why**: Enforce encapsulation at directory level
- **C/C++ Equivalent**: None - relies on documentation
- **Benefit**: Compiler-enforced internal APIs
- **Use Case**: Hide implementation details

### 5. Type Aliases vs Definitions

**Type Definition:**
```go
type MyInt int  // New type, not assignable to int
var x MyInt = 5
var y int = x  // ERROR!
```

**Type Alias:**
```go
type MyInt = int  // Alias, same as int
var x MyInt = 5
var y int = x  // OK!
```

**C/C++:**
```cpp
typedef int MyInt;  // Always an alias
using MyInt = int;  // C++11, also alias
```

**Design Rationale:**
- **Why Two Forms**: Type definitions create distinct types for type safety
- **C/C++ Limitation**: typedef is always an alias, no type safety
- **Example**: `type UserId int` vs `type RequestId int` - compiler prevents mixing
- **Alias Use**: Refactoring, gradual migrations

### 6. Blank Identifier Deep Dive

**Uses:**
```go
// Ignore return value
_, err := os.Open("file.txt")

// Import for side effects
import _ "net/http/pprof"  // Registers handlers in init()

// Enforce interface compliance
var _ io.Reader = (*MyType)(nil)  // Compile error if MyType doesn't implement io.Reader

// Unused loop variable
for _, value := range items { }
```

**Design Rationale:**
- **Why**: Unused variables are compile errors in Go
- **C/C++**: Unused variables just warnings (easily ignored)
- **Safety**: Must explicitly ignore values, prevents accidental bugs
- **Side Effect Imports**: Package init() runs even if nothing imported

### 7. Constant Expressions with iota

**Advanced iota:**
```go
type ByteSize uint64
const (
    _  = iota  // Skip zero
    KB ByteSize = 1 << (10 * iota)  // 1024
    MB                               // 1048576
    GB                               // 1073741824  
)

type Permission uint
const (
    Read Permission = 1 << iota  // 1
    Write                         // 2
    Execute                       // 4
)
```

**C/C++:**
```cpp
enum ByteSize {
    KB = 1024,
    MB = 1048576,        // Manual calculation
    GB = 1073741824,     // Error-prone!
};
```

**Design Rationale:**
- **Why iota**: Auto-generate related constants
- **Power**: Can use in expressions (unlike C enums)
- **Safety**: Compiler calculates, no human error
- **Pattern**: Common for bit flags, powers of 2

### 8. Visibility Rules Deep Dive

**Capitalization Determines Visibility:**
```go
package mylib

type PublicType struct {      // Exported
    PublicField int           // Exported
    privateField string       // Not exported
}

func PublicFunc() {}          // Exported
func privateFunc() {}         // Not exported
```

**C/C++:**
```cpp
class MyClass {
public:
    void PublicMethod();
private:
    void PrivateMethod();
protected:
    void ProtectedMethod();
friend class FriendClass;
};
```

**Design Rationale:**
- **Why Capitalization**: No keywords needed (public/private/protected)
- **Simplicity**: Only 2 levels (exported/unexported), not 4 (public/private/protected/friend)
- **Package-Level**: Encapsulation at package boundary, not class
- **C/C++ Complexity**: Protected inheritance, friend classes, complex access rules
- **Go Philosophy**: Simpler is better, even if less flexible

### 9. Package Documentation

**Go Convention:**
```go
// Package mathutil provides utility functions for mathematical operations.
// 
// This package includes helpers for common math tasks that are not in
// the standard library.
package mathutil

// Sqrt calculates the square root using Newton's method.
// It returns an error if x is negative.
func Sqrt(x float64) (float64, error) {
    // Implementation
}
```

**Tool Integration:**
```bash
go doc mathutil
go doc mathutil.Sqrt
```

**C/C++:**
```cpp
/**
 * @file mathutil.h
 * @brief Mathematical utility functions
 * @author John Doe
 */
 
/**
 * @brief Calculates square root
 * @param x Input value
 * @return Square root of x
 */
double Sqrt(double x);
```

**Design Rationale:**
- **Why**: Documentation is first-class language feature
- **C/C++**: Requires external tools (Doxygen) with special syntax
- **Benefit**: `go doc` built-in, standard format
- **Convention**: Comment directly above declaration
- **Philosophy**: Make documentation easy = people will do it

### Summary: Intermediate Concepts

| Feature | C/C++ | Go | Why Go's Way? |
|---------|-------|-----|---------------|
| Multi-file packages | Header + Source | Shared namespace | No headers, faster compile |
| Initialization | Undefined order | Deterministic init() | Prevent initialization bugs |
| Conditional Compilation | #ifdef | Build tags | Cleaner code |
| Visibility | Keywords | Capitalization | Simplicity |
| Type Safety | typedef (weak) | type vs alias | Strong typing option |
| Documentation | External tools | Built-in go doc | Standard, easy |

**Core Philosophy**: Reduce complexity, enforce best practices through language design.
