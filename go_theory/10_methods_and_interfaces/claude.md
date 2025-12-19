# Go Methods and Interfaces - Learning Context

## Topic Overview
Interfaces in Go are implicit and fundamentally different from C++ - they enable duck typing and composition-based polymorphism.

## Methods Recap

**C++ Member Functions:**
```cpp
class Rectangle {
private:
    int width, height;
public:
    int area() { return width * height; }
};
```

**Go - Methods on Types:**
```go
type Rectangle struct {
    Width, Height int
}

func (r Rectangle) Area() int {
    return r.Width * r.Height
}
```

## Interfaces - The Big Difference!

**C++ (Explicit Inheritance):**
```cpp
class Shape {
public:
    virtual int area() = 0;  // pure virtual
    virtual ~Shape() {}
};

class Rectangle : public Shape {  // EXPLICIT
public:
    int area() override { return width * height; }
};
```

**Go (Implicit Implementation):**
```go
// Define interface
type Shape interface {
    Area() int
}

// Just implement the method - NO "implements" keyword!
type Rectangle struct {
    Width, Height int
}

func (r Rectangle) Area() int {
    return r.Width * r.Height
}

// Rectangle implements Shape implicitly!
var s Shape = Rectangle{10, 5}
```

## Interface Basics

**Defining interfaces:**
```go
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

// Composed interface
type ReadWriter interface {
    Reader
    Writer
}
```

## Empty Interface

**Accepts anything:**
```go
// interface{} or any (Go 1.18+)
func printAnything(v interface{}) {
    fmt.Println(v)
}

// Go 1.18+
func printAnything(v any) {
    fmt.Println(v)
}

printAnything(42)
printAnything("hello")
printAnything([]int{1, 2, 3})
```

## Type Assertions

**C++:** dynamic_cast
```cpp
Shape* s = new Rectangle();
Rectangle* r = dynamic_cast<Rectangle*>(s);
if (r != nullptr) {
    // success
}
```

**Go:**
```go
var i interface{} = "hello"

// Type assertion
s := i.(string)  // panics if wrong type

// Safe type assertion
s, ok := i.(string)
if ok {
    fmt.Println("is string:", s)
}

n, ok := i.(int)  // n=0, ok=false
```

## Type Switches

**Unique to Go:**
```go
func describe(i interface{}) {
    switch v := i.(type) {
    case int:
        fmt.Println("int:", v)
    case string:
        fmt.Println("string:", v)
    case bool:
        fmt.Println("bool:", v)
    case Rectangle:
        fmt.Println("rectangle with area:", v.Area())
    default:
        fmt.Println("unknown type")
    }
}
```

## Interface Values

**Two components: type and value:**
```go
var w io.Writer

// nil interface
fmt.Printf("(%v, %T)\n", w, w)  // (<nil>, <nil>)

// Concrete type and value
w = os.Stdout
fmt.Printf("(%v, %T)\n", w, w)  // (&{...}, *os.File)

// nil concrete value but non-nil interface!
var p *bytes.Buffer  // nil pointer
w = p
fmt.Printf("(%v, %T)\n", w, w)  // (<nil>, *bytes.Buffer)
w == nil  // FALSE! Type is not nil
```

## Common Standard Interfaces

### Stringer (like toString)
```go
type Stringer interface {
    String() string
}

type Person struct {
    Name string
    Age  int
}

func (p Person) String() string {
    return fmt.Sprintf("%s (%d)", p.Name, p.Age)
}

// fmt.Println automatically uses String()
p := Person{"Alice", 25}
fmt.Println(p)  // Alice (25)
```

### Error Interface
```go
type error interface {
    Error() string
}

// Custom error
type MyError struct {
    Code int
    Message string
}

func (e MyError) Error() string {
    return fmt.Sprintf("Error %d: %s", e.Code, e.Message)
}

func doSomething() error {
    return MyError{404, "not found"}
}
```

### io.Reader and io.Writer
```go
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

// Many types implement these
var r io.Reader
r = os.Stdin
r = bytes.NewReader([]byte("hello"))
r = strings.NewReader("world")
```

## Interface Composition

**Building interfaces from interfaces:**
```go
type ReadCloser interface {
    Reader
    Closer
}

type WriteCloser interface {
    Writer
    Closer
}

type ReadWriteCloser interface {
    Reader
    Writer
    Closer
}
```

## Duck Typing

**If it walks like a duck...**
```go
type Duck interface {
    Quack()
}

type RealDuck struct{}
func (d RealDuck) Quack() { fmt.Println("Quack!") }

type Person struct{}
func (p Person) Quack() { fmt.Println("I'm quacking!") }

// Both implement Duck!
func makeItQuack(d Duck) {
    d.Quack()
}

makeItQuack(RealDuck{})  // Quack!
makeItQuack(Person{})    // I'm quacking!
```

