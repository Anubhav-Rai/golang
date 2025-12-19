#!/bin/bash

# Topic 06: Arrays and Slices
cd 06_arrays_and_slices
cat > claude.md << 'EOF'
# Topic 06: Arrays and Slices

## Context
Most important Go data structure - slices (NOT like C++ vectors!).

## Structure
- `basic/` - Arrays, slice basics, append
- `intermediate/` - Slice internals, capacity, copy
- `advanced/` - Memory layout, performance, tricks

## Key Focus
- Arrays are values (copy on assign!)
- Slices are references
- append, len, cap
- Slice internals: pointer + len + cap
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Slices - Theory

## C++ vs Go

### C++ Vector
```cpp
std::vector<int> v;
v.push_back(1);
v.push_back(2);
```

### Go Slice
```go
var s []int
s = append(s, 1)
s = append(s, 2)
```

## Arrays (Rarely Used)
```go
var arr [5]int      // Fixed size, value type
arr[0] = 1
```

## Slices (Use These!)
```go
// Create slice
s := []int{1, 2, 3}
s := make([]int, 5)      // len=5, cap=5
s := make([]int, 0, 10)  // len=0, cap=10

// Append
s = append(s, 4, 5, 6)

// Length and capacity
len(s)  // number of elements
cap(s)  // capacity
```

## Slicing
```go
s := []int{0, 1, 2, 3, 4, 5}
s[1:4]   // [1 2 3]
s[:3]    // [0 1 2]
s[3:]    // [3 4 5]
s[:]     // all
```
EOF

cat > slices.go << 'EOF'
package main

import "fmt"

func main() {
// Create slice
s := []int{1, 2, 3}
fmt.Println(s)

// Append
s = append(s, 4, 5)
fmt.Println(s)

// Slicing
fmt.Println(s[1:3])  // [2 3]

// Make with capacity
s2 := make([]int, 0, 10)
fmt.Printf("len=%d cap=%d\n", len(s2), cap(s2))
}
EOF

cd ../intermediate && rm .gitkeep
cat > theory.md << 'EOF'
# Slice Internals - Theory

## Slice Structure
```
┌────────────────┐
│  ptr  │ len │ cap │
└───┬────────────┘
    │
    ▼
┌───┬───┬───┬───┬───┐
│ 1 │ 2 │ 3 │ 4 │ 5 │
└───┴───┴───┴───┴───┘
```

## Copy vs Assignment
```go
s1 := []int{1, 2, 3}
s2 := s1          // s2 references same array!
s2[0] = 99        // Modifies s1 too!

// To copy:
s3 := make([]int, len(s1))
copy(s3, s1)      // Now independent
```

## Pre-allocation
```go
// Bad - many allocations
var result []int
for i := 0; i < 1000; i++ {
    result = append(result, i)
}

// Good - one allocation
result := make([]int, 0, 1000)
for i := 0; i < 1000; i++ {
    result = append(result, i)
}
```
EOF

cd ../../

# Topic 07: Maps
cd 07_maps
cat > claude.md << 'EOF'
# Topic 07: Maps

## Context
Built-in hash maps - like C++ unordered_map but simpler.

## Structure
- `basic/` - Creating, accessing, deleting
- `intermediate/` - Comma-ok idiom, iteration, maps as sets

