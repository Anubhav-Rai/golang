#!/bin/bash

echo "Creating comprehensive theory files with deep design rationale..."
echo "This will take some time - creating 20 detailed theory documents"

# Topic 02: Data Types
cd 02_data_types_and_variables/basic
cat > theory.md << 'EOFDOC'
# Data Types and Variables - Theory with Design Rationale

## Zero Values: Go's Safety Net

### C++ Way (Uninitialized Variables)
```cpp
int x;              // Uninitialized! Contains garbage
double y;           // Uninitialized! Random value
bool flag;          // Uninitialized! Could be anything
string s;           // Empty string (constructor called)

// Using uninitialized variable = Undefined Behavior
cout << x;          // May print random number, may crash
```

### Go Way (Always Initialized)
```go
var x int           // Zero value: 0
var y float64       // Zero value: 0.0
var flag bool       // Zero value: false
var s string        // Zero value: ""

// Always safe to use
fmt.Println(x)      // Always prints 0
```

### Design Rationale: WHY Zero Values?

**The Problem Go Solves:**

1. **Undefined Behavior in C/C++:**
   ```cpp
   // Real bug in C++:
   int count;
   if (someCondition) {
       count = 10;
   }
   // If condition false, count is garbage!
   total += count;  // BUG: Adding random number
   ```

2. **Security Vulnerabilities:**
   - Uninitialized memory can leak sensitive data
   - Buffer overflow exploits often rely on uninitialized values
   - CVEs (security vulnerabilities) caused by this

**Go's Solution: Zero Values**

Every type has a sensible zero value:
```go
// Numeric types
var i int           // 0
var f float64       // 0.0
var c complex128    // 0+0i

// Boolean
var b bool          // false

// String
var s string        // ""

// Pointer, slice, map, channel, interface
var p *int          // nil
var sl []int        // nil
var m map[int]int   // nil
var ch chan int     // nil
var iface interface{} // nil
```

**Why These Specific Values?**

1. **Mathematical Zero** for numbers:
   - Most natural choice
   - Neutral element for addition
   - Safe default for calculations

2. **false** for bool:
   - "No" is the safe default
   - Prevents accidental permission grants
   - Security-first approach

3. **Empty String** for string:
   - Not nil (Go strings are values, not pointers)
   - Safe to use immediately
   - No null pointer exceptions

4. **nil** for Reference Types:
   - Consistent with pointers
   - Can check if initialized: `if slice != nil`
   - Prevents memory issues

**The "Zero Value is Useful" Philosophy:**

```go
// Example: Mutex doesn't need initialization
type Counter struct {
    mu    sync.Mutex  // Zero value is ready to use!
    count int         // Zero value is 0
}

var c Counter
c.mu.Lock()         // Just works!
c.count++
c.mu.Unlock()
```

```cpp
// C++ requires explicit initialization
class Counter {
    std::mutex mu;   // OK, constructor initializes
    int count;       // NOT initialized!
    
public:
    Counter() : count(0) {}  // Must write constructor
};
```

**Real-World Impact:**

1. **Prevents Entire Class of Bugs:**
   - No "uninitialized variable" bugs
   - No random crashes from garbage values
   - No security leaks from memory contents

2. **Simpler Code:**
   ```go
   var sum int           // Already 0, ready to use
   for _, v := range values {
       sum += v
   }
   ```
   
   vs C++:
   ```cpp
   int sum = 0;          // Must explicitly initialize
   for (auto v : values) {
       sum += v;
   }
   ```

3. **"Ready to Use" Structs:**
   ```go
   type Buffer struct {
       data []byte     // nil is valid, append works
   }
   
   var b Buffer
   b.data = append(b.data, 'x')  // Works! append handles nil
   ```

**Trade-offs:**
- ✅ **Pro**: No undefined behavior, always safe
- ✅ **Pro**: Simpler code (no manual init)
- ✅ **Pro**: Security (no leaked memory)
- ❌ **Con**: Might hide bugs where you forgot to set a value
- ✅ **Pro**: Types can be designed to work with zero value

