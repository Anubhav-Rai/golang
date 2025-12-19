# Data Types and Variables - Intermediate

## 1. Type Conversions Deep Dive

### Numeric Conversions
```go
// Widening conversions (safe - no data loss)
var i8 int8 = 127
var i16 int16 = int16(i8)  // OK
var i32 int32 = int32(i16) // OK

// Narrowing conversions (dangerous - potential data loss)
var i32 int32 = 300
var i8 int8 = int8(i32)  // i8 = 44 (truncated! 300 % 256 = 44)

// Float to int (truncates decimal)
var f float64 = 3.99
var i int = int(f)  // i = 3 (not rounded!)
```

### C/C++ Comparison
```cpp
// Implicit conversions can hide bugs
int32_t i32 = 300;
int8_t i8 = i32;  // Warning, but allowed! Value truncated

// Rounding vs truncation
double f = 3.99;
int i = f;  // 3 (truncates, like Go)
int rounded = lrint(f);  // Need explicit function for rounding
```

### Design Rationale
- **Explicit Danger**: Truncation is visible in code (`int8(i32)`)
- **No Warnings Ignored**: C++ warnings often ignored; Go makes it explicit
- **Philosophy**: If it can lose data, make it obvious

---

## 2. Slices vs Arrays

### Arrays (Fixed Size)
```go
var arr [5]int  // Array of 5 ints, size is part of type
arr[0] = 1

// Arrays are values (copied on assignment)
arr2 := arr  // Full copy!
arr2[0] = 99
// arr[0] still 1
```

### Slices (Dynamic Size)
```go
// Slice is a reference to underlying array
var slice []int = []int{1, 2, 3}
slice2 := slice  // Both refer to same array
slice2[0] = 99
// slice[0] also 99!

// Slice internals (pointer, length, capacity)
type slice struct {
    ptr *array
    len int
    cap int
}
```

### C/C++ Comparison
```cpp
// Arrays decay to pointers (confusing!)
int arr[5] = {1, 2, 3, 4, 5};
int* p = arr;  // arr "decays" to pointer

void func(int arr[]) {  // Actually int*
    // sizeof(arr) is wrong! It's pointer size, not array size
}

// C++ vector (like Go slice)
std::vector<int> vec = {1, 2, 3};
auto vec2 = vec;  // Deep copy by default (unlike Go slice!)
```

### Design Rationale

**Arrays Are Values**
- **Why**: Consistent with value semantics
- **C/C++ Confusion**: Arrays decay to pointers unexpectedly
- **Go Clarity**: Arrays are values, slices are references (explicit)

**Slices Are References**
- **Why**: Efficient (no copying large data)
- **Explicit**: Type tells you it's a reference (`[]int` not `[5]int`)
- **Internals**: Lightweight header (24 bytes) pointing to array

---

## 3. String Internals

### String Structure
```go
type string struct {
    ptr *byte  // Pointer to data
    len int    // Length in bytes
}

s := "Hello"
// Immutable! Can't do: s[0] = 'h'
```

### UTF-8 Encoding
```go
s := "Hello, 世界"
len(s)          // 13 (bytes, not characters!)
[]rune(s)       // Convert to rune slice to get characters
utf8.RuneCountInString(s)  // 9 (actual characters)

// Iterate bytes
for i := 0; i < len(s); i++ {
    fmt.Printf("%x ", s[i])
}

// Iterate runes (characters)
for i, r := range s {
    fmt.Printf("%d: %c
", i, r)
}
```

### C/C++ Comparison
```cpp
// C: null-terminated char array
char* s = "Hello";  // Pointer to string literal
s[0] = 'h';  // Undefined behavior! Modifying string literal

// C++ string
std::string s = "Hello";
s[0] = 'h';  // OK, mutable

// No UTF-8 by default
std::string s = "Hello, 世界";
s.length();  // Bytes, not characters
// Need external library for proper Unicode
```

### Design Rationale

**Immutability**
- **Why**: Safe concurrent access (no data races)
- **Trade-off**: Must create new string to modify
- **C Problem**: String literals in read-only memory, but type system doesn't enforce

**UTF-8 by Default**
- **Why**: Universal standard, space-efficient
- **ASCII Compatible**: ASCII strings work without change
- **Rune**: int32 can hold any Unicode code point
- **C/C++**: No standard Unicode support

---

## 4. Iota for Constants

### Advanced Patterns
```go
// Bitwise flags
type Permission uint

const (
    Read Permission = 1 << iota  // 1 << 0 = 1
    Write                         // 1 << 1 = 2
    Execute                       // 1 << 2 = 4
)

// Skip values
const (
    _ = iota  // 0 (ignored)
    KB = 1 << (10 * iota)  // 1024
    MB                      // 1048576
    GB                      // 1073741824
)

// Reset iota in new const block
const (
    A = iota  // 0
    B         // 1
)
const (
    C = iota  // 0 (reset!)
    D         // 1
)

// Multiple constants per line
const (
    a, b = iota, iota + 1  // 0, 1
    c, d                     // 1, 2
    e, f                     // 2, 3
)
```

