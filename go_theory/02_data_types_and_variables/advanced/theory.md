# Go Data Types and Variables: Advanced Concepts

## 1. Type Aliases vs Type Definitions

Go has two distinct ways to create new type names, and they have fundamentally different semantics.

### Type Definition (Creates a New Type)

```go
// Type definition: creates a NEW type
type Celsius float64
type Fahrenheit float64

// These are DIFFERENT types, even though underlying type is same
var c Celsius = 20
var f Fahrenheit = 68

// c = f  // COMPILE ERROR: cannot use f (Fahrenheit) as Celsius
c = Celsius(f)  // OK: explicit conversion
```

### Type Alias (Creates a New Name for Existing Type)

```go
// Type alias: creates an ALIAS (alternative name)
type MyInt = int  // Note the '=' sign

var a int = 42
var b MyInt = a   // OK! Same type, different names

// a and b are interchangeable - they are the SAME type
```

### The Critical Difference

```go
// Type Definition
type UserID int

// Type Alias
type UserIDAlias = int

func main() {
    var id UserID = 42
    var alias UserIDAlias = 42
    var plain int = 42

    // Type definition creates distinct type:
    // plain = id     // ERROR: cannot use id (UserID) as int
    plain = int(id)   // OK: explicit conversion needed

    // Type alias is same type:
    plain = alias     // OK: UserIDAlias IS int
    alias = plain     // OK: they're identical
}
```

### Why Type Definitions Exist

**1. Type Safety**
```go
type UserID int
type ProductID int

func GetUser(id UserID) User { ... }
func GetProduct(id ProductID) Product { ... }

// Prevents mixing up IDs:
userID := UserID(42)
productID := ProductID(42)

GetUser(userID)      // OK
GetUser(productID)   // COMPILE ERROR! Can't pass ProductID as UserID
GetUser(42)          // COMPILE ERROR! Can't pass int as UserID
```

**2. Method Attachment**
```go
type Celsius float64

// Can attach methods to defined types:
func (c Celsius) ToFahrenheit() Fahrenheit {
    return Fahrenheit(c*9/5 + 32)
}

// Cannot attach methods to built-in types or aliases:
// func (f float64) Double() float64 { ... }  // ERROR
// type F = float64
// func (f F) Double() float64 { ... }  // ERROR: can't add method to non-local type
```

**3. Documentation and Intent**
```go
// Clear semantic meaning:
type Meters float64
type Kilograms float64
type Seconds float64

func CalculateSpeed(distance Meters, time Seconds) MetersPerSecond {
    return MetersPerSecond(float64(distance) / float64(time))
}
```

### Why Type Aliases Exist

**1. Gradual Code Migration**
```go
// Old package
package oldpkg
type OldType struct { ... }

// New package - during migration
package newpkg
import "oldpkg"
type OldType = oldpkg.OldType  // Alias for compatibility

// Code can use either - they're the same type
```

**2. Simplifying Complex Types**
```go
// Type alias for complex type
type Handler = func(http.ResponseWriter, *http.Request)

// Now you can write:
var h Handler = myHandlerFunc
// Instead of:
var h func(http.ResponseWriter, *http.Request) = myHandlerFunc
```

**3. Standard Library Examples**
```go
// byte is an alias for uint8
type byte = uint8

// rune is an alias for int32
type rune = int32

// This is why:
var b byte = 255
var u uint8 = b     // OK: same type
```

### Method Set Inheritance

```go
// Type definition does NOT inherit methods:
type MyInt int
type YourInt MyInt

// MyInt has no methods (int has no methods)
// But if we add one:
func (m MyInt) Double() MyInt { return m * 2 }

// YourInt does NOT have Double() method!
// YourInt's underlying type is MyInt, but it's a new type

var y YourInt = 5
// y.Double()  // ERROR: YourInt has no method Double
MyInt(y).Double()  // OK: convert to MyInt first
```

---

## 2. Named vs Unnamed Types

### Definitions

```go
// Named type: has a declared type name
type Point struct {
    X, Y int
}

// Unnamed type (also called "type literal" or "anonymous type")
struct {
    X, Y int
}

// More examples:
type IntSlice []int      // Named: IntSlice
[]int                    // Unnamed: []int

type StringMap map[string]string  // Named: StringMap
map[string]string                 // Unnamed: map[string]string

type Handler func(int) int  // Named: Handler
func(int) int               // Unnamed: func(int) int
```

### The Assignability Rules

**Key insight:** Unnamed types with identical structure are interchangeable!

```go
// Two named types - not assignable even if identical structure
type Point1 struct { X, Y int }
type Point2 struct { X, Y int }

var p1 Point1 = Point1{1, 2}
var p2 Point2 = p1  // ERROR: cannot use Point1 as Point2

// Named type and unnamed type with same structure - assignable!
var p3 struct { X, Y int } = p1  // OK!
var p4 Point1 = p3               // OK!

// Two unnamed types with same structure - assignable!
var p5 struct { X, Y int }
var p6 struct { X, Y int } = p5  // OK!
```

### Why This Matters: API Design

```go
// In library code, using named types:
package graphics

type Point struct {
    X, Y int
}

func Draw(p Point) { ... }

// Client code:
graphics.Draw(graphics.Point{10, 20})  // Must use graphics.Point

// OR use unnamed type matching:
graphics.Draw(struct{ X, Y int }{10, 20})  // Also works!
```

### Underlying Types

Every type has an **underlying type**:

```go
type MyInt int          // Underlying type: int
type YourInt MyInt      // Underlying type: int (NOT MyInt!)

type Point struct{X,Y int}  // Underlying type: struct{X,Y int}

// For unnamed types, underlying type is itself:
// []int underlying type is []int
// map[string]int underlying type is map[string]int
```

### Underlying Type Rules

```go
// Conversion allowed between types with same underlying type:
type A int
type B int

var a A = 1
var b B = B(a)  // OK: same underlying type (int)

// Also works for composite types:
type IntSlice1 []int
type IntSlice2 []int

var s1 IntSlice1 = []int{1, 2, 3}
var s2 IntSlice2 = IntSlice2(s1)  // OK: same underlying type
```

### Named Types and Comparability

```go
// Struct comparability depends on fields:
type Comparable struct {
    X, Y int  // int is comparable
}

type NotComparable struct {
    Data []int  // slices are not comparable
}

c1 := Comparable{1, 2}
c2 := Comparable{1, 2}
fmt.Println(c1 == c2)  // OK: true

n1 := NotComparable{[]int{1}}
n2 := NotComparable{[]int{1}}
// fmt.Println(n1 == n2)  // COMPILE ERROR: struct containing slice is not comparable
```

### Practical Implications

**1. Interface Satisfaction**
```go
// Named type can satisfy interfaces:
type MyReader struct { ... }

func (r MyReader) Read(p []byte) (int, error) { ... }

var r io.Reader = MyReader{}  // OK: satisfies io.Reader

// Unnamed types can also satisfy interfaces:
var r2 io.Reader = struct {
    // ... some fields
}{
    // ... initialized with a Read method somehow?
}
// Actually unnamed struct types can't have methods, so this is contrived
```

**2. Struct Tag Matching**
```go
// Struct tags are part of type identity:
type A struct {
    Field int `json:"field"`
}
type B struct {
    Field int `json:"other"`  // Different tag!
}

// A and B are different types - tags matter
var a A
var b B = B(a)  // ERROR! Can't convert - tags differ

// But unnamed types follow same rules:
var x struct { Field int `json:"field"` }
var y A = x  // OK: tags match
```

**3. Embedding and Promotion**
```go
type Inner struct {
    Value int
}

func (i Inner) Method() string { return "inner" }

type Outer struct {
    Inner  // Embedded named type
}

o := Outer{Inner{42}}
o.Value      // Promoted field access
o.Method()   // Promoted method call

// With unnamed type:
type Outer2 struct {
    struct { Value int }  // Embedded unnamed type
}
// Cannot access fields directly - unnamed embedded types
// are accessed via type name (which they don't have!)
```

---

## Deep Design Questions Answered

### Why Force Explicit Conversions? (Safety vs Convenience)

**The Safety Argument:**
```go
// Every conversion in Go is visible and intentional
var money int64 = 1000000000000  // 1 trillion cents
var display int32 = int32(money)  // VISIBLE: potential overflow

// In C/C++, silent truncation:
// int32_t display = money;  // Silently becomes garbage
```

**The Cost:**
- More verbose code
- More typing
- Looks "clunky" to C++ developers initially

**The Benefit:**
- No silent data corruption
- Bugs are compilation errors, not runtime surprises
- Code review can spot problematic conversions
- Self-documenting: you see where precision is lost

### Why Zero Values? (Prevents Entire Class of Bugs)

**Bugs eliminated:**
1. **Uninitialized variable reads** - Memory contains known value
2. **Dangling pointer use** - nil is safer than garbage pointer
3. **Logic errors from garbage** - Deterministic behavior
4. **Security vulnerabilities** - No stack/heap data leakage

```go
// The "usable zero value" idiom:
type Counter struct {
    n int  // zero value is 0 - perfect!
    mu sync.Mutex  // zero value is unlocked mutex - perfect!
}

// No constructor needed - zero value works:
var c Counter
c.mu.Lock()
c.n++
c.mu.Unlock()
```

### How Does This Make Go Safer Than C/C++?

| C/C++ Danger | Go Solution |
|--------------|-------------|
| Uninitialized variables | Zero values |
| Silent integer overflow | Defined behavior (wraps) |
| Implicit narrowing conversion | Explicit conversion only |
| Buffer overflow (strings) | Bounds-checked, immutable strings |
| Use-after-free | Garbage collection |
| Null pointer dereference | Nil is explicitly checked pattern |
| Type confusion | Strong typing, no implicit conversions |

### What Flexibility is Lost vs Gained?

**Lost:**
- Can't mix numeric types freely (more verbose)
- Can't use strings as byte arrays directly
- Can't have uninitialized variables (rare valid use cases)
- Less control over memory layout (GC overhead)

**Gained:**
- Type safety across the entire codebase
- Predictable, reproducible behavior
- Fewer debugging sessions for type-related bugs
- Clearer code that shows all type boundaries
- Better tooling support (compiler catches more)

---

## Summary: Go's Type System Philosophy

Go's type system embodies the principle that **correctness is more important than convenience**:

1. **Explicit over implicit** - Conversions, declarations, everything is visible
2. **Safe defaults** - Zero values, bounds checking, GC
3. **Simple rules** - No complex overloading, template metaprogramming
4. **Compile-time safety** - Catch bugs before runtime

For C/C++ developers, the adjustment is:
- Accept more verbosity in exchange for safety
- Trust the compiler to optimize explicit conversions
- Embrace the "boring" type system that prevents bugs
- Use type definitions for semantic meaning, not just aliases