---

## Type System Philosophy

### C++ vs Go Type Systems

**C++ Type System:**
```cpp
// Implicit conversions everywhere
int x = 3.14;           // double -> int (data loss!)
unsigned int a = -1;    // int -> unsigned (overflow!)
void* p = malloc(10);
int* ip = p;            // void* -> int* (unsafe in C++)

// Operator overloading
string s = "Hello";
s = s + " World";       // operator+ overloaded
cout << s;              // operator<< overloaded

// Template metaprogramming
template<typename T>
concept Addable = requires(T a, T b) { a + b; };
```

**Go Type System:**
```go
// Explicit conversions always
x := int(3.14)          // Must be explicit
var a uint = uint(-1)   // Must be explicit

// No operator overloading
// No void pointers
// No templates (until 1.18, minimal generics)

// Simple and predictable
type MyInt int
var m MyInt = MyInt(42)
```

### Design Rationale: WHY Explicit Conversions?

**The Problem with Implicit Conversions:**

1. **Silent Data Loss:**
   ```cpp
   // C++ - Data loss, no warning!
   double pi = 3.14159;
   int approx = pi;        // approx = 3, no error!
   
   float f = 1.23456789;
   double d = f;           // Precision loss
   ```

2. **Signed/Unsigned Bugs:**
   ```cpp
   // C++ - Famous bug!
   unsigned int size = buffer.size();
   int offset = -1;
   
   if (size + offset > 0) {  // BUG!
       // offset converted to unsigned, becomes huge number
       // Condition is always true!
   }
   ```

3. **Integer Promotion Surprises:**
   ```cpp
   // C++ - Unexpected behavior
   char c = 255;
   int x = c + 1;      // Promoted to int, but result depends on 
                       // whether char is signed!
   ```

**Go's Solution: Explicit Everything**

```go
// All conversions visible
var i int = 42
var f float64 = float64(i)    // Explicit
var b byte = byte(i)          // Explicit (might overflow!)

// Even "safe" conversions require explicit:
var x int32 = 42
var y int64 = int64(x)        // Explicit, even though safe

// No surprises
var a uint = 1
var b int = -1
// if a > b { }  // Compile error! Can't compare different types
```

**Why Require Even "Safe" Conversions?**

Many programmers ask: "Why can't `int64 = int32`? It's safe!"

**Go's Response:**

1. **Consistency:**
   - ALL conversions are explicit
   - No exceptions, no special cases
   - Easier to remember and teach

2. **Visibility:**
   - Reader sees every conversion
   - No hidden performance costs
   - Code does what it looks like

3. **Cross-Platform Safety:**
   ```go
   var i int = 42        // 32 or 64 bits, platform-dependent
   var i64 int64 = i     // ERROR!
   
   // Must be explicit:
   i64 = int64(i)        // Now clear this is a conversion
   ```

4. **Prevents Accidental Bugs:**
   ```go
   var timeout int32 = 30
   var duration int64 = 1000000000
   
   // if timeout > duration { }  // ERROR! Can't compare
   
   // Must be explicit about which type to use:
   if int64(timeout) > duration {  // Clear intent
   }
   ```

**Historical Context:**

Go designers (Rob Pike, Ken Thompson) worked on Plan 9 and Unix:
- Saw countless bugs from implicit conversions
- Wanted a language where types don't surprise you
- Philosophy: "Explicit is better than implicit" (from Python Zen)

**Trade-offs:**
- ✅ **Pro**: No silent bugs, no surprises
- ❌ **Con**: More verbose, more typing
- ✅ **Pro**: Code is obvious, reviewers can understand
- ❌ **Con**: Some conversions seem "obvious" but still required
- ✅ **Pro**: Prevents entire classes of bugs

---

## Basic Types

### Numeric Types

