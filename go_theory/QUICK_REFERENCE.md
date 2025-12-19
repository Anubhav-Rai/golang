# Go Quick Reference for C/C++ Developers

## Syntax Comparison Cheat Sheet

### Hello World
```go
// C++                          // Go
#include <iostream>             package main
using namespace std;            import "fmt"
                                
int main() {                    func main() {
    cout << "Hello\n";              fmt.Println("Hello")
    return 0;                   }
}
```

### Variables
```go
// C++                          // Go
int x = 10;                     x := 10              // short
const int y = 20;               const y = 20
string s = "hello";             s := "hello"
auto z = 30;                    z := 30              // type inferred
```

### Functions
```go
// C++                          // Go
int add(int a, int b) {         func add(a, b int) int {
    return a + b;                   return a + b
}                               }

// Multiple returns (Go only)
tuple<int,int> divide(...);     func divide(a, b int) (int, int) {
                                    return a/b, a%b
                                }
```

### Loops
```go
// C++                          // Go
for (int i=0; i<10; i++) {}     for i := 0; i < 10; i++ {}
while (condition) {}            for condition {}
do {} while (condition);        // No do-while in Go
for (auto& x : vec) {}          for _, x := range slice {}
```

### Pointers
```go
// C++                          // Go
int* p = &x;                    p := &x
*p = 10;                        *p = 10
p++;                            // No pointer arithmetic!
int** pp = &p;                  pp := &p
```

### Structs/Classes
```go
// C++                          // Go
class Point {                   type Point struct {
  private:                          x, y int  // unexported (private)
    int x, y;                       X, Y int  // exported (public)
  public:                       }
    int getX() { return x; }    
};                              func (p Point) GetX() int {
                                    return p.X
Point p;                        }
p.getX();                       
                                p := Point{X: 1, Y: 2}
                                p.GetX()
```

### Inheritance vs Composition
```go
// C++ (inheritance)            // Go (composition)
class Animal {                  type Animal struct {
    void speak();                   Name string
};                              }
                                func (a Animal) Speak() {}
class Dog : public Animal {     
    void bark();                type Dog struct {
};                                  Animal  // embedded
                                    Breed string
                                }
                                
Dog d;                          d := Dog{}
d.speak();                      d.Speak()  // promoted
```

### Interfaces
```go
// C++ (explicit)               // Go (implicit)
class Shape {                   type Shape interface {
  public:                           Area() float64
    virtual double area() = 0;  }
};                              
                                type Rectangle struct {
class Rectangle : public Shape      Width, Height float64
{                               }
    double area() override;     
};                              func (r Rectangle) Area() float64 {
                                    return r.Width * r.Height
                                }
                                
                                // Rectangle implements Shape automatically!
```

### Memory Management
```go
// C++                          // Go
int* p = new int(42);           p := new(int)
delete p;                       // No delete! GC handles it

unique_ptr<int> up =            // Just use regular pointers
    make_unique<int>(42);       p := &someValue
// Automatic cleanup            // GC cleans up

vector<int> v;                  slice := make([]int, 0)
v.push_back(1);                 slice = append(slice, 1)
```

### Error Handling
```go
// C++ (exceptions)             // Go (return values)
try {                           result, err := divide(10, 0)
    int r = divide(10, 0);      if err != nil {
} catch (exception& e) {            log.Fatal(err)
    cerr << e.what();           }
}                               // Use result

throw runtime_error("err");     return 0, errors.New("err")
```

### Concurrency
```go
// C++ (threads)                // Go (goroutines)
#include <thread>               
                                
void task() { }                 func task() { }
                                
thread t(task);                 go task()  // Lightweight!
t.join();                       // Use channels or WaitGroup

mutex mtx;                      var mu sync.Mutex
lock_guard<mutex> lock(mtx);    mu.Lock()
                                defer mu.Unlock()
```

## Common Go Idioms

### Error Checking
```go
// ALWAYS check errors
result, err := operation()
if err != nil {
    return err  // or handle appropriately
}
```

### Defer for Cleanup
```go
file, err := os.Open("file.txt")
if err != nil {
    return err
}
defer file.Close()  // Runs when function exits

// Multiple defers execute in LIFO order
```

### Guard Clauses
```go
func process(data []int) error {
    if len(data) == 0 {
        return ErrEmptyData
    }
    if data[0] < 0 {
        return ErrNegative
    }
    // Main logic at lowest indent
    return nil
}
```

