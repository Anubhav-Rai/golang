#!/bin/bash

# Topic 02: Data Types and Variables
cd 02_data_types_and_variables
cat > claude.md << 'EOF'
# Topic 02: Data Types and Variables

## Context
Go type system, zero values, type conversions - compared with C++.

## Structure
- `basic/` - Basic types, zero values, constants
- `intermediate/` - Type conversions, custom types, iota
- `advanced/` - Type aliases, unsafe, reflect

## Key Focus
- Zero values (no uninitialized!)
- Explicit conversions only
- Type inference with :=
- No implicit casts
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Data Types - Theory

## Basic Types

### C++ vs Go
```cpp
// C++
int x;              // Uninitialized!
int y = 10;
auto z = 20;
```

```go
// Go
var x int           // Zero value = 0
y := 10             // Type inferred
var z = 20          // Also inferred
```

## Zero Values
- int, float: `0`
- bool: `false`  
- string: `""`
- pointer: `nil`
- slice, map: `nil`

## Type List
- bool
- string
- int, int8, int16, int32, int64
- uint, uint8, uint16, uint32, uint64
- byte (alias for uint8)
- rune (alias for int32, Unicode)
- float32, float64
- complex64, complex128
EOF

cat > types.go << 'EOF'
package main

import "fmt"

func main() {
// Zero values
var i int
var f float64
var b bool
var s string
fmt.Println(i, f, b, s) // 0 0 false ""

// Short declaration
name := "Go"
age := 14
pi := 3.14

fmt.Println(name, age, pi)
}
EOF

cd ../intermediate && rm .gitkeep
cat > theory.md << 'EOF'
# Type Conversions - Theory

## C++ vs Go

### C++ (Implicit)
```cpp
int x = 10;
double y = x;      // Implicit
int z = 3.14;      // Implicit (loses precision)
```

### Go (Explicit)
```go
x := 10
y := float64(x)    // Must be explicit
z := int(3.14)     // Must be explicit
```

## Custom Types
```go
type Celsius float64
type Fahrenheit float64

// These are DIFFERENT types!
var c Celsius = 20
var f Fahrenheit = 68
// c = f  // ERROR! Different types
```

## Constants with iota
```go
const (
    Sunday = iota    // 0
    Monday           // 1
    Tuesday          // 2
)
```
EOF

cd ../../

# Topic 03: Operators
cd 03_operators_and_expressions
cat > claude.md << 'EOF'
# Topic 03: Operators and Expressions

## Context  
Go operators - differences from C++, no ternary, ++ is statement.

## Structure
- `basic/` - Arithmetic, comparison, logical operators
- `intermediate/` - Bitwise, address operators, no ternary
- `advanced/` - Operator precedence, special cases

## Key Focus
- ++ and -- are statements only
- No ternary operator (?:)
- No pointer arithmetic
- Bit clear operator (&^)
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Operators - Theory

## C++ vs Go

### Increment (BIG DIFFERENCE!)
```cpp
// C++
int x = 5;
int y = x++;     // OK
int z = ++x;     // OK
if (x++) {}      // OK
```

```go
// Go
x := 5
y := x++         // ERROR! ++ is statement
z := ++x         // ERROR! No prefix ++
x++              // OK - standalone statement
```

## No Ternary
```cpp
// C++
int x = (a > b) ? a : b;
```

```go
// Go - use if/else
var x int
if a > b {
    x = a
} else {
    x = b
}
```

## Operators
- Arithmetic: + - * / %
- Comparison: == != < > <= >=
- Logical: && || !
- Bitwise: & | ^ << >> &^
EOF

cd ../../

# Topic 04: Control Flow
cd 04_control_flow
cat > claude.md << 'EOF'
# Topic 04: Control Flow

## Context
Go control structures - simpler than C++, defer is unique.

## Structure
- `basic/` - if, for, switch basics
- `intermediate/` - Range loops, labeled breaks, defer
- `advanced/` - Defer order, panic/recover, complex control

## Key Focus
- No parentheses in if/for
- Only 'for' loop (no while!)
- Switch without fallthrough
- defer keyword (like RAII)
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Control Flow - Theory

## If Statement

