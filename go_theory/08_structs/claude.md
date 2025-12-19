# Go Structs - Learning Context

## Topic Overview
Structs in Go are similar to C/C++ structs but simpler - no classes, inheritance, or constructors.

## Basic Struct Definition

**C++:**
```cpp
struct Person {
    string name;
    int age;
    
    Person(string n, int a) : name(n), age(a) {}  // constructor
};

class Person {
private:
    string name;
    int age;
public:
    Person(string n, int a) : name(n), age(a) {}
};
```

**Go - No Classes:**
```go
type Person struct {
    Name string  // Exported (public)
    age  int     // Unexported (private to package)
}

// No constructors - use functions
func NewPerson(name string, age int) Person {
    return Person{
        Name: name,
        age:  age,
    }
}
```

## Creating Struct Instances

**Multiple ways:**
```go
type Point struct {
    X, Y int
}

// 1. Literal with field names
p1 := Point{X: 10, Y: 20}

// 2. Literal with positional (not recommended)
p2 := Point{10, 20}

// 3. Zero value
var p3 Point  // X=0, Y=0

// 4. Pointer with new
p4 := new(Point)  // returns *Point, fields zero

// 5. Address operator
p5 := &Point{X: 10, Y: 20}  // returns *Point
```

## Anonymous Structs

**Unique to Go:**
```go
// Anonymous struct - no type name
person := struct {
    name string
    age  int
}{
    name: "Alice",
    age:  25,
}

// Useful for temporary structures
response := struct {
    Status  int
    Message string
}{
    Status:  200,
    Message: "OK",
}
```

## Struct Embedding (Composition)

**C++:** Inheritance
```cpp
class Animal {
public:
    string name;
    void speak() { }
};

class Dog : public Animal {
public:
    string breed;
};

Dog d;
d.name = "Buddy";  // inherited
d.speak();         // inherited
```

**Go - Composition over Inheritance:**
```go
type Animal struct {
    Name string
}

func (a Animal) Speak() {
    fmt.Println("Animal sound")
}

// Embedding
type Dog struct {
    Animal  // embedded field
    Breed string
}

d := Dog{
    Animal: Animal{Name: "Buddy"},
    Breed:  "Golden",
}

d.Name         // promoted field
d.Speak()      // promoted method
d.Animal.Name  // can also access explicitly
```

## Tags (Metadata)

**No equivalent in C++:**
```go
type User struct {
    ID        int    `json:"id"`
    Name      string `json:"name"`
    Email     string `json:"email" validate:"required"`
    Password  string `json:"-"`  // ignore in JSON
    CreatedAt time.Time `json:"created_at,omitempty"`
}

// Used by reflection
// encoding/json uses these tags
user := User{ID: 1, Name: "Alice"}
data, _ := json.Marshal(user)
// {"id":1,"name":"Alice","email":""}
```

## Methods on Structs

**C++:**
```cpp
class Rectangle {
    int width, height;
public:
    int area() {
        return width * height;
    }
};
```

**Go:**
```go
type Rectangle struct {
    Width, Height int
}

// Value receiver
func (r Rectangle) Area() int {
    return r.Width * r.Height
}

// Pointer receiver (can modify)
func (r *Rectangle) Scale(factor int) {
    r.Width *= factor
    r.Height *= factor
}

// Usage
rect := Rectangle{10, 5}
area := rect.Area()
rect.Scale(2)  // modifies rect
```

## Struct Comparison

**C++:** Needs operator==
```cpp
struct Point { int x, y; };
Point p1{1, 2}, p2{1, 2};
// p1 == p2;  // ERROR unless operator== defined
```

**Go - Automatic if Comparable:**
```go
type Point struct {
    X, Y int
}

p1 := Point{1, 2}
p2 := Point{1, 2}
p1 == p2  // true

// But structs with slices/maps NOT comparable
type Container struct {
    Data []int
}
// c1 == c2  // ERROR! Contains slice
```

## Empty Struct

**Zero memory - useful for sets:**
```go
type Empty struct{}

// Size is 0 bytes!
var e Empty
fmt.Println(unsafe.Sizeof(e))  // 0

// Use as set
set := make(map[string]struct{})
set["key"] = struct{}{}

// Or as signal
done := make(chan struct{})
done <- struct{}{}
```

## Nested Structs

