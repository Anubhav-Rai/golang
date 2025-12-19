# Data Types and Variables - Advanced

## 1. Memory Layout and Alignment

### Struct Padding
```go
type BadLayout struct {
    a bool   // 1 byte
    // 7 bytes padding
    b int64  // 8 bytes
    c bool   // 1 byte
    // 7 bytes padding
}  // Total: 24 bytes!

type GoodLayout struct {
    b int64  // 8 bytes
    a bool   // 1 byte
    c bool   // 1 byte
    // 6 bytes padding
}  // Total: 16 bytes!
```

### Check Size
```go
import "unsafe"

fmt.Println(unsafe.Sizeof(BadLayout{}))   // 24
fmt.Println(unsafe.Sizeof(GoodLayout{}))  // 16
```

### C/C++ Comparison
```cpp
struct BadLayout {
    bool a;     // 1 byte + 7 padding
    int64_t b;  // 8 bytes
    bool c;     // 1 byte + 7 padding
};  // 24 bytes

// Control packing (compiler-specific)
#pragma pack(1)
struct Packed {
    bool a;
    int64_t b;
    bool c;
};  // 10 bytes, but slower access!
#pragma pack()
```

### Design Rationale

**Why Padding?**
- **CPU Alignment**: Processors access aligned memory faster
- **Example**: 64-bit value should start at 8-byte boundary
- **Cost**: Wasted space vs faster access
- **Solution**: Order fields largest to smallest

**Unsafe Package**
- **Why**: Access low-level details
- **Use Cases**: Optimization, system programming, interfacing with C
- **Danger**: Can break type safety, GC assumptions
- **Name**: "unsafe" warns you

---

## 2. Unsafe Pointers

### Converting Between Types
```go
import "unsafe"

func Float64bits(f float64) uint64 {
    return *(*uint64)(unsafe.Pointer(&f))
}

func Float64frombits(b uint64) float64 {
    return *(*float64)(unsafe.Pointer(&b))
}
```

### String to Byte Slice (Zero-Copy)
```go
func StringToBytes(s string) []byte {
    return *(*[]byte)(unsafe.Pointer(&s))
    // WARNING: Violates string immutability if you modify!
}
```

### C/C++ Comparison
```cpp
// Reinterpret cast
double f = 3.14;
uint64_t bits = *reinterpret_cast<uint64_t*>(&f);

// Or use unions
union {
    double f;
    uint64_t bits;
} u;
u.f = 3.14;
uint64_t bits = u.bits;  // Technically undefined behavior in C++
```

### Design Rationale

**Explicit Danger**
- **Package Name**: "unsafe" is a warning
- **Use Cases**: Performance-critical code, system programming
- **Go Guarantee**: Regular code never needs unsafe
- **C/C++**: Unsafe operations look normal

**Three Rules of unsafe.Pointer**:
1. Can convert between `*T` and `unsafe.Pointer`
2. Can convert between `unsafe.Pointer` and `uintptr`
3. Can do arithmetic on `uintptr`, then convert back

**Why Separate uintptr?**
- **GC Safety**: `unsafe.Pointer` tells GC "this is a pointer"
- **uintptr**: Just a number, GC ignores it
- **Danger**: If you hold uintptr, object might be garbage collected!

---

## 3. Escape Analysis

### Stack vs Heap
```go
func stackAlloc() int {
    x := 42
    return x  // x copied, stays on stack
}

func heapAlloc() *int {
    x := 42
    return &x  // x escapes to heap!
}
```

### Analysis Tool
```bash
go build -gcflags='-m' main.go
# ./main.go:6:2: moved to heap: x
```

### What Causes Escape
```go
// 1. Returning pointer to local
func escape1() *int {
    x := 42
    return &x  // Escapes
}

// 2. Storing in global
var global *int
func escape2() {
    x := 42
    global = &x  // Escapes
}

// 3. Sending to channel
func escape3() {
    x := 42
    ch <- &x  // Escapes
}

// 4. Interface conversion (sometimes)
func escape4() {
    x := 42
    fmt.Println(&x)  // Might escape (Println takes interface{})
}

// 5. Slice of unknown size
func escape5(n int) {
    slice := make([]int, n)  // Escapes if n not constant
}
```

### C/C++ Comparison
```cpp
// Manual control
int* heapAlloc() {
    int* x = new int(42);  // Explicitly heap
    return x;  // Must delete later!
}

int stackAlloc() {
    int x = 42;  // Stack
    return x;
}

// Returning pointer to stack = undefined behavior!
int* bug() {
    int x = 42;
    return &x;  // DANGER! x destroyed when function returns
}
```

### Design Rationale

**Automatic but Observable**
- **Why**: Safety (no dangling pointers) + performance (stack when possible)
- **C/C++**: Manual (error-prone) or all heap (slow)
- **Trade-off**: Less control, but safer
- **Optimization**: Compiler is conservative but getting smarter

**Reducing Escapes**
- Use values instead of pointers when possible
- Pass by value for small structs
- Use stack-friendly patterns

---

## 4. String Immutability Exploitation

### Why Immutable?
```go
// Multiple variables can safely share string data
s1 := "hello"
s2 := s1
// s1 and s2 point to same underlying bytes
// Safe because strings are immutable
```