### C++ vs Go
```cpp
// C++
if (x > 10) {
    // ...
}
```

```go
// Go - no parentheses!
if x > 10 {
    // ...
}

// With initialization
if y := compute(); y > 10 {
    // y scoped to if block
}
```

## For Loop (Only Loop!)

```go
// Traditional for
for i := 0; i < 10; i++ {
}

// While equivalent
for condition {
}

// Infinite loop
for {
}

// Range (like C++ range-for)
for i, v := range slice {
}
```

## Switch (No Fallthrough!)
```go
switch day {
case "Monday":
    // Automatic break!
case "Tuesday":
    // No fallthrough by default
default:
}
```
EOF

cat > loops.go << 'EOF'
package main

import "fmt"

func main() {
// Traditional for
for i := 0; i < 5; i++ {
fmt.Println(i)
}

// While equivalent
count := 0
for count < 3 {
fmt.Println("Count:", count)
count++
}

// Range over slice
nums := []int{1, 2, 3}
for i, v := range nums {
fmt.Println(i, v)
}
}
EOF

cd ../intermediate && rm .gitkeep
cat > theory.md << 'EOF'
# Defer - Theory

## C++ RAII vs Go Defer

### C++
```cpp
{
    std::lock_guard<std::mutex> lock(mtx);
    // Automatic unlock at scope end
}
```

### Go
```go
mu.Lock()
defer mu.Unlock()  // Runs when function exits
// Do work
```

## Defer Order (LIFO)
```go
func example() {
    defer fmt.Println("1")
    defer fmt.Println("2")
    defer fmt.Println("3")
}
// Prints: 3, 2, 1
```

## Common Uses
```go
// File handling
f, _ := os.Open("file.txt")
defer f.Close()

// Mutex
mu.Lock()
defer mu.Unlock()

// Cleanup
defer cleanup()
```
EOF

cd ../../

# Topic 05: Functions  
cd 05_functions
cat > claude.md << 'EOF'
# Topic 05: Functions

## Context
Go functions - multiple returns, no overloading, first-class.

## Structure
- `basic/` - Function syntax, multiple returns
- `intermediate/` - Variadic, closures, named returns
- `advanced/` - Function types, recursion, defer with functions

## Key Focus
- Multiple return values
- No function overloading
- Error as return value
- Closures
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Functions - Theory

## C++ vs Go

### Basic Function
```cpp
// C++
int add(int a, int b) {
    return a + b;
}
```

```go
// Go
func add(a, b int) int {
    return a + b
}
```

## Multiple Returns (BIG FEATURE!)
```cpp
// C++ - use tuple
std::tuple<int, int> divide(int a, int b) {
    return {a/b, a%b};
}
```

```go
// Go - built-in!
func divide(a, b int) (int, int) {
    return a / b, a % b
}

// Usage
quotient, remainder := divide(10, 3)
```

## Named Returns
```go
func divide(a, b int) (quotient, remainder int) {
    quotient = a / b
    remainder = a % b
    return  // Naked return
}
```
EOF

cat > functions.go << 'EOF'
package main

import "fmt"

// Basic function
func add(a, b int) int {
return a + b
}

// Multiple returns
func swap(x, y string) (string, string) {
return y, x
}

// Named returns
func split(sum int) (x, y int) {
x = sum * 4 / 9
y = sum - x
return
}

func main() {
fmt.Println(add(3, 5))

a, b := swap("hello", "world")
fmt.Println(a, b)

x, y := split(17)
fmt.Println(x, y)
}
EOF

cd ../intermediate && rm .gitkeep
cat > theory.md << 'EOF'
# Closures and Variadic - Theory

## Variadic Functions
```go
// Like C++ variadic templates
func sum(nums ...int) int {
    total := 0
    for _, n := range nums {
        total += n
    }
    return total
}

sum(1, 2, 3, 4)
```

## Closures
```go
func counter() func() int {
    count := 0
    return func() int {
        count++
        return count
    }
}

c := counter()
fmt.Println(c())  // 1
fmt.Println(c())  // 2
```

## Function Types
```go
type operation func(int, int) int

func apply(op operation, a, b int) int {
    return op(a, b)
}
```
EOF

cd ../../

echo "Topics 2-5 done"
