# Data Types and Variables - Basic

## 1. Basic Types Overview

### Go's Type System
```go
// Boolean
var b bool = true

// Integers (platform-independent sizes)
var i8 int8 = 127           // -128 to 127
var ui8 uint8 = 255          // 0 to 255 (byte alias)
var i16 int16 = 32767
var i32 int32 = 2147483647   // rune alias
var i64 int64 = 9223372036854775807

// Platform-dependent
var i int     // 32 or 64 bit depending on platform
var ui uint   // 32 or 64 bit

// Floating point
var f32 float32 = 3.14
var f64 float64 = 3.14159265359

// Complex numbers
var c64 complex64 = 1 + 2i
var c128 complex128 = 1 + 2i

// String
var s string = "Hello, 世界"

// Byte and Rune
var byteVal byte = 'A'  // alias for uint8
var runeVal rune = '世'  // alias for int32 (Unicode code point)
```

### C/C++ Comparison
```cpp
// C/C++ - sizes can vary by platform!
bool b = true;

// Integer sizes platform-dependent in C
char c = 127;            // Usually 8 bits, but not guaranteed
short s = 32767;         // At least 16 bits
int i = 2147483647;      // At least 16 bits (usually 32)
long l = 2147483647;     // At least 32 bits
long long ll;            // At least 64 bits (C++11)

// Fixed-width integers (C99/C++11)
#include <stdint.h>
int8_t i8 = 127;
uint8_t ui8 = 255;
int32_t i32 = 2147483647;

// Floating point
float f = 3.14f;         // 32 bits (usually)
double d = 3.14;         // 64 bits (usually)
long double ld;          // 80 or 128 bits (platform-dependent)

// No native complex numbers (use <complex>)
// No native string type (use char* or std::string)
```

### Design Rationale

**Fixed-Size Integer Types by Default**
- **Why**: Predictable behavior across platforms
- **C/C++ Problem**: `int` size varies (16, 32, or 64 bits depending on platform)
- **Go Solution**: Explicit sizes (`int32`, `int64`) + platform-dependent (`int`)
- **Trade-off**: More verbose, but no portability surprises

**No Implicit Integer Conversions**
```go
var i32 int32 = 42
var i64 int64 = i32  // ERROR! Must explicitly convert
var i64 int64 = int64(i32)  // OK
```
- **C/C++**: Implicit conversions everywhere (source of bugs)
- **Go**: All numeric conversions must be explicit
- **Philosophy**: Clarity over convenience

**String as Primitive Type**
- **Why**: Strings are immutable, UTF-8 by default
- **C Problem**: `char*` is error-prone (buffer overflows, null termination)
- **C++ Solution**: `std::string` (part of library, not language)
- **Go**: Built-in string type, immutable, safe

**Complex Numbers Built-In**
- **Why**: Scientific computing, signal processing
- **C/C++**: Requires `<complex>` library
- **Go**: First-class support (`complex64`, `complex128`)

**Rune for Unicode**
- **Why**: UTF-8 is the default encoding
- **Type**: `rune` is `int32` (holds any Unicode code point)
- **C/C++**: No standard Unicode character type (use `wchar_t` or libraries)

---

## 2. Variable Declarations

### Three Ways to Declare
```go
// 1. var with explicit type
var x int = 10
var y int  // Zero value: 0

// 2. var with type inference
var a = 10  // Type inferred as int

// 3. Short declaration (inside functions only)
b := 10  // Type inferred, most common
```

### C/C++ Comparison
```cpp
// Only one way (with C++11 auto)
int x = 10;
int y;  // UNINITIALIZED! (undefined value)

auto a = 10;  // C++11: type inference
```

### Design Rationale

**Zero Values (Critical Safety Feature)**
```go
var i int        // 0
var f float64    // 0.0
var b bool       // false
var s string     // ""
var p *int       // nil
var arr [5]int   // [0, 0, 0, 0, 0]
var m map[string]int  // nil (but can read from it safely)
```

- **Why**: Eliminate undefined behavior
- **C/C++ Problem**: Uninitialized variables contain garbage
- **Safety**: Every variable has a valid, predictable value
- **Performance**: No cost (memory zeroed by OS for security anyway)

**Short Declaration (`:=`)**
- **Why**: Reduce boilerplate for local variables
- **Limitation**: Only inside functions
- **Reason**: Package-level declarations should be explicit for documentation
- **Common Practice**: Use `:=` for locals, `var` for globals

---

## 3. Constants

### Syntax
```go
const pi = 3.14159
const (
    e  = 2.71828
    phi = 1.61803
)

// Typed constants
const x int = 42
const y = 42  // Untyped constant (more flexible)
```

### C/C++ Comparison
```cpp
const double pi = 3.14159;
#define PI 3.14159  // Old C style (no type safety)

constexpr double pi = 3.14159;  // C++11 (compile-time)
```