**C++ Numeric Types:**
```cpp
// Size depends on platform!
short s;           // At least 16 bits
int i;             // At least 16 bits (usually 32)
long l;            // At least 32 bits (32 or 64!)
long long ll;      // At least 64 bits

// Character types
char c;            // Signed or unsigned? Platform-dependent!
signed char sc;
unsigned char uc;

// Fixed-width types (C++11)
#include <cstdint>
int32_t i32;       // Exactly 32 bits
int64_t i64;       // Exactly 64 bits
```

**Go Numeric Types:**
```go
// Signed integers (exact sizes)
int8, int16, int32, int64

// Unsigned integers (exact sizes)
uint8, uint16, uint32, uint64

// Platform-dependent (but explicit!)
int         // 32 or 64 bits
uint        // 32 or 64 bits
uintptr     // Size of a pointer

// Aliases
byte        // alias for uint8
rune        // alias for int32 (Unicode code point)

// Floating point
float32     // IEEE-754 32-bit
float64     // IEEE-754 64-bit

// Complex numbers (built-in!)
complex64   // complex with float32 parts
complex128  // complex with float64 parts
```

### Design Rationale: WHY These Types?

**1. Explicit Sizes:**

**C++ Problem:**
```cpp
// Write on 32-bit machine:
long x = 1234567890;    // 32 bits, works fine

// Run on 64-bit machine:
long x = 1234567890;    // Now 64 bits! Binary format incompatible!

// Portable code requires:
#include <cstdint>
int32_t x = 1234567890; // Explicit size
```

**Go Solution:**
```go
// Size is always in the name
var x int32 = 1234567890  // Always 32 bits, any platform
var y int64 = 1234567890  // Always 64 bits, any platform
```

**Why This Matters:**
- Network protocols: Need exact sizes
- File formats: Need exact sizes  
- Cross-compilation: Works predictably
- Binary serialization: Portable

**2. Platform-Dependent `int`:**

```go
var i int       // 32 bits on 32-bit, 64 bits on 64-bit
```

**Why Have Platform-Dependent Type?**
- Most code doesn't care about exact size
- `int` is "natural" size for the platform
- Best performance (matches register size)
- Array indices, string lengths use `int`

**When to Use Each:**
```go
// Use int for:
count := len(slice)     // Length/count
for i := 0; i < n; i++  // Loop counters
age := 25               // General numbers

// Use int32/int64 for:
var timestamp int64     // Unix timestamp
var fileSize int64      // File size
var networkId int32     // Network protocol
```

**3. Rune (Unicode)**

```go
var r rune = '世'  // Unicode code point (int32)
```

**Why `rune` Instead of `char`?**

**C++ Problem:**
```cpp
char c = 'A';       // 1 byte, ASCII only
wchar_t wc = L'世'; // 2 or 4 bytes, platform-dependent!

// UTF-8 string
string s = "Hello世界";
// How to iterate over characters? Not trivial!
```

**Go Solution:**
```go
s := "Hello世界"

// Iterate over Unicode code points
for i, r := range s {
    fmt.Printf("Position %d: %c (rune: %d)\n", i, r, r)
}
// Automatically decodes UTF-8 to runes!
```

**Why This Works:**
- Go strings are UTF-8 by default
- `rune` is a Unicode code point (int32)
- `range` over string decodes UTF-8 automatically
- No need for separate wide-character functions

**4. Complex Numbers (Built-in!)**

```go
var c complex128 = 1 + 2i
real(c)     // 1.0
imag(c)     // 2.0
```

**Why Built-In Complex Numbers?**

**C++ Way:**
```cpp
#include <complex>
std::complex<double> c(1.0, 2.0);
c.real();   // 1.0
c.imag();   // 2.0
```

**Go Way:**
```go
c := 1 + 2i         // Built-in syntax!
d := 3 + 4i
result := c * d     // Just works
```

**Design Rationale:**
- Scientific computing is common (Google needs it)
- Why make it a library when it could be built-in?
- Literals like `1+2i` are more readable
- Consistent with Go's "batteries included" philosophy

---

