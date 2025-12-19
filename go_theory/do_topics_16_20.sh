#!/bin/bash

# Topic 16: Testing
cd 16_testing
cat > claude.md << 'EOF'
# Topic 16: Testing

## Context
Built-in testing - no external frameworks needed.

## Structure
- `basic/` - Test basics, table-driven tests
- `intermediate/` - Benchmarks, examples, coverage

## Key Focus
- go test command
- *_test.go files
- Table-driven tests
- Benchmarking
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Testing - Theory

## C++ vs Go

### C++ (Google Test)
```cpp
TEST(MathTest, Addition) {
    EXPECT_EQ(Add(2, 3), 5);
}
```

### Go (Built-in)
```go
func TestAdd(t *testing.T) {
    result := Add(2, 3)
    if result != 5 {
        t.Errorf("Expected 5, got %d", result)
    }
}
```

## File Naming
- Test file: `math_test.go`
- Same package: `package math`
- Run: `go test`

## Table-Driven Tests
```go
func TestAdd(t *testing.T) {
    tests := []struct{
        name string
        a, b int
        want int
    }{
        {"positive", 2, 3, 5},
        {"negative", -1, -2, -3},
        {"zero", 0, 0, 0},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := Add(tt.a, tt.b)
            if got != tt.want {
                t.Errorf("got %d, want %d", got, tt.want)
            }
        })
    }
}
```
EOF

cd ../intermediate && rm .gitkeep
cat > theory.md << 'EOF'
# Benchmarks - Theory

## Benchmarking
```go
func BenchmarkAdd(b *testing.B) {
    for i := 0; i < b.N; i++ {
        Add(2, 3)
    }
}
```

Run: `go test -bench=.`

## Coverage
```bash
go test -cover
go test -coverprofile=coverage.out
go tool cover -html=coverage.out
```

## Example Tests
```go
func ExampleAdd() {
    result := Add(2, 3)
    fmt.Println(result)
    // Output: 5
}
```
EOF

cd ../../

# Topic 17: Reflection
cd 17_reflection
cat > claude.md << 'EOF'
# Topic 17: Reflection

## Context
Runtime type inspection - more powerful than C++ RTTI.

## Structure
- `basic/` - reflect.Type, reflect.Value basics
- `intermediate/` - Struct tags, type assertions

## Key Focus
- reflect package
- Type and Value
- Use sparingly (slow)
- Struct tag reading
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Reflection - Theory

## Basic Reflection
```go
import "reflect"

var x float64 = 3.4

t := reflect.TypeOf(x)
fmt.Println(t)  // float64

v := reflect.ValueOf(x)
fmt.Println(v)  // 3.4
```

## Struct Tags
```go
type User struct {
    Name string `json:"name" db:"user_name"`
    Age  int    `json:"age"`
}

t := reflect.TypeOf(User{})
field, _ := t.FieldByName("Name")
tag := field.Tag.Get("json")  // "name"
```

## Type Assertions
```go
var i interface{} = "hello"

s := i.(string)        // Panic if wrong type
s, ok := i.(string)    // Safe
```
EOF

cd ../../

# Topic 18: Generics
cd 18_generics
cat > claude.md << 'EOF'
# Topic 18: Generics

## Context
Type parameters (Go 1.18+) - simpler than C++ templates.

## Structure
- `basic/` - Type parameters, constraints
- `intermediate/` - Generic functions and types

## Key Focus
- [T any] syntax
- Constraints
- comparable interface
- Type inference
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Generics - Theory

## C++ vs Go

### C++ Templates
```cpp
template<typename T>
T Max(T a, T b) {
    return a > b ? a : b;
}
```

### Go Generics
```go
func Max[T comparable](a, b T) T {
    if a > b {
        return a
    }
    return b
}
```

## Generic Types
```go
type Stack[T any] struct {
    items []T
}

func (s *Stack[T]) Push(item T) {
    s.items = append(s.items, item)
}

func (s *Stack[T]) Pop() T {
    item := s.items[len(s.items)-1]
    s.items = s.items[:len(s.items)-1]
    return item
}

// Usage
stack := Stack[int]{}
stack.Push(1)
```

