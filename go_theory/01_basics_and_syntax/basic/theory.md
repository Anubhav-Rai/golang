# Go Basics and Syntax: Basic Level

## Philosophy: Simplicity Through Deliberate Constraints

Go was designed by C veterans (Ken Thompson, Rob Pike, Robert Griesemer) who **intentionally rejected complexity**. Where C++ evolved by accretion (adding templates, RAII, move semantics, concepts), Go took a subtractive approach: what can we remove while building a practical systems language?

---

## 1. Package System: Rethinking Modular Compilation

### The C/C++ Problem

```c
// user.h
#ifndef USER_H
#define USER_H
struct User {
    char* name;
    int age;
};
void print_user(struct User* u);
#endif

// main.c
#include "user.h"  // Textual substitution!
#include "user.h"  // Could cause redefinition without guards
```

**Issues:**
1. **Textual inclusion**: Preprocessor blindly copies text, causing exponential compilation slowdown
2. **Order dependency**: `#include` order matters (diamond problem)
3. **Global namespace pollution**: Everything in header is visible
4. **Header guards/pragma once**: Manual bookkeeping to prevent multiple inclusion
5. **No encapsulation**: Private details in headers (implementation leakage)

### Go's Solution: Packages as First-Class Language Feature

```go
// user.go (in package "models")
package models

// Exported (public) - starts with uppercase
type User struct {
    Name string  // Exported field
    age  int     // Unexported (private)
}

// Exported function
func NewUser(name string, age int) User {
    return User{Name: name, age: age}
}

// Unexported function (package-private)
func validateAge(age int) bool {
    return age > 0
}
```

```go
// main.go
package main

import "myapp/models"  // Semantic import, not textual

func main() {
    u := models.NewUser("Alice", 30)
    // u.age is not accessible (unexported)
    println(u.Name)  // OK, Name is exported
}
```

**Design Rationale:**

1. **No preprocessor**: Go has no `#define`, `#ifdef`, or macro system
   - *Why?* Macros are Turing-complete, making code analysis impossible. Go prioritizes tooling (gofmt, gopls).
   
2. **Capitalization = visibility**: Upper case = exported, lower case = unexported
   - *Why?* Simple rule, visually scannable, no keywords needed. Reduces cognitive load.

3. **Unused imports = compile error**: 
   - *Why?* Prevents code rot. Forces maintenance. Bloated imports slow compilation.

4. **Circular imports forbidden**:
   - *Why?* Forces clear dependency hierarchy. Prevents spaghetti architecture at language level.

5. **Import path = semantic identity**:
   ```go
   import "github.com/user/repo/pkg"  // URL-based, globally unique
   ```
   - *Why?* No global package registry needed (unlike npm/PyPI). Decentralized by design.

---

## 2. Entry Point: `package main` and `func main()`

### C/C++ Model

```c
// C: main returns int (exit code), accepts arguments
int main(int argc, char* argv[]) {
    return 0;  // Required
}
```

```cpp
// C++: Multiple forms allowed
int main() { return 0; }
int main(int argc, char* argv[]) { return 0; }
// Or non-standard: void main() (some compilers accept)
```

### Go's Strict Model

```go
package main  // Must be named "main"

func main() {  // No parameters, no return
    // Entry point
    // os.Args for arguments
    // os.Exit(code) for explicit exit code
}
```

**Design Rationale:**

1. **Single canonical form**: Exactly one signature, no variations
   - *Why?* Eliminates bikeshedding. One way to do it.

2. **No return value from main**: Use `os.Exit(code)` explicitly
   - *Why?* Most programs exit successfully. Explicit failure is clearer than `return 1`.

3. **Arguments via `os.Args`**: Not in function signature
   - *Why?* Keeps signature simple. Command-line parsing is library concern.

4. **`package main` is special**: Only package that builds to executable
   - *Why?* Clear distinction between libraries and programs.

```go
package main

import (
    "fmt"
    "os"
)

func main() {
    if len(os.Args) < 2 {
        fmt.Println("Need argument")
        os.Exit(1)  // Explicit exit code
    }
    fmt.Println("Hello,", os.Args[1])
    // Implicit os.Exit(0) if function ends normally
}
```

---

## 3. Variable Declarations: Explicitness vs. Ergonomics

### C/C++ Spectrum

```c
// C: Manual, verbose
int x = 10;
struct User u = {.name = "Bob", .age = 25};
```

```cpp
// C++: Type inference with auto (C++11+)
auto x = 10;           // int
auto u = User{"Bob"};  // User
auto lambda = [](int a) { return a * 2; };  // Complex type
```

### Go's Three Forms

