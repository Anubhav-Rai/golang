# Go Data Types and Variables - Learning Context

## Topic Overview
Understanding Go's type system compared to C/C++, with emphasis on simplicity and safety.

## Type System Comparison

### Basic Types

| C/C++ | Go | Notes |
|-------|-----|-------|
| `int` | `int` | Platform dependent (32 or 64 bit) |
| `int32_t` | `int32` | Explicitly sized |
| `int64_t` | `int64` | Explicitly sized |
| `unsigned int` | `uint` | Platform dependent |
| `float` | `float32` | 32-bit floating point |
| `double` | `float64` | 64-bit floating point |
| `char` | `byte` or `rune` | byte=uint8, rune=int32 for Unicode |
| `bool` | `bool` | true/false |
| `string` | `string` | Immutable, UTF-8 by default |

### Variable Declaration Styles

**C/C++:**
```cpp
int x = 10;
int y;
y = 20;
const int z = 30;
```

**Go - Four Ways:**
```go
// 1. Full declaration with type
var x int = 10

// 2. Type inference
var y = 10

// 3. Short declaration (only in functions)
z := 10

// 4. Constant
const MAX = 100
```

### Zero Values (vs Undefined in C++)

**C++:** Uninitialized variables have garbage values
```cpp
int x;  // garbage value!
```

**Go:** All variables have zero values
```go
var x int      // 0
var s string   // ""
var b bool     // false
var p *int     // nil
```

## Strings - Major Difference!

**C/C++:** Strings are char arrays or std::string
```cpp
char str[] = "Hello";
string s = "World";
s[0] = 'w';  // mutable
```

**Go:** Strings are immutable value types
```go
s := "Hello"
// s[0] = 'h'  // ERROR! Cannot modify
s = "hello"    // OK - reassignment

// String is slice of bytes
bytes := []byte(s)  // convert to modify
bytes[0] = 'H'
s = string(bytes)
```

## Type Conversions

**C/C++:** Implicit conversions everywhere
```cpp
int x = 10;
double y = x;  // automatic
float z = 3.14;
int a = z;     // truncates automatically
```

**Go:** ALL conversions must be explicit
```go
var x int = 10
var y float64 = float64(x)  // MUST convert explicitly

var z float64 = 3.14
// var a int = z  // ERROR!
var a int = int(z)  // OK
```

## Complex Types Preview

### Arrays (Fixed Size)
**C/C++:**
```cpp
int arr[5] = {1, 2, 3, 4, 5};
```

**Go:**
```go
var arr [5]int = [5]int{1, 2, 3, 4, 5}
arr := [5]int{1, 2, 3, 4, 5}
arr := [...]int{1, 2, 3, 4, 5}  // auto-size
```

### Slices (Dynamic Arrays)
**C++:** `std::vector<int>`
**Go:**
```go
slice := []int{1, 2, 3}  // dynamic
slice = append(slice, 4)
```

## Constants - Compile Time Only

**C/C++:**
```cpp
const int x = 10;
const string s = "hello";
```

**Go - Untyped Constants:**
```go
const x = 10        // untyped
const y int = 10    // typed
const (
    A = 1
    B = 2
    C = 3
)

// iota - constant generator
const (
    Sunday = iota     // 0
    Monday            // 1
    Tuesday           // 2
)
```

## Type Aliases and Definitions

**C/C++:**
```cpp
typedef int Integer;
using Integer = int;
```

**Go:**
```go
type Integer int        // new type
type IntAlias = int     // alias (Go 1.9+)
```

## Learning Path

### Basic Level
- All primitive types
- Variable declarations
- Zero values
- Type conversions
- String basics
- Constants and iota

### Intermediate Level
- Typed vs untyped constants
- Runes vs bytes
- String manipulation
- Type definitions vs aliases
- Numeric type overflow
- Custom types

### Advanced Level
- Unsafe type conversions
- reflect package for types
- Type assertions
- String internals
- Memory layout of types
- Performance implications

## Key Differences Summary

1. **No implicit conversions** - Type safety is strict
2. **Zero values** - No uninitialized variables
3. **Immutable strings** - More like Java than C++
4. **No char type** - Use byte or rune
5. **Explicit sizing** - int8, int16, int32, int64, uint8, etc.
6. **No unions** - Use interfaces instead
7. **No enums** - Use const with iota

## Practice Context

When practicing:
- Convert C++ variable declarations to Go
- Understand zero value initialization
- Practice explicit type conversions
- Work with string immutability
- Use iota for enumerations
