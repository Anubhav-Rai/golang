# Go Pointers - Learning Context

## Topic Overview
Pointers in Go are simpler and safer than C/C++ - no pointer arithmetic, no void*, automatic dereferencing.

## Basic Pointer Syntax

**Same as C/C++:**
```go
var x int = 10
var p *int = &x  // p points to x

fmt.Println(*p)  // 10 (dereference)
*p = 20
fmt.Println(x)   // 20 (modified via pointer)
```

**Short declaration:**
```go
x := 10
p := &x  // type inferred as *int
```

## Key Differences from C/C++

### 1. No Pointer Arithmetic

**C/C++:**
```cpp
int arr[5] = {1, 2, 3, 4, 5};
int* p = arr;
p++;       // points to arr[1]
p += 2;    // points to arr[3]
*(p + 1)   // accesses arr[4]
```

**Go - NOT ALLOWED:**
```go
arr := [5]int{1, 2, 3, 4, 5}
p := &arr[0]
// p++      // ERROR! Invalid operation
// p += 2   // ERROR!

// Use slices instead
slice := arr[:]
```

### 2. Automatic Dereferencing

**C/C++:**
```cpp
struct Point { int x, y; };
Point* p = new Point{10, 20};
p->x = 30;  // need arrow operator
(*p).x = 30;  // or dereference then dot
```

**Go - Automatic:**
```go
type Point struct { X, Y int }
p := &Point{10, 20}
p.X = 30      // automatically dereferenced!
(*p).X = 30   // also works, but unnecessary
```

### 3. No void* or Type Casting

**C/C++:**
```cpp
void* p = malloc(100);
int* ip = (int*)p;  // explicit cast
```

**Go:**
```go
// No void* - use interface{} or any
var v interface{} = 42

// Type assertion needed
i, ok := v.(int)

// unsafe package for low-level (avoid if possible)
```

## Passing by Value vs Pointer

**C/C++:**
```cpp
void modify(int x) {
    x = 100;  // only modifies copy
}

void modifyPtr(int* x) {
    *x = 100;  // modifies original
}

void modifyRef(int& x) {
    x = 100;  // modifies original
}
```

**Go - No References, Only Pointers:**
```go
func modify(x int) {
    x = 100  // only modifies copy
}

func modifyPtr(x *int) {
    *x = 100  // modifies original
}

// No reference syntax like C++

x := 42
modify(x)       // x still 42
modifyPtr(&x)   // x now 100
```

## new() vs &

**C++:**
```cpp
int* p = new int;      // heap allocation
int* p = new int(42);  // initialized
delete p;              // manual cleanup
```

**Go - Garbage Collected:**
```go
// new() returns pointer with zero value
p := new(int)  // *p == 0

// & with literal (more common)
p := &MyStruct{field: value}

// No delete needed - garbage collected!
```

## Pointer to Struct

**Common pattern:**
```go
type Person struct {
    Name string
    Age  int
}

// Constructor returns pointer (convention)
func NewPerson(name string, age int) *Person {
    return &Person{
        Name: name,
        Age:  age,
    }
}

// Value receiver - operates on copy
func (p Person) GetAge() int {
    return p.Age
}

// Pointer receiver - can modify
func (p *Person) SetAge(age int) {
    p.Age = age
}

// Usage
person := NewPerson("Alice", 25)
person.SetAge(26)  // modifies original
```

## nil Pointers

**Same concept as C++ nullptr:**
```go
var p *int  // nil

if p == nil {
    fmt.Println("nil pointer")
}

// Dereferencing nil = panic (like segfault)
// *p = 10  // panic!

// Safe pattern
if p != nil {
    *p = 10
}
```

## Returning Pointers

**C++:**
```cpp
int* createInt() {
    int x = 42;  // local variable
    return &x;   // DANGER! Returns pointer to stack
}
```

**Go - Safe, Escapes to Heap:**
```go
func createInt() *int {
    x := 42
    return &x  // Safe! Go moves to heap
}

// Compiler analyzes escape
p := createInt()  // x escaped to heap
```

## Pointer to Array vs Slice

**Arrays:**
```go
arr := [3]int{1, 2, 3}
p := &arr  // *[3]int

(*p)[0] = 100  // modify through pointer
p[0] = 100     // auto-dereference
```