#### Form 1: `var` with Type

```go
var x int = 10
var name string = "Alice"
var users []User = []User{}
```

**When to use:** Global variables, or when zero value is desired:
```go
var count int    // 0
var message string  // ""
var ptr *int     // nil
```

#### Form 2: `var` with Type Inference

```go
var x = 10         // int
var name = "Alice" // string
var f = 3.14       // float64 (not float32!)
```

**Trade-off:** Convenience vs. type ambiguity. Go always chooses specific default (int, float64, complex128).

#### Form 3: Short Declaration `:=`

```go
x := 10
name := "Alice"
user := User{Name: "Bob"}
```

**Restrictions:**
- **Only inside functions** (not at package level)
- At least one new variable must be declared

```go
x := 10
x := 20  // Error: no new variables

x := 10
x, y := 20, 30  // OK, y is new (x is reassigned)
```

**Design Rationale:**

1. **Why three forms?** Balance between explicitness (type safety) and brevity (common cases)
   
2. **Why restrict `:=` to functions?**
   - Package-level variables need explicit `var` for visibility (grep-able)
   - Forces you to think: is this variable needed at package scope?

3. **Why no implicit type conversions?**
   ```go
   var i int = 10
   var f float64 = i  // Error! Must use float64(i)
   ```
   - *Why?* C's implicit conversions cause silent bugs (int → float precision loss)
   - Go: Be explicit about lossy operations

4. **Multiple declarations:**
   ```go
   var (
       x int = 10
       y string = "hello"
       z = 3.14
   )
   ```
   - *Why?* Reduces `var` repetition. Grouped declarations are self-documenting.

---

## 4. Type System Philosophy: Structural over Nominal

### C/C++ Nominal Typing

```c
typedef struct { int x; int y; } Point2D;
typedef struct { int x; int y; } Vector2D;

Point2D p = {1, 2};
Vector2D v = p;  // Error! Different types despite identical structure
```

### Go's Hybrid Approach

```go
type Point2D struct { X, Y int }
type Vector2D struct { X, Y int }

var p Point2D = Point2D{1, 2}
var v Vector2D = p  // Error! Named types are distinct
```

**But:** Interfaces are structural (covered in intermediate), not nominal.

**Explicit Conversions Required:**

```go
type Celsius float64
type Fahrenheit float64

var c Celsius = 100.0
var f Fahrenheit = c  // Error!
f = Fahrenheit(c)     // Explicit conversion required
```

**Design Rationale:**

1. **Why distinct named types?** Prevents mixing incompatible units (like Celsius/Fahrenheit)
   
2. **Why allow explicit conversion?** Underlying type is same, but you must acknowledge the semantic change

3. **Contrast with C++ typedef/using:**
   ```cpp
   using Celsius = double;
   using Fahrenheit = double;
   Celsius c = 100.0;
   Fahrenheit f = c;  // OK in C++! No type safety
   ```

---

## 5. Constants and `iota`: Compile-Time Evaluation

### C/C++ Constants

```c
#define PI 3.14           // Textual macro
const int MAX = 100;      // Runtime const in C
constexpr int MAX = 100;  // Compile-time in C++11+

enum Color { RED = 0, GREEN = 1, BLUE = 2 };  // Manual numbering
```

### Go Constants

```go
const PI = 3.14159265358979323846  // Untyped constant (arbitrary precision!)
const MaxInt = 9223372036854775807  // Precise

const (
    StatusOK = 200
    StatusNotFound = 404
    StatusError = 500
)
```

**Untyped Constants:**

```go
const x = 1 << 100  // OK! Untyped constants have arbitrary precision
var y int = x       // Error: overflow
var z *big.Int = big.NewInt(x)  // Error: needs typed value

const pi = 3.14
var f1 float32 = pi  // OK: pi adapts to float32
var f2 float64 = pi  // OK: pi adapts to float64
```

### `iota`: The Enum Generator

```go
const (
    Sunday = iota  // 0
    Monday         // 1
    Tuesday        // 2
    Wednesday      // 3
)
```

**Complex Patterns:**

```go
const (
    _  = iota             // Skip 0
    KB = 1 << (10 * iota) // 1 << 10 = 1024
    MB                    // 1 << 20 = 1048576
    GB                    // 1 << 30
    TB                    // 1 << 40
)

const (
    FlagRead = 1 << iota  // 1 << 0 = 1
    FlagWrite             // 1 << 1 = 2
    FlagExecute           // 1 << 2 = 4
)
```

**Design Rationale:**

1. **Why untyped constants?** Flexibility. Same constant works in different contexts without casts.
   