### Comma-ok Idiom
```go
// Map lookup
if value, ok := myMap[key]; ok {
    // key exists
}

// Type assertion
if str, ok := value.(string); ok {
    // is string
}

// Channel receive
if value, ok := <-ch; ok {
    // channel not closed
}
```

### Range Loops
```go
// Slice
for i, v := range slice {
    // i = index, v = value
}

// Just values
for _, v := range slice {}

// Just indices
for i := range slice {}

// Map
for key, value := range myMap {}
```

## Type Conversions

```go
// C++: Implicit and explicit       // Go: ALL explicit
int x = 10;                         var x int = 10
double y = x;    // implicit        var y float64 = float64(x)
int z = (int)3.14;                  var z int = int(3.14)

// String conversions
string s = to_string(42);           s := strconv.Itoa(42)
int n = stoi("42");                 n, _ := strconv.Atoi("42")
```

## Zero Values

```go
var i int       // 0
var f float64   // 0.0
var b bool      // false
var s string    // ""
var p *int      // nil
var slice []int // nil
var m map[K]V   // nil
```

## Common Packages

```go
import "fmt"        // Formatted I/O
import "os"         // OS functions
import "io"         // I/O primitives
import "errors"     // Error handling
import "time"       // Time operations
import "sync"       // Synchronization
import "context"    // Cancellation
import "net/http"   // HTTP client/server
import "encoding/json"  // JSON encoding
import "strings"    // String utilities
import "strconv"    // String conversions
```

## Useful Commands

```bash
# Format code
go fmt ./...

# Run tests
go test ./...

# Run with race detector
go test -race

# Run benchmarks
go test -bench=.

# Get coverage
go test -cover

# Build
go build

# Install dependencies
go get package

# Tidy dependencies
go mod tidy

# View documentation
go doc fmt.Println

# Check for issues
go vet ./...
```

## Gotchas from C++

1. **No implicit conversions** - Must be explicit
2. **++ and -- are statements** - Can't use in expressions
3. **No ternary operator** - Use if/else
4. **Capitalization = visibility** - Not public/private keywords
5. **No pointer arithmetic** - Use slices instead
6. **Slices are references** - Assignment doesn't copy
7. **Range loop copies values** - Use index if modifying
8. **Defer is LIFO** - Last defer runs first
9. **Interfaces are implicit** - No "implements" keyword
10. **Channels block** - Send/receive until ready

## Printf Format Verbs

```go
%v    // Default format
%+v   // With field names (structs)
%#v   // Go syntax representation
%T    // Type
%t    // Boolean
%d    // Integer
%f    // Float
%s    // String
%p    // Pointer
%c    // Character (rune)
%q    // Quoted string
%x    // Hex
```

## When to Use What

### Slice vs Array
- **Array**: Fixed size, rarely used
- **Slice**: Dynamic, use 99% of the time

### Pointer vs Value
- **Value**: Small structs, immutable
- **Pointer**: Large structs, need to modify

### Channel vs Mutex
- **Channel**: Communicate, pass ownership
- **Mutex**: Protect shared state

### Interface vs Struct
- **Interface**: Behavior definition
- **Struct**: Data storage

### Error vs Panic
- **Error**: Expected failures
- **Panic**: Programming errors, unrecoverable

## Testing Quick Reference

```go
// Test function
func TestAdd(t *testing.T) {
    result := Add(2, 3)
    if result != 5 {
        t.Errorf("Expected 5, got %d", result)
    }
}

// Table-driven test
tests := []struct{
    name string
    a, b int
    want int
}{
    {"positive", 2, 3, 5},
    {"negative", -1, -2, -3},
}

for _, tt := range tests {
    t.Run(tt.name, func(t *testing.T) {
        got := Add(tt.a, tt.b)
        if got != tt.want {
            t.Errorf("got %d, want %d", got, tt.want)
        }
    })
}

// Benchmark
func BenchmarkAdd(b *testing.B) {
    for i := 0; i < b.N; i++ {
        Add(2, 3)
    }
}
```

## Context Patterns

```go
// Timeout
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

// Cancellation
ctx, cancel := context.WithCancel(context.Background())
defer cancel()

// Value (use sparingly!)
ctx = context.WithValue(ctx, key, value)

// Check cancellation
select {
case <-ctx.Done():
    return ctx.Err()
default:
    // continue
}
```

---

**Remember:** Go is not C++ with different syntax. Embrace Go's simplicity and idioms!