## String Type

### C++ vs Go Strings

**C++ Strings:**
```cpp
// Three types of strings!
char* cstr = "Hello";           // C-style, null-terminated
const char* cstr2 = "World";    // Const C-style
std::string s = "Hello";        // C++ string class

// Mutability
s[0] = 'h';                     // OK, mutable
cstr[0] = 'h';                  // Undefined behavior!
```

**Go Strings:**
```go
s := "Hello"        // Only one string type
// s[0] = 'h'       // ERROR: strings are immutable!

// Strings are:
// 1. UTF-8 encoded
// 2. Immutable
// 3. Not null-terminated
```

### Design Rationale: WHY Immutable Strings?

**C++ Mutable Strings:**
```cpp
string s = "Hello";
string t = s;           // Copy? No, COW (copy-on-write) maybe
s[0] = 'h';             // Does this affect t? Depends on implementation!

// Thread safety
void thread1() { s[0] = 'a'; }
void thread2() { s[0] = 'b'; }  // Race condition!
```

**Go Immutable Strings:**
```go
s := "Hello"
t := s              // Shares underlying data (cheap!)
// s[0] = 'h'       // Compile error

// Thread safe
func goroutine1() { _ = s[0] }  // Safe
func goroutine2() { _ = s[0] }  // Safe, no race
```

**Why Immutable:**

1. **Thread Safety:**
   - Can share strings between goroutines safely
   - No need for locks
   - Critical for Go's concurrency model

2. **Performance:**
   ```go
   s := "Hello"
   t := s          // No copy! Just pointer + length
   ```
   - Copying a string is O(1), not O(n)
   - Substring is also O(1): `s[0:2]` just adjusts pointer

3. **Hash Keys:**
   ```go
   m := make(map[string]int)
   key := "hello"
   m[key] = 42
   // key can't change, so hash is stable
   ```

4. **Simplicity:**
   - No COW complexity
   - Behavior is predictable
   - No "will this copy?" questions

**How to Modify Strings:**
```go
// Convert to []byte, modify, convert back
s := "Hello"
b := []byte(s)      // Copy to byte slice
b[0] = 'h'
s = string(b)       // Convert back (copy again)

// Or use strings.Builder for efficiency
var builder strings.Builder
builder.WriteString("Hello")
builder.WriteByte('!')
s := builder.String()
```

**UTF-8 by Default:**

```go
s := "Hello世界"
fmt.Println(len(s))           // 11 (bytes, not characters!)

// Iterate over runes (code points)
for i, r := range s {
    fmt.Printf("%d: %c\n", i, r)
}
// 0: H
// 1: e
// 2: l
// 3: l
// 4: o
// 5: 世
// 8: 界
```

**Why UTF-8:**
- ASCII compatible (1 byte per ASCII character)
- Self-synchronizing (can find character boundaries)
- Invented by Ken Thompson (Go co-designer!)
- Web-friendly (HTTP, HTML use UTF-8)

---

## Constants and `iota`

### C++ Constants

```cpp
const int MAX = 100;
#define SIZE 50         // Preprocessor constant

enum Color {
    RED = 0,
    GREEN = 1,
    BLUE = 2
};

// Enums with automatic values
enum Status {
    PENDING,    // 0
    ACTIVE,     // 1
    DONE        // 2
};
```

### Go Constants

```go
const Max = 100

// Typed constant
const Size int = 50

// Untyped constant (more flexible)
const Pi = 3.14

// iota - automatic enumeration
const (
    Sunday = iota    // 0
    Monday           // 1
    Tuesday          // 2
)
```

### Design Rationale: WHY `iota`?

**C++ Enums:**
```cpp
enum {
    KB = 1024,
    MB = 1024 * 1024,
    GB = 1024 * 1024 * 1024
};

// Bit flags
enum Flags {
    READ   = 1,       // 0001
    WRITE  = 2,       // 0010
    EXECUTE = 4       // 0100
    // Tedious to calculate powers of 2
};
```