**Slices (already reference-like):**
```go
slice := []int{1, 2, 3}
// Usually don't need pointer to slice
// Pass slice directly

func modify(s []int) {
    s[0] = 100  // modifies original data
}

// Pointer to slice if reassigning
func append(s *[]int, v int) {
    *s = append(*s, v)
}
```

## Double Pointers

**Less common than C++:**
```go
x := 42
p := &x    // *int
pp := &p   // **int

fmt.Println(**pp)  // 42

**pp = 100
fmt.Println(x)  // 100
```

## Pointer Receivers - When to Use

**Guidelines:**
```go
type Small struct {
    x int
}

type Large struct {
    data [1000000]int
}

// Small type, no modification - value receiver
func (s Small) Method() {
    // operates on copy (fine, small)
}

// Large type - use pointer (avoid copy)
func (l *Large) Method() {
    // avoid copying large struct
}

// Need to modify - pointer receiver
func (s *Small) Modify() {
    s.x = 100  // modifies original
}

// Rule: If any method has pointer receiver,
// all should (consistency)
```

## Memory Allocation

**Stack vs Heap:**
```go
func stackAlloc() {
    x := 42  // might be on stack
    // x dies when function returns
}

func heapAlloc() *int {
    x := 42
    return &x  // escapes to heap!
}

// Compiler decides based on escape analysis
// You don't control it (unlike C++ stack vs heap)
```

## unsafe Package

**Low-level operations (avoid unless necessary):**
```go
import "unsafe"

// Pointer to arbitrary type
var x int = 42
p := unsafe.Pointer(&x)

// Convert to different type
fp := (*float64)(p)  // dangerous!

// Get size
size := unsafe.Sizeof(x)

// ONLY use when:
// - Interfacing with C code
// - Performance critical code
// - You really know what you're doing
```

## Comparing Pointers

**Valid:**
```go
var p1, p2 *int
p1 == p2      // true if same address
p1 == nil     // true if nil

// But can't compare what they point to directly
// *p1 == *p2  // compares values (OK if not nil)
```

## Learning Path

### Basic Level
- Pointer declaration and dereferencing
- Address-of operator (&)
- Passing pointers to functions
- nil pointers
- Basic pointer safety

### Intermediate Level
- Pointer receivers vs value receivers
- Escape analysis concept
- new() vs make() vs &
- Automatic dereferencing
- Returning pointers safely

### Advanced Level
- Memory layout understanding
- Escape analysis in detail
- unsafe package operations
- Performance implications
- Interfacing with C (cgo)

## Key Differences from C/C++

1. **No pointer arithmetic** - Use slices
2. **Automatic dereferencing** - p.field works
3. **No void*** - Use interface{} or any
4. **Garbage collected** - No manual delete
5. **Escape analysis** - Safe to return local addresses
6. **No references** - Only pointers
7. **Simpler syntax** - Less error-prone

## Common Patterns

### Optional Values
```go
func findUser(id int) *User {
    // Return nil if not found
    if notFound {
        return nil
    }
    return &user
}

// Usage
if user := findUser(123); user != nil {
    // use user
}
```

### Modification Flag
```go
func process(data *[]int) bool {
    if data == nil {
        return false
    }
    *data = append(*data, 42)
    return true
}
```

## Common Pitfalls

1. **Dereferencing nil** - Always check!
2. **Pointer to loop variable** - Common bug
3. **Unnecessary pointers** - Not always better
4. **Confusing slice/map** (reference) **with pointer**
5. **Mixing value and pointer receivers** - Be consistent
6. **Premature optimization** - Profile first

## Loop Variable Gotcha

**Classic bug:**
```go
var pointers []*int
numbers := []int{1, 2, 3}

for _, n := range numbers {
    pointers = append(pointers, &n)  // BUG!
    // All point to same variable!
}

// Fix: copy to new variable
for _, n := range numbers {
    n := n  // shadow variable
    pointers = append(pointers, &n)
}
```

## Practice Context

Focus on:
- Understanding value vs pointer semantics
- Choosing receiver types correctly
- Safe pointer usage patterns
- Avoiding common pointer bugs
- Converting C++ pointer code to Go
- Understanding when Go uses heap vs stack