### C/C++ Comparison
```cpp
enum Permission {
    Read = 1 << 0,     // Manual calculation
    Write = 1 << 1,
    Execute = 1 << 2
};

// Or use constexpr (C++11)
constexpr int KB = 1024;
constexpr int MB = KB * 1024;  // Must calculate
```

### Design Rationale
- **DRY**: Don't repeat patterns
- **Safety**: Compiler calculates, no human error
- **Flexibility**: Can use in expressions, not just increment
- **Power**: More powerful than C enums

---

## 5. Type Assertions

### Interface to Concrete Type
```go
var i interface{} = "hello"

// Type assertion (panics if wrong)
s := i.(string)

// Safe type assertion
s, ok := i.(string)
if ok {
    fmt.Println(s)
}

// Wrong type
n, ok := i.(int)  // n=0, ok=false
```

### Type Switch
```go
func describe(i interface{}) {
    switch v := i.(type) {
    case int:
        fmt.Printf("Integer: %d
", v)
    case string:
        fmt.Printf("String: %s
", v)
    case nil:
        fmt.Println("Nil")
    default:
        fmt.Printf("Unknown: %T
", v)
    }
}
```

### C/C++ Comparison
```cpp
// dynamic_cast (only for polymorphic types)
class Base { virtual ~Base() {} };
class Derived : public Base {};

Base* b = new Derived();
Derived* d = dynamic_cast<Derived*>(b);
if (d != nullptr) {
    // Success
}

// Or RTTI
if (typeid(*b) == typeid(Derived)) {
    // ...
}
```

### Design Rationale

**Type Switch Unique to Go**
- **Pattern Matching**: Switch on type, not just value
- **Type Safety**: Each case has correctly-typed variable
- **C/C++**: No equivalent construct

**Interface Values Always Know Type**
- **Runtime Info**: Every interface value carries type information
- **C++ RTTI**: Optional, often disabled for performance
- **Go**: Always enabled, lightweight

---

## 6. Custom Types and Methods

### Type Definitions
```go
type Celsius float64
type Fahrenheit float64

func (c Celsius) ToFahrenheit() Fahrenheit {
    return Fahrenheit(c*9/5 + 32)
}

func (f Fahrenheit) ToCelsius() Celsius {
    return Celsius((f - 32) * 5 / 9)
}

var temp Celsius = 25
fmt.Println(temp.ToFahrenheit())  // 77
```

### Design Rationale

**Methods on Any Type**
- **Flexibility**: Can add methods to any type (not just structs)
- **C/C++**: Methods only on classes/structs
- **Use Case**: Add behavior to primitive types

**Type Safety**
```go
func setTemperature(c Celsius) { /*...*/ }

setTemperature(25.0)  // ERROR! float64 is not Celsius
setTemperature(Celsius(25.0))  // OK
```

- **Prevent Bugs**: Can't accidentally use wrong units
- **Self-Documenting**: Type name indicates what value represents

---

## 7. Struct Tags

### JSON Encoding
```go
type Person struct {
    Name  string `json:"name"`
    Age   int    `json:"age,omitempty"`
    Email string `json:"-"`  // Ignore this field
}

p := Person{Name: "Alice", Age: 30, Email: "alice@example.com"}
json, _ := json.Marshal(p)
// {"name":"Alice","age":30}
```

### Multiple Tags
```go
type User struct {
    ID   int    `json:"id" db:"user_id" validate:"required"`
    Name string `json:"name" db:"username" validate:"min=3,max=50"`
}
```

### C/C++ Comparison
```cpp
// No equivalent! Would need macros or external tools
struct Person {
    std::string name;
    int age;
    std::string email;
};

// Manual JSON encoding
nlohmann::json j;
j["name"] = p.name;
j["age"] = p.age;
```

### Design Rationale

**Reflection and Metadata**
- **Why**: Declarative configuration
- **Usage**: JSON, XML, DB mapping, validation
- **Power**: Single source of truth for struct + metadata
- **C/C++**: Needs code generation or macros

---

## Summary

| Feature | C/C++ | Go | Advantage |
|---------|-------|-----|-----------|
| Arrays vs Slices | Arrays decay to pointers | Clear distinction | Less confusion |
| String | char* or std::string | Immutable, UTF-8 | Safe, modern |
| Iota | Manual enum values | Auto-generated | Less error-prone |
| Type Switch | No equivalent | First-class feature | Elegant pattern matching |
| Struct Tags | No equivalent | Reflection metadata | Powerful, declarative |

**Philosophy**: Make common patterns easy and safe.