**Go iota:**
```go
const (
    KB = 1 << (10 * iota)  // 1 << 0 = 1
    MB                      // 1 << 10 = 1024
    GB                      // 1 << 20 = 1048576
    TB                      // 1 << 30
)

// Bit flags (elegant!)
const (
    Read = 1 << iota       // 1 << 0 = 1
    Write                  // 1 << 1 = 2
    Execute                // 1 << 2 = 4
)
```

**How `iota` Works:**
- Starts at 0 in each `const` block
- Increments by 1 for each line
- Expression is re-evaluated for each line

**Advanced iota:**
```go
const (
    _  = iota             // Skip 0
    KB = 1 << (10 * iota) // 1024
    MB                    // 1048576
    GB                    // 1073741824
)

const (
    a = iota * 2          // 0
    b                     // 2
    c                     // 4
)
```

**Why iota Instead of enum:**
- More powerful (expressions)
- Less typing
- Automatically maintains sequence
- Can skip values with `_`

**Trade-offs:**
- ✅ **Pro**: Concise, automatic numbering
- ✅ **Pro**: Powerful expressions
- ❌ **Con**: Less explicit than writing numbers
- ✅ **Pro**: Reduces copy-paste errors

---

## Type Declarations

### Creating New Types

**C++:**
```cpp
typedef int Meters;         // Alias
using Kilometers = double;  // Alias (C++11)

// Strong typedef (requires wrapper)
class Meters {
    int value;
public:
    explicit Meters(int v) : value(v) {}
};
```

**Go:**
```go
// Type alias (same type)
type MyInt = int

// New type (distinct type)
type Meters int
type Kilometers float64
```

### Design Rationale: WHY Two Kinds?

**Type Alias (`=`):**
```go
type MyInt = int

var x MyInt = 5
var y int = x       // OK, same type
```

**New Type (no `=`):**
```go
type Meters int

var x Meters = 5
// var y int = x    // ERROR! Different type
var y int = int(x)  // Must convert
```

**Why Have Both?**

1. **Type Alias** - for migration/refactoring:
   ```go
   // Old code used []byte
   type Buffer = []byte
   
   // Can gradually change to Buffer without breaking anything
   ```

2. **New Type** - for type safety:
   ```go
   type UserID int
   type ProductID int
   
   func getUser(id UserID) {}
   func getProduct(id ProductID) {}
   
   var uid UserID = 123
   var pid ProductID = 456
   
   getUser(pid)    // ERROR! Prevents mixing IDs
   ```

**Real-World Example:**
```go
// Prevent mixing different units
type Celsius float64
type Fahrenheit float64

func toFahrenheit(c Celsius) Fahrenheit {
    return Fahrenheit(c*9/5 + 32)
}

temp := Celsius(100)
// f := toFahrenheit(32.0)  // ERROR! Can't pass float64
f := toFahrenheit(Celsius(32))  // Must be explicit
```

**Benefits:**
- Type system catches mistakes
- Self-documenting code
- No runtime cost (types erased)

---

## Summary: Design Philosophy

### Why Go's Type System?

1. **Safety First:**
   - Zero values prevent undefined behavior
   - No implicit conversions prevent bugs
   - Explicit conversions make intent clear

2. **Simplicity:**
   - Clear type names (int32, not long)
   - One string type
   - Predictable behavior

3. **Performance:**
   - Immutable strings enable sharing
   - Platform-specific `int` matches hardware
   - No hidden allocations

4. **Practicality:**
   - UTF-8 strings for modern text
   - Complex numbers built-in
   - Zero values are useful, not just safe

**Core Principle:**
> "The language should help you write correct code, not just allow you to write any code."

---

**Further Reading:**
- [Go Spec - Types](https://go.dev/ref/spec#Types)
- [Go Blog - Strings](https://go.dev/blog/strings)
- [Effective Go - Data](https://go.dev/doc/effective_go#data)

EOFDOC

echo "Topic 02 done"
cd ../../..