## Constraints
```go
type Number interface {
    int | int64 | float64
}

func Sum[T Number](nums []T) T {
    var sum T
    for _, n := range nums {
        sum += n
    }
    return sum
}
```
EOF

cd ../../

# Topic 19: Memory Management
cd 19_memory_management
cat > claude.md << 'EOF'
# Topic 19: Memory Management

## Context
Garbage collection, profiling, optimization.

## Structure
- `basic/` - GC basics, escape analysis
- `intermediate/` - pprof, memory profiling
- `advanced/` - Optimization techniques

## Key Focus
- Automatic GC
- Escape analysis
- sync.Pool
- Memory profiling
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Memory Management - Theory

## C++ vs Go

### C++ (Manual)
```cpp
int* p = new int(42);
delete p;  // Manual!

auto up = std::make_unique<int>(42);
// Auto cleanup
```

### Go (GC)
```go
p := new(int)
*p = 42
// No delete! GC handles it

// Safe to return local address
func create() *int {
    x := 42
    return &x  // Escapes to heap
}
```

## Escape Analysis
```bash
go build -gcflags="-m" main.go
# Shows what escapes to heap
```

## Memory Stats
```go
var m runtime.MemStats
runtime.ReadMemStats(&m)
fmt.Printf("Alloc = %v MB\n", m.Alloc/1024/1024)
```
EOF

cd ../intermediate && rm .gitkeep
cat > theory.md << 'EOF'
# Memory Profiling - Theory

## pprof
```go
import _ "net/http/pprof"

go func() {
    http.ListenAndServe("localhost:6060", nil)
}()
```

Visit: http://localhost:6060/debug/pprof/

## sync.Pool
```go
var bufferPool = sync.Pool{
    New: func() interface{} {
        return make([]byte, 1024)
    },
}

buf := bufferPool.Get().([]byte)
defer bufferPool.Put(buf)
```
EOF

cd ../../

# Topic 20: Advanced Patterns
cd 20_advanced_patterns
cat > claude.md << 'EOF'
# Topic 20: Advanced Patterns

## Context
Production-ready patterns and idioms.

## Structure
- `basic/` - Functional options, context
- `intermediate/` - Worker pools, pipelines
- `advanced/` - Circuit breaker, rate limiting

## Key Focus
- Functional options
- Context for cancellation
- Worker pools
- Production patterns
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Advanced Patterns - Theory

## Functional Options
```go
type Server struct {
    host string
    port int
}

type Option func(*Server)

func WithPort(port int) Option {
    return func(s *Server) {
        s.port = port
    }
}

func NewServer(host string, opts ...Option) *Server {
    s := &Server{host: host, port: 8080}
    for _, opt := range opts {
        opt(s)
    }
    return s
}

// Usage
server := NewServer("localhost", WithPort(9000))
```

## Context Pattern
```go
ctx, cancel := context.WithTimeout(
    context.Background(),
    5*time.Second,
)
defer cancel()

select {
case <-ctx.Done():
    return ctx.Err()
case result := <-ch:
    return nil
}
```
EOF

cd ../intermediate && rm .gitkeep
cat > theory.md << 'EOF'
# Worker Pool - Theory

## Worker Pool Pattern
```go
func worker(id int, jobs <-chan int, results chan<- int) {
    for job := range jobs {
        results <- job * 2
    }
}

func main() {
    jobs := make(chan int, 100)
    results := make(chan int, 100)
    
    // Start workers
    for w := 1; w <= 3; w++ {
        go worker(w, jobs, results)
    }
    
    // Send jobs
    for j := 1; j <= 5; j++ {
        jobs <- j
    }
    close(jobs)
    
    // Collect results
    for a := 1; a <= 5; a++ {
        <-results
    }
}
```

## Pipeline Pattern
```go
func gen(nums ...int) <-chan int {
    out := make(chan int)
    go func() {
        defer close(out)
        for _, n := range nums {
            out <- n
        }
    }()
    return out
}

func square(in <-chan int) <-chan int {
    out := make(chan int)
    go func() {
        defer close(out)
        for n := range in {
            out <- n * n
        }
    }()
    return out
}
```
EOF

cd ../../

echo "Topics 16-20 done"