### Design Rationale

**Untyped Constants**
```go
const billion = 1000000000  // Untyped integer constant

var x int32 = billion   // OK
var y int64 = billion   // OK
var z float64 = billion // OK
```

- **Why**: More flexible than typed constants
- **Works with**: Any numeric type that can hold the value
- **C/C++**: Constants have specific types, less flexible
- **Trade-off**: Convenience without sacrificing type safety

**No Const Pointers/References**
```go
// Go doesn't have:
const int* p;        // C: pointer to const int
int* const p;        // C: const pointer to int
```

- **Why**: Simplicity - immutability via design, not enforcement
- **Philosophy**: If you need immutability, don't give a pointer
- **Alternative**: Pass values (copied) or use interfaces

---

## 4. Type Conversions

### Explicit Only
```go
var i int = 42
var f float64 = float64(i)  // Must convert explicitly
var u uint = uint(i)

// String conversions
s := string(65)        // "A" (from rune)
i := int([]byte("A")[0])  // 65

// Numeric string conversions (need strconv package)
import "strconv"
s := strconv.Itoa(42)        // "42"
i, err := strconv.Atoi("42") // 42
```

### C/C++ Comparison
```cpp
// Implicit conversions everywhere!
int i = 42;
double f = i;  // Implicit conversion
unsigned int u = i;  // Implicit (dangerous if negative!)

// C-style cast (dangerous)
float f = (float)i;

// C++ casts (safer)
float f = static_cast<float>(i);
```

### Design Rationale

**No Implicit Conversions**
- **Why**: Prevent bugs from unexpected conversions
- **C/C++ Issues**:
  - Sign errors (int to unsigned)
  - Precision loss (int64 to int32)
  - Unexpected promotions
- **Go**: Must be explicit about every conversion
- **Trade-off**: More verbose, but intentions are clear

---

## 5. Pointers

### Basic Pointers
```go
var x int = 42
var p *int = &x  // Pointer to x

fmt.Println(*p)  // Dereference: 42
*p = 100         // Modify through pointer
```

### C/C++ Comparison
```cpp
int x = 42;
int* p = &x;

printf("%d
", *p);  // 42
*p = 100;

// C++ also has references
int& ref = x;   // Reference (alias)
ref = 100;      // Modifies x
```

### Design Rationale

**No Pointer Arithmetic**
```go
var arr [5]int
p := &arr[0]
// p++  // ERROR! No pointer arithmetic
```

- **Why**: Safety (prevent buffer overflows)
- **C/C++ Power**: Can do `p++`, `p + 5`, etc.
- **C/C++ Danger**: Easy to access invalid memory
- **Go Alternative**: Use slices (safe, bounds-checked)

**No References**
- **Why**: Pointers are explicit (can see the `*` and `&`)
- **C++ References**: Implicit aliasing (can be confusing)
- **Go Philosophy**: Explicit is better than implicit
- **Clarity**: Always know when you're dealing with pointers

**Nil Pointers**
```go
var p *int  // nil
if p == nil {
    // Safe check
}
// *p  // Runtime panic (not undefined behavior!)
```

- **Safety**: Nil pointer dereference panics (recoverable)
- **C/C++**: Undefined behavior (often segfault)
- **Benefit**: Errors are caught, not silent corruption

---

## 6. Type Aliases

### Syntax
```go
// Type definition (new type)
type Celsius float64
type Fahrenheit float64

var temp Celsius = 25.0
// var temp2 Fahrenheit = temp  // ERROR! Different types

// Type alias (same type)
type MyInt = int
var x MyInt = 42
var y int = x  // OK! MyInt and int are identical
```

### Design Rationale

**Type Definition for Safety**
```go
type UserID int
type ProductID int

func getUser(id UserID) {}
func getProduct(id ProductID) {}

var uid UserID = 123
var pid ProductID = 456

getUser(uid)  // OK
// getUser(pid)  // ERROR! Can't mix types
```

- **Why**: Prevent mixing semantically different integers
- **C/C++**: typedef doesn't create new type
- **Benefit**: Compiler catches logical errors

---

## Summary

| Feature | C/C++ | Go | Design Reason |
|---------|-------|-----|---------------|
| Integer sizes | Platform-dependent | Fixed + platform types | Predictability |
| Initialization | Undefined | Zero values | Safety |
| Type conversions | Implicit | Explicit | Prevent bugs |
| Strings | char*/std::string | Built-in immutable | Safety, UTF-8 |
| Pointer arithmetic | Allowed | Not allowed | Safety |
| References | C++ has them | No references | Explicitness |
| Type definitions | Weak (typedef) | Strong (type) | Type safety |

**Core Philosophy**: Safety and clarity through simplicity and explicitness.