## Polymorphism Example

**C++ virtual functions:**
```cpp
class Animal {
public:
    virtual void speak() = 0;
};

class Dog : public Animal {
    void speak() override { cout << "Woof\n"; }
};

class Cat : public Animal {
    void speak() override { cout << "Meow\n"; }
};
```

**Go interfaces:**
```go
type Animal interface {
    Speak()
}

type Dog struct{}
func (d Dog) Speak() { fmt.Println("Woof") }

type Cat struct{}
func (c Cat) Speak() { fmt.Println("Meow") }

// No inheritance needed!
animals := []Animal{Dog{}, Cat{}}
for _, a := range animals {
    a.Speak()
}
```

## Interface Satisfaction

**Rules:**
```go
// Pointer receiver methods
type Counter struct {
    count int
}

func (c *Counter) Increment() {
    c.count++
}

type Incrementer interface {
    Increment()
}

// Only *Counter implements interface, not Counter
var inc Incrementer = &Counter{}  // OK
// var inc Incrementer = Counter{}  // ERROR!

// Value receiver - both value and pointer satisfy
func (c Counter) Value() int {
    return c.count
}

type Getter interface {
    Value() int
}

var g Getter = Counter{}   // OK
var g2 Getter = &Counter{}  // Also OK
```

## Empty Interface Uses

**Container types:**
```go
// Store anything
values := []interface{}{
    42,
    "hello",
    true,
    []int{1, 2, 3},
}

// Maps with any value type
data := map[string]interface{}{
    "name": "Alice",
    "age":  25,
    "active": true,
}
```

## Interface Best Practices

### Accept interfaces, return structs
```go
// Good
func ProcessData(r io.Reader) (*Result, error) {
    // accepts any Reader
    return &Result{}, nil
}

// Bad (too specific)
func ProcessData(f *os.File) (*Result, error) {
    return &Result{}, nil
}
```

### Keep interfaces small
```go
// Good - single responsibility
type Reader interface {
    Read(p []byte) (n int, err error)
}

// Bad - too many methods
type DataProcessor interface {
    Read() []byte
    Write([]byte)
    Process()
    Validate()
    Transform()
}
```

## Type Embedding in Interfaces

```go
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Closer interface {
    Close() error
}

// Embedded interfaces
type ReadCloser interface {
    Reader  // embeds Reader
    Closer  // embeds Closer
}

// Must implement both
type MyReadCloser struct{}
func (m MyReadCloser) Read(p []byte) (int, error) { return 0, nil }
func (m MyReadCloser) Close() error { return nil }
```

## Learning Path

### Basic Level
- Defining interfaces
- Implicit implementation
- Basic type assertions
- Common standard interfaces
- Empty interface

### Intermediate Level
- Type switches
- Interface composition
- Interface values (type, value)
- nil interface vs nil value
- Stringer, error interfaces

### Advanced Level
- Interface design patterns
- Performance implications
- Reflection with interfaces
- Method sets and pointers
- Advanced composition patterns

## Key Differences from C/C++

1. **Implicit implementation** - No "implements" keyword
2. **Duck typing** - If it has the methods, it's the type
3. **No virtual keyword** - All interface methods are "virtual"
4. **Interface composition** - Embed interfaces in interfaces
5. **Empty interface** - Accepts anything (like void*)
6. **Type assertions** - Runtime type checking
7. **Small interfaces** - Convention: 1-3 methods

## Common Patterns

### Strategy Pattern
```go
type SortStrategy interface {
    Sort([]int)
}

type BubbleSort struct{}
func (b BubbleSort) Sort(data []int) { /* ... */ }

type QuickSort struct{}
func (q QuickSort) Sort(data []int) { /* ... */ }

func SortData(data []int, strategy SortStrategy) {
    strategy.Sort(data)
}
```

### Dependency Injection
```go
type Database interface {
    Query(string) ([]Row, error)
}

type UserService struct {
    db Database  // depends on interface
}

func NewUserService(db Database) *UserService {
    return &UserService{db: db}
}
```

## Common Pitfalls

1. **Nil interface vs nil value** - Tricky distinction
2. **Interface pollution** - Too many small interfaces
3. **Pointer receiver** requirements - Only *T implements
4. **Empty interface overuse** - Loses type safety
5. **Large interfaces** - Hard to implement
6. **Premature abstraction** - YAGNI principle

## Practice Context

Focus on:
- Understanding implicit implementation
- When to use interfaces vs concrete types
- Type assertions and type switches
- Designing small, focused interfaces
- Converting C++ virtual functions to Go interfaces
- Interface-based testing (mocking)
