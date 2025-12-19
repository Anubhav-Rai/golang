# Go Operators and Expressions - Learning Context

## Topic Overview
Operators in Go are similar to C/C++ but with some key differences for safety and simplicity.

## Arithmetic Operators

**Same as C/C++:**
```go
+ - * / %    // Addition, subtraction, multiplication, division, modulo
++ --        // Increment, decrement
```

**Key Difference:**
```cpp
// C/C++ - can be expression
int x = 5;
int y = x++;  // y = 5, x = 6

// Go - ONLY statements, not expressions
x := 5
// y := x++  // ERROR!
x++          // OK, but returns nothing
y := x       // y = 6
```

**No prefix increment:**
```go
++x  // ERROR in Go
x++  // OK
```

## Comparison Operators

**Same as C/C++:**
```go
== != < > <= >=
```

**String comparison works:**
```go
"abc" == "abc"  // true
"abc" < "def"   // true (lexicographic)
```

**Struct comparison:**
```cpp
// C++ - needs operator==
struct Point { int x, y; };
Point p1, p2;
// p1 == p2;  // Needs operator== defined

// Go - automatic if comparable
type Point struct { x, y int }
p1 := Point{1, 2}
p2 := Point{1, 2}
p1 == p2  // true! No operator overloading needed
```

## Logical Operators

**Same as C/C++:**
```go
&& || !     // AND, OR, NOT
```

**Short-circuit evaluation:**
```go
// Same behavior as C/C++
if ptr != nil && ptr.value > 0 {
    // ptr.value only evaluated if ptr != nil
}
```

## Bitwise Operators

**Similar to C/C++:**
```go
&   // AND
|   // OR
^   // XOR (in C/C++ it's also ^)
&^  // AND NOT (bit clear) - UNIQUE TO GO!
<<  // Left shift
>>  // Right shift
```

**Unique operator - AND NOT:**
```go
x := 0b1100
y := 0b1010
z := x &^ y  // 0b0100
// Clears bits in x where y has 1
// Equivalent to: x & (^y)
```

## Assignment Operators

**Same as C/C++:**
```go
=  +=  -=  *=  /=  %=
&= |=  ^=  <<= >>=  &^=
```

**Multiple assignment (unique feature):**
```go
// Swap without temp variable
a, b := 10, 20
a, b = b, a  // a=20, b=10

// Multiple returns
func divide(a, b int) (int, int) {
    return a / b, a % b
}
q, r := divide(10, 3)  // q=3, r=1
```

## Pointer Operators

**Similar to C/C++:**
```go
&  // Address-of
*  // Dereference
```

**Key differences:**
```cpp
// C++ - pointer arithmetic allowed
int arr[5];
int* p = arr;
p++;  // moves to next element
p += 2;  // moves 2 elements

// Go - NO pointer arithmetic!
arr := [5]int{1, 2, 3, 4, 5}
p := &arr[0]
// p++  // ERROR!
// Use slices instead
```

## Operator Precedence

**Similar to C/C++ (highest to lowest):**
```
1. * / % << >> & &^
2. + - | ^
3. == != < <= > >=
4. &&
5. ||
```

**Use parentheses for clarity:**
```go
result := (a + b) * c  // Clear intention
```

## Type Assertions and Type Switches

**Not in C++ (unique to Go):**
```go
var i interface{} = "hello"

// Type assertion
s := i.(string)  // OK
// n := i.(int)  // Runtime panic!

// Safe type assertion
s, ok := i.(string)  // s="hello", ok=true
n, ok := i.(int)     // n=0, ok=false

// Type switch
switch v := i.(type) {
case string:
    fmt.Println("string:", v)
case int:
    fmt.Println("int:", v)
default:
    fmt.Println("unknown type")
}
```

## Comma Ok Idiom

**Unique Go pattern:**
```go
// Map lookup
value, ok := myMap[key]
if ok {
    // key exists
}

// Channel receive
value, ok := <-ch
if ok {
    // channel not closed
}

// Type assertion
str, ok := value.(string)
if ok {
    // is a string
}
```

## No Operator Overloading

**C++:**
```cpp
class Complex {
    Complex operator+(const Complex& other) { ... }
};
Complex a, b, c;
c = a + b;  // operator+ called
```

**Go:**
```go
// No operator overloading!
// Must use methods explicitly
type Complex struct { real, imag float64 }
func (c Complex) Add(other Complex) Complex { ... }

c1 := Complex{1, 2}
c2 := Complex{3, 4}
c3 := c1.Add(c2)  // Must call method explicitly
```

## Ternary Operator - DOES NOT EXIST!

**C/C++:**
```cpp
int max = (a > b) ? a : b;
```

**Go - use if/else:**
```go
var max int
if a > b {
    max = a
} else {
    max = b
}

// Or as function
func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

## Learning Path

### Basic Level
- Arithmetic operators
- Comparison operators
- Logical operators
- Assignment operators
- Increment/decrement as statements

### Intermediate Level
- Bitwise operations
- Bit clear operator (&^)
- Multiple assignments
- Comma-ok idiom
- Type assertions

### Advanced Level
- Operator precedence optimization
- Bit manipulation techniques
- Performance implications
- Unsafe operations
- Assembly-level understanding

## Common Pitfalls

1. **No ternary operator** - Use if/else
2. **++ and -- are statements** - Can't use in expressions
3. **No pointer arithmetic** - Use slices
4. **No operator overloading** - Use methods
5. **Implicit vs explicit** - Type conversions must be explicit
6. **Bit clear operator** - Learn &^ for flag operations

## Practice Context

Focus on:
- Converting C++ expressions to Go
- Understanding operator precedence
- Using comma-ok idiom
- Bit manipulation without pointer arithmetic
- Working with type assertions
