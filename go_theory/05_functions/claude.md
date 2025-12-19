# Go Functions - Learning Context

## Topic Overview
Functions in Go are simpler yet more powerful than C/C++, with multiple return values and first-class function support.

## Basic Function Declaration

**C/C++:**
```cpp
int add(int a, int b) {
    return a + b;
}
```

**Go - Return Type After Parameters:**
```go
func add(a int, b int) int {
    return a + b
}

// Multiple params of same type
func add(a, b int) int {
    return a + b
}
```

## Multiple Return Values - Game Changer!

**C++:** Need struct/tuple or out parameters
```cpp
// Option 1: struct
struct Result { int quotient; int remainder; };
Result divide(int a, int b) {
    return {a / b, a % b};
}

// Option 2: out parameters
void divide(int a, int b, int& quotient, int& remainder) {
    quotient = a / b;
    remainder = a % b;
}
```

**Go - Native Multiple Returns:**
```go
func divide(a, b int) (int, int) {
    return a / b, a % b
}

// Usage
quotient, remainder := divide(10, 3)

// Ignore return value with _
quotient, _ := divide(10, 3)
```

## Named Return Values

**Unique to Go:**
```go
// Named returns are pre-declared
func divide(a, b int) (quotient, remainder int) {
    quotient = a / b
    remainder = a % b
    return  // naked return, returns quotient and remainder
}

// Same as:
func divide(a, b int) (quotient, remainder int) {
    quotient = a / b
    remainder = a % b
    return quotient, remainder
}
```

## Error Handling Pattern

**C++:** Exceptions
```cpp
int divide(int a, int b) {
    if (b == 0) {
        throw std::runtime_error("division by zero");
    }
    return a / b;
}
```

**Go - Error as Return Value:**
```go
func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

// Usage - ALWAYS check errors
result, err := divide(10, 0)
if err != nil {
    // handle error
    log.Fatal(err)
}
fmt.Println(result)
```

## Variadic Functions

**C++:** Variable arguments (old style or parameter pack)
```cpp
// Old C style
void printf(const char* fmt, ...);

// C++11 variadic templates
template<typename... Args>
void print(Args... args) { }
```

**Go - Simpler Syntax:**
```go
// ... means variadic
func sum(numbers ...int) int {
    total := 0
    for _, n := range numbers {
        total += n
    }
    return total
}

// Usage
sum(1, 2, 3)
sum(1, 2, 3, 4, 5)

// Spread slice
nums := []int{1, 2, 3}
sum(nums...)  // like *args in Python
```

## First-Class Functions

**C++:** Function pointers, std::function
```cpp
int add(int a, int b) { return a + b; }

// Function pointer
int (*op)(int, int) = add;

// std::function
std::function<int(int, int)> op = add;
```

**Go - Functions are Values:**
```go
func add(a, b int) int { return a + b }

// Function as variable
var op func(int, int) int = add
result := op(1, 2)

// Anonymous function
op = func(a, b int) int {
    return a * b
}
```

## Closures

**Both C++ and Go support closures:**

**C++:**
```cpp
auto makeAdder(int x) {
    return [x](int y) { return x + y; };
}

auto add5 = makeAdder(5);
int result = add5(3);  // 8
```

**Go:**
```go
func makeAdder(x int) func(int) int {
    return func(y int) int {
        return x + y
    }
}

add5 := makeAdder(5)
result := add5(3)  // 8
```

## Methods (on Types)

**C++:** Member functions
```cpp
class Rectangle {
    int width, height;
public:
    int area() {
        return width * height;
    }
};
```

**Go - Methods on Types:**
```go
type Rectangle struct {
    width, height int
}

// Method with receiver
func (r Rectangle) area() int {
    return r.width * r.height
}

// Usage
rect := Rectangle{10, 5}
fmt.Println(rect.area())
```

## Pointer vs Value Receivers

**C++:** Automatic with references
```cpp
class Point {
    int x, y;
public:
    void move(int dx, int dy) {
        x += dx;  // modifies object
        y += dy;
    }
};
```

**Go - Explicit Choice:**
```go
type Point struct {
    x, y int
}

// Value receiver - receives copy
func (p Point) distance() float64 {
    // p is a copy, can't modify original
    return math.Sqrt(float64(p.x*p.x + p.y*p.y))
}

// Pointer receiver - can modify
func (p *Point) move(dx, dy int) {
    p.x += dx  // modifies original
    p.y += dy
}
```

## defer in Functions

**Useful for cleanup:**
```go
func readFile(filename string) ([]byte, error) {
    f, err := os.Open(filename)
    if err != nil {
        return nil, err
    }
    defer f.Close()  // Always runs before return
    
    data, err := ioutil.ReadAll(f)
    if err != nil {
        return nil, err  // defer runs here too
    }
    return data, nil  // and here
}
```

## init() Function

**Special function - runs before main:**
```go
func init() {
    // Runs automatically when package is imported
    // Used for initialization
    // Multiple init() functions allowed
}

func main() {
    // init() already ran
}
```

## Recursive Functions

**Same as C/C++:**
```go
func factorial(n int) int {
    if n <= 1 {
        return 1
    }
    return n * factorial(n-1)
}
```

## Function Types and Signatures

```go
// Define function type
type BinaryOp func(int, int) int

func add(a, b int) int { return a + b }
func multiply(a, b int) int { return a * b }

// Use as type
var op BinaryOp = add
op = multiply

// Higher-order function
func apply(a, b int, op BinaryOp) int {
    return op(a, b)
}

result := apply(5, 3, add)
```

## Learning Path

### Basic Level
- Function declaration
- Parameters and return values
- Multiple returns
- Error handling pattern
- Basic methods

### Intermediate Level
- Named returns
- Variadic functions
- First-class functions
- Closures
- Pointer vs value receivers
- defer mechanics

### Advanced Level
- Function types and interfaces
- Method values and expressions
- panic and recover
- Performance implications
- Inlining and optimization
- Reflection on functions

## Key Differences from C/C++

1. **Multiple return values** - Native support
2. **Named returns** - Can omit return values
3. **No function overloading** - Different from C++
4. **Methods on any type** - Not just structs
5. **No exceptions** - Return error values
6. **defer keyword** - Simpler than destructors
7. **init() function** - Automatic initialization

## Common Patterns

### Error Handling
```go
result, err := operation()
if err != nil {
    return err  // or handle
}
// use result
```

### Options Pattern
```go
type Options struct {
    timeout time.Duration
    retries int
}

func doSomething(opts Options) { }

// Or functional options
type Option func(*Options)

func WithTimeout(d time.Duration) Option {
    return func(o *Options) {
        o.timeout = d
    }
}
```

## Common Pitfalls

1. **Ignoring errors** - Always check
2. **Named returns** can be confusing
3. **Closures and loop variables** - Common bug
4. **Value vs pointer receivers** - Choose wisely
5. **defer in loops** - Can cause issues

## Practice Context

Focus on:
- Multiple return values and error handling
- Writing methods with proper receivers
- Using closures effectively
- Understanding defer behavior
- Converting C++ classes to Go types