2. **Why `iota` instead of traditional enum?**
   ```cpp
   // C++: Verbose, error-prone
   enum FileMode { Read = 1, Write = 2, Execute = 4 };
   ```
   Go's `iota` reduces repetition. Expression is repeated automatically.

3. **Why no "real" enums?** Go avoids sum types (algebraic data types). Constants + type aliases suffice:
   ```go
   type Weekday int
   const (
       Sunday Weekday = iota
       Monday
   )
   ```

---

## 6. Zero Values: Safety by Default

### C/C++ Undefined Behavior

```c
int x;           // Garbage value (undefined behavior)
int* ptr;        // Wild pointer
char buffer[10]; // Uninitialized bytes

printf("%d\n", x);  // UB! Can be 0, can be 42, can crash
```

```cpp
int x;              // Same issue
std::string s;      // Default-constructed (safe!)
std::vector<int> v; // Default-constructed (safe!)
```

### Go's Zero Values (Always Initialized)

```go
var i int        // 0
var f float64    // 0.0
var s string     // "" (empty string, not NULL)
var ptr *int     // nil
var slice []int  // nil (valid, len/cap = 0)
var m map[string]int  // nil (reads return zero, writes panic)
var ch chan int  // nil (send/receive blocks forever)
```

**Zero Values Are Usable:**

```go
var s string
s += "hello"  // Works! s is "", not NULL

var slice []int
slice = append(slice, 1)  // Works! nil slice is valid

var m map[string]int
v := m["key"]  // OK! Returns 0 (but writes panic)
```

**Design Rationale:**

1. **Why zero values?** Eliminates entire class of bugs (uninitialized memory)
   
2. **Why are zero values useful?** Most types have meaningful zero values:
   - `0` for numbers
   - `""` for strings
   - `nil` for pointers/slices/maps (but nil slice is usable!)

3. **Contrast with C++:**
   - C++: Must call constructor. Complex initialization order issues.
   - Go: Zero value + explicit initialization if needed. Simpler mental model.

4. **Nil slice vs. empty slice:**
   ```go
   var s1 []int          // nil, len=0, cap=0
   s2 := []int{}         // not nil, len=0, cap=0
   s3 := make([]int, 0)  // not nil, len=0, cap=0
   
   // All behave identically for append/len/range!
   // JSON marshaling differs: nil → null, empty → []
   ```

---

## 7. Comments and Documentation Conventions

### C/C++ Style

```c
// Single line comment

/* Multi-line
   comment */

/**
 * Doxygen-style documentation
 * @param x The input value
 * @return The result
 */
int process(int x);
```

### Go's `godoc` Convention

```go
// Package models provides user data structures.
// 
// This package implements user management with validation
// and persistence.
package models

// User represents a system user.
// The zero value is not valid; use NewUser.
type User struct {
    Name string  // Full name of user
    age  int     // unexported, use Age() method
}

// NewUser creates a validated User instance.
// Returns error if name is empty or age is negative.
func NewUser(name string, age int) (*User, error) {
    if name == "" {
        return nil, errors.New("name required")
    }
    return &User{Name: name, age: age}, nil
}
```

**Generated Documentation:**

```bash
$ go doc models.User
type User struct {
    Name string
    // unexported fields
}

User represents a system user.
The zero value is not valid; use NewUser.
```

**Design Rationale:**

1. **Comments ARE documentation**: No separate doc system (Doxygen/Javadoc)
   - *Why?* Single source of truth. Docs live with code.

2. **Sentence structure required**: Comment must start with declared name
   ```go
   // NewUser creates...  // Good
   // Creates a user...   // Bad (doesn't start with NewUser)
   ```
   - *Why?* Machine-parseable. `godoc` extracts these automatically.

3. **Package comment on any file (conventionally `doc.go`):**
   ```go
   // Package sort provides primitives for sorting slices.
   package sort
   ```

4. **No multiline /** */ for docs**: Use multiple `//` lines
   - *Why?* Consistency. `//` works everywhere (even mid-function).

---

## 8. `gofmt`: The End of Style Wars

### C/C++ Format Chaos

```c
// K&R style
int main() {
    if (x) {
        return 1;
    }
}

// Allman style
int main()
{
    if (x)
    {
        return 1;
    }
}

// GNU style
int main()
  {
    if (x)
      {
        return 1;
      }
  }
```

**Result:** Every project has different style guide. Code reviews bikeshed formatting.

### Go's Solution: One True Format

```bash
$ gofmt -w myfile.go  # Formats in-place
$ go fmt ./...        # Formats entire project
```

**Example:**