### Substrings Share Data
```go
s := "Hello, World!"
sub := s[0:5]  // "Hello"
// sub shares s's underlying bytes (no copy!)
```

### Building Strings Efficiently
```go
// Bad: Creates new string each iteration
s := ""
for i := 0; i < 1000; i++ {
    s += "a"  // Allocates 1000 new strings!
}

// Good: strings.Builder reuses buffer
var builder strings.Builder
for i := 0; i < 1000; i++ {
    builder.WriteString("a")
}
s := builder.String()  // Only one allocation
```

### C/C++ Comparison
```cpp
// C strings are mutable (char array)
char s[] = "hello";
s[0] = 'H';  // OK

// C++ std::string is mutable
std::string s = "hello";
s[0] = 'H';  // OK

// Substring copies by default
std::string s = "Hello, World!";
std::string sub = s.substr(0, 5);  // Copies "Hello"

// String concatenation in loop
std::string s;
for (int i = 0; i < 1000; i++) {
    s += "a";  // May reallocate many times
}
// Use stringstream for efficiency
```

### Design Rationale

**Immutability Benefits**:
- Safe concurrent access (no locks needed)
- Substring without copying
- Can be map keys
- Hash once, use many times

**Cost**:
- Must allocate new string to modify
- Use `[]byte` for mutability when needed

---

## 5. Type Identity

### Named vs Unnamed Types
```go
type A int
type B int

var a A = 10
var b B = 20
// a = b  // ERROR! A and B are different types

// But underlying type is same
var i int = int(a)  // OK
```

### Struct Type Identity
```go
type Person struct {
    Name string
    Age int
}

type Employee struct {
    Name string
    Age int
}

// Different types even with same fields!
var p Person
var e Employee
// p = e  // ERROR!
```

### C/C++ Comparison
```cpp
typedef int A;
typedef int B;

A a = 10;
B b = 20;
a = b;  // OK! typedef doesn't create new type

struct Person {
    std::string name;
    int age;
};

struct Employee {
    std::string name;
    int age;
};

Person p;
Employee e;
// p = e;  // ERROR in C++, but for different reason (no conversion)
```

### Design Rationale

**Strong Type Definitions**
- **Why**: Type safety for semantically different values
- **Example**: UserID vs ProductID (both int, but shouldn't mix)
- **C/C++**: typedef is just an alias, no type safety
- **Benefit**: Compiler catches logical errors

---

## 6. Constant Folding

### Compile-Time Evaluation
```go
const (
    a = 1 + 2*3         // 7 (calculated at compile time)
    b = "hello" + "world"  // "helloworld"
    c = len("hello")    // 5
    // d = len(myVariable)  // ERROR! Not constant
)

const million = 1000000
const pi = 3.14159
const area = pi * 100 * 100  // Calculated at compile time
```

### Untyped Constants
```go
const big = 1 << 100  // Way bigger than any int type!

const limit = big >> 90  // 1024

var i8 int8 = limit   // OK! 1024 fits in int8
// var x int8 = big   // ERROR! Overflow
```

### C/C++ Comparison
```cpp
// C++ constexpr (C++11)
constexpr int a = 1 + 2*3;  // 7

// Old style
#define MILLION 1000000
const int million = 1000000;

// No untyped constants
const int big = 1 << 100;  // Overflow at definition!
```

### Design Rationale

**Untyped Constants Power**
- **Why**: Constants can be arbitrarily large
- **Type**: Assigned at use, not definition
- **Benefit**: Write 1e18 without worrying about overflow
- **C/C++**: Constants have types, limited range

---

## 7. Zero-Cost Abstractions?

### Go vs C++ Philosophy
```go
// Go: Simple abstractions with small overhead
type Reader interface {
    Read([]byte) (int, error)
}
// Cost: Interface value is 2 words (type + data pointer)
//       Virtual call through type's method table
```

```cpp
// C++: Zero-overhead abstractions
class Reader {
public:
    virtual int read(char* buf, int size) = 0;
};
// Cost: V-table pointer (1 word)
//       Virtual call through v-table
// Similar to Go, but can be optimized away if type known
```

### Design Rationale

**Go Trade-offs**:
- Small, predictable overhead
- Simpler compiler (faster compilation)
- Easier to reason about performance
- No hidden costs (no operator overloading, no template explosion)

**C++ Trade-offs**:
- Can achieve zero overhead when compiler optimizes
- But: Complex compiler, slow compilation
- Hidden costs (implicit conversions, overloads, templates)

**Philosophy**:
- Go: "A little copying is better than a little dependency"
- C++: "You don't pay for what you don't use"
- Both valid, different contexts

---

## Summary: Advanced Concepts

| Topic | C/C++ | Go | Key Insight |
|-------|-------|-----|-------------|
| Memory Layout | Manual packing | Automatic alignment | Optimize by ordering fields |
| Unsafe Operations | Normal-looking code | Explicit "unsafe" package | Safety by design |
| Stack vs Heap | Manual (new/stack) | Automatic escape analysis | Safety + performance |
| String Mutability | Mutable (char*/string) | Immutable | Concurrency-safe |
| Type Safety | Weak typedef | Strong type definitions | Catch logical errors |
| Constant Power | Limited | Untyped, arbitrary precision | More flexible |

**Philosophy**: Safety by default, performance through analysis, power when needed (unsafe).