## Key Focus
- Built-in hash maps
- No ordered iteration
- Comma-ok for existence check
- Zero value is nil (can't use!)
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Maps - Theory

## C++ vs Go

### C++
```cpp
std::unordered_map<string, int> m;
m["key"] = 42;
if (m.find("key") != m.end()) {}
```

### Go
```go
m := make(map[string]int)
m["key"] = 42
if val, ok := m["key"]; ok {
    // key exists
}
```

## Creating Maps
```go
// make
m := make(map[string]int)

// Literal
m := map[string]int{
    "one": 1,
    "two": 2,
}

// Zero value is nil!
var m map[string]int  // nil map, can't use!
```

## Operations
```go
m[key] = value      // Set
val := m[key]       // Get (zero if missing)
delete(m, key)      // Delete
val, ok := m[key]   // Check existence
```
EOF

cat > maps.go << 'EOF'
package main

import "fmt"

func main() {
// Create map
m := make(map[string]int)
m["age"] = 25
m["year"] = 2024

// Access
fmt.Println(m["age"])

// Check existence
if val, ok := m["age"]; ok {
fmt.Println("Found:", val)
}

// Delete
delete(m, "year")

// Iterate
for k, v := range m {
fmt.Println(k, v)
}
}
EOF

cd ../../

# Topic 08: Structs
cd 08_structs
cat > claude.md << 'EOF'
# Topic 08: Structs

## Context
Go structs - composition over inheritance, no classes.

## Structure
- `basic/` - Struct definition, methods, constructors
- `intermediate/` - Embedding, struct tags
- `advanced/` - Functional options pattern

## Key Focus
- No classes, only structs
- Composition via embedding
- Struct tags for metadata
- Constructor functions
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Structs - Theory

## C++ vs Go

### C++ Class
```cpp
class Person {
private:
    string name;
    int age;
public:
    Person(string n, int a) : name(n), age(a) {}
    void greet();
};
```

### Go Struct
```go
type Person struct {
    name string  // lowercase = private
    Age  int     // Uppercase = public
}

// Constructor function
func NewPerson(name string, age int) *Person {
    return &Person{name: name, Age: age}
}
```

## Creating Structs
```go
// Literal
p := Person{name: "Alice", Age: 30}

// Pointer
p := &Person{name: "Bob", Age: 25}

// Zero value
var p Person  // name="", Age=0
```
EOF

cat > structs.go << 'EOF'
package main

import "fmt"

type Person struct {
Name string
Age  int
}

// Constructor
func NewPerson(name string, age int) *Person {
return &Person{Name: name, Age: age}
}

func main() {
p1 := Person{Name: "Alice", Age: 30}
fmt.Println(p1)

p2 := NewPerson("Bob", 25)
fmt.Println(p2)
}
EOF

cd ../../

# Topic 09: Pointers
cd 09_pointers
cat > claude.md << 'EOF'
# Topic 09: Pointers

## Context
Go pointers - safer than C++, no arithmetic, GC'd.

## Structure
- `basic/` - Pointer basics, new, address-of
- `intermediate/` - Pointer vs value receivers, escape analysis

## Key Focus
- No pointer arithmetic
- Automatic dereferencing (p.field)
- Safe to return local address
- new() vs &
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Pointers - Theory

## C++ vs Go

### C++
```cpp
int x = 10;
int* p = &x;
(*p)++;
p++;  // Pointer arithmetic
```

### Go
```go
x := 10
p := &x
(*p)++
// p++  // ERROR! No pointer arithmetic

// Auto-dereference
type Person struct { Name string }
p := &Person{Name: "Alice"}
p.Name = "Bob"  // Auto-dereference!
```

## Returning Pointers (Safe!)
```go
func createInt() *int {
    x := 42
    return &x  // OK! Escapes to heap
}
```

## new() Function
```go
p := new(int)     // Allocates, returns pointer
*p = 42

// Equivalent to:
x := 0
p := &x
```
EOF

cd ../../

# Topic 10: Methods and Interfaces
cd 10_methods_and_interfaces
cat > claude.md << 'EOF'
# Topic 10: Methods and Interfaces

## Context
Go's polymorphism - implicit interfaces, duck typing.

## Structure
- `basic/` - Methods, interfaces basics
- `intermediate/` - Interface composition, type assertions
- `advanced/` - Empty interface, interface internals

## Key Focus
- Methods on any type
- Implicit interface implementation
- Duck typing
- No inheritance
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Interfaces - Theory

## C++ vs Go

### C++ (Explicit)
```cpp
class Shape {
public:
    virtual double Area() = 0;
};

class Circle : public Shape {
    double Area() override { }
};
```

### Go (Implicit!)
```go
type Shape interface {
    Area() float64
}

type Circle struct {
    Radius float64
}

// Implements Shape automatically!
func (c Circle) Area() float64 {
    return 3.14 * c.Radius * c.Radius
}
```

## Methods
```go
type Person struct {
    Name string
}

// Value receiver
func (p Person) Greet() {
    fmt.Println("Hi", p.Name)
}

// Pointer receiver (can modify)
func (p *Person) SetName(name string) {
    p.Name = name
}
```
EOF

cat > interfaces.go << 'EOF'
package main

import "fmt"

type Speaker interface {
Speak() string
}

type Dog struct {
Name string
}

func (d Dog) Speak() string {
return "Woof!"
}

type Cat struct {
Name string
}

func (c Cat) Speak() string {
return "Meow!"
}

func main() {
var s Speaker

s = Dog{Name: "Buddy"}
fmt.Println(s.Speak())

s = Cat{Name: "Whiskers"}
fmt.Println(s.Speak())
}
EOF

cd ../../

echo "Topics 6-10 done"