```go
// Before (will be reformatted)
func   main( ){
  x:=   10
    if x>5{
fmt.Println(  "big" )
  }
}

// After gofmt (automatic, non-negotiable)
func main() {
    x := 10
    if x > 5 {
        fmt.Println("big")
    }
}
```

**Design Rationale:**

1. **Why enforce formatting?**
   - Eliminates bikeshedding (wastes 1000s of hours industry-wide)
   - Code looks same across all Go projects (reduced cognitive load)
   - Diffs show logic changes, not whitespace

2. **Why is gofmt's style not configurable?**
   - One style = no arguments. "It's what gofmt does" ends discussion.
   - Quote from Rob Pike: "Gofmt's style is nobody's favorite, yet gofmt is everyone's favorite."

3. **Integration:**
   - Most editors auto-run on save
   - CI rejects unformatted code
   - `git diff` stays clean

4. **Contrast with clang-format/prettier:**
   - Those allow configuration files. Go explicitly rejects this.
   - Philosophy: Remove choice to remove friction.

---

## 9. Code Organization Philosophy

### C/C++ Model

```
project/
  include/          # Public headers
    mylib.h
  src/              # Implementation
    mylib.c
    private.c
  test/
    test_mylib.c
```

**Issues:**
- Header/implementation split (DRY violation)
- No standard layout
- Manual build configuration (Makefile, CMake)

### Go's Standard Layout

```
myproject/
  go.mod            # Module definition (like package.json)
  main.go           # Entry point (package main)
  user.go           # Package main, other files
  models/           # Sub-package
    user.go         # package models
    user_test.go    # Tests (same package or models_test)
  internal/         # Private packages (cannot be imported externally)
    helpers.go
```

**Key Conventions:**

1. **`_test.go` files**: Automatically excluded from builds, included in `go test`
   ```go
   // user_test.go
   package models  // Same package, can test unexported functions
   
   func TestNewUser(t *testing.T) { /*...*/ }
   ```

2. **`internal/` directory**: Enforced privacy at filesystem level
   ```
   myproject/internal/helpers  # Only importable by myproject code
   ```
   - *Why?* Prevents external users from depending on internal APIs.

3. **Flat package structure preferred:**
   ```go
   github.com/user/repo/models
   github.com/user/repo/handlers
   ```
   Not:
   ```go
   github.com/user/repo/src/models  # Avoid "src" directory
   ```

4. **No circular dependencies allowed:**
   ```
   models → handlers → models  // Compile error!
   ```
   - *Why?* Forces layered architecture. Prevents spaghetti.

**Design Rationale:**

1. **Convention over configuration**: Standard layout = no decisions needed
   
2. **File organization = package organization**: No extra metadata files
   
3. **Build system is implicit**: `go build` just works. No Makefile.
   
4. **Tests live with code**: No separate test tree. Encourages testing.

---

## 10. Comparison Summary: Go vs. C/C++

| Feature | C/C++ | Go | Why Go Chose Differently |
|---------|-------|-----|--------------------------|
| **Modules** | Textual includes, preprocessor | Semantic imports, packages | Compilation speed, tooling |
| **Visibility** | public/private/protected keywords | Capitalization | Simplicity, visual scan |
| **Main signature** | `int main(int, char**)` | `func main()` | One way to do it |
| **Type inference** | `auto` (C++11+), none in C | `var x = ...` and `:=` | Balance convenience/explicitness |
| **Zero values** | Undefined behavior | Always initialized | Safety, prevent UB |
| **Constants** | `#define`, `const`, `constexpr` | `const` with `iota` | Arbitrary precision, simplicity |
| **Documentation** | Separate (Doxygen, etc.) | Comments are docs | Single source of truth |
| **Formatting** | Infinite styles | `gofmt` (one true way) | End bikeshedding |
| **Build system** | Make, CMake, etc. | `go build` | Convention over configuration |

---

## Conclusion: Design Philosophy Recap

Go's design is a reaction to C++ complexity:
- **Subtract features**: No inheritance, no generics (until 1.18), no macros, no operator overloading
- **Optimize for reading**: Code is read 10x more than written. Clarity > cleverness.
- **Fast compilation**: Explicit imports, no header parsing. Build entire codebase in seconds.
- **Tooling-first**: `gofmt`, `godoc`, `gopls` (language server) are first-class. IDE support is not an afterthought.

**Trade-offs Accepted:**
- Less expressive than C++ (no template metaprogramming)
- More verbose in some cases (explicit error handling)
- Opinionated (not configurable)

**Benefits Gained:**
- Readable by anyone after 1 week
- Compiles fast (even 1M+ LOC projects)
- Onboarding is easy (one way to do things)
- Code reviews focus on logic, not style