**C/C++ and Go similar:**
```go
type Address struct {
    Street string
    City   string
}

type Person struct {
    Name    string
    Address Address  // nested
}

p := Person{
    Name: "Alice",
    Address: Address{
        Street: "123 Main St",
        City:   "Boston",
    },
}

fmt.Println(p.Address.City)
```

## Struct Pointers

**Automatic dereferencing:**
```go
type Point struct {
    X, Y int
}

p := &Point{1, 2}

// Both work - automatic dereferencing
p.X = 10      // Go automatically dereferences
(*p).X = 10   // explicit (not needed)

// Unlike C++ where you need ->
```

## Constructor Pattern

**No built-in constructors:**
```go
type Database struct {
    connection *sql.DB
    timeout    time.Duration
}

// Constructor function (convention: NewType)
func NewDatabase(connStr string, timeout time.Duration) (*Database, error) {
    conn, err := sql.Open("postgres", connStr)
    if err != nil {
        return nil, err
    }
    
    return &Database{
        connection: conn,
        timeout:    timeout,
    }, nil
}

// Usage
db, err := NewDatabase("localhost", 5*time.Second)
if err != nil {
    log.Fatal(err)
}
```

## Functional Options Pattern

**Flexible initialization:**
```go
type Server struct {
    host    string
    port    int
    timeout time.Duration
}

type Option func(*Server)

func WithPort(port int) Option {
    return func(s *Server) {
        s.port = port
    }
}

func WithTimeout(timeout time.Duration) Option {
    return func(s *Server) {
        s.timeout = timeout
    }
}

func NewServer(host string, options ...Option) *Server {
    s := &Server{
        host:    host,
        port:    8080,  // default
        timeout: 30 * time.Second,  // default
    }
    
    for _, opt := range options {
        opt(s)
    }
    
    return s
}

// Usage
s := NewServer("localhost", 
    WithPort(9000),
    WithTimeout(1*time.Minute),
)
```

## Visibility Rules

**Capitalization matters:**
```go
type Person struct {
    Name   string  // Exported (public)
    age    int     // Unexported (private to package)
    Email  string  // Exported
    salary float64 // Unexported
}

// Other packages can access Name and Email
// but not age and salary
```

## Learning Path

### Basic Level
- Struct definition
- Creating instances
- Accessing fields
- Methods with receivers
- Visibility rules

### Intermediate Level
- Struct embedding
- Struct tags
- Anonymous structs
- Constructor patterns
- Pointer vs value receivers

### Advanced Level
- Functional options pattern
- Memory layout
- Padding and alignment
- Reflection with structs
- Performance optimization

## Key Differences from C/C++

1. **No classes** - Only structs
2. **No inheritance** - Use composition (embedding)
3. **No constructors** - Use factory functions
4. **Capital = exported** - No public/private keywords
5. **Automatic dereferencing** - p.X works for pointer
6. **No operator overloading** - Use methods
7. **Tags for metadata** - Used by reflection
8. **Methods separate** - Not inside struct definition

## Common Patterns

### Builder Pattern
```go
type Query struct {
    table  string
    where  string
    limit  int
}

func NewQuery(table string) *Query {
    return &Query{table: table}
}

func (q *Query) Where(condition string) *Query {
    q.where = condition
    return q
}

func (q *Query) Limit(n int) *Query {
    q.limit = n
    return q
}

// Chaining
query := NewQuery("users").
    Where("age > 18").
    Limit(10)
```

### Zero Value Useful
```go
// Design structs to be useful when zero-valued
type Buffer struct {
    data []byte
}

func (b *Buffer) Write(p []byte) {
    b.data = append(b.data, p...)  // works with nil slice!
}

var buf Buffer  // zero value
buf.Write([]byte("hello"))  // works!
```

## Common Pitfalls

1. **Forgetting pointer receivers** - Modifications lost
2. **Large struct copies** - Use pointers
3. **Comparing incomparable structs** - Contains slices/maps
4. **Unexported fields** - Not accessible in other packages
5. **No default values** - All fields get zero values
6. **Embedding conflicts** - Name collision with promoted fields

## Practice Context

Focus on:
- Struct design and organization
- Choosing value vs pointer receivers
- Using embedding effectively
- Constructor pattern conventions
- Understanding visibility rules
- Converting C++ classes to Go structs
