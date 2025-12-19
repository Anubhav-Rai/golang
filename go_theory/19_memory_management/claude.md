# Go Memory Management - Learning Context

## Topic Overview
Go has automatic garbage collection, unlike C++ manual memory management. Understanding memory behavior is important for performance.

## Memory Management Comparison

**C++ (Manual):**
```cpp
// Stack allocation
int x = 42;

// Heap allocation
int* p = new int(42);
delete p;  // MUST manually free

// Smart pointers (RAII)
std::unique_ptr<int> up = std::make_unique<int>(42);
std::shared_ptr<int> sp = std::make_shared<int>(42);
// Automatic cleanup
```

**Go (Garbage Collected):**
```go
// Stack or heap (compiler decides)
x := 42

// Heap allocation (looks the same)
p := new(int)
*p = 42
// No delete needed! GC handles it

// Return pointer to local (OK in Go, escapes to heap)
func createInt() *int {
    x := 42
    return &x  // x moves to heap
}
```

## Stack vs Heap

**Go compiler decides based on escape analysis:**
```go
func stackAlloc() {
    x := 42  // likely stack (doesn't escape)
    _ = x
}

func heapAlloc() *int {
    x := 42
    return &x  // escapes to heap!
}

func largeAlloc() {
    // Large objects often go to heap
    big := make([]int, 1000000)
    _ = big
}
```

**Check escape analysis:**
```bash
go build -gcflags="-m" main.go

# Output shows:
# ./main.go:5:2: moved to heap: x
# ./main.go:10:13: make([]int, 1000000) escapes to heap
```

## Garbage Collection

**Go uses concurrent mark-and-sweep GC:**
```go
// GC runs automatically
// No manual control needed

// Can force GC (don't do in production!)
runtime.GC()

// Get GC stats
var stats runtime.MemStats
runtime.ReadMemStats(&stats)
fmt.Printf("Alloc = %v MB\n", stats.Alloc/1024/1024)
fmt.Printf("TotalAlloc = %v MB\n", stats.TotalAlloc/1024/1024)
fmt.Printf("NumGC = %v\n", stats.NumGC)
```

**GC tuning:**
```go
// Set GC percentage (default 100)
// Lower = more frequent GC, less memory
// Higher = less frequent GC, more memory
debug.SetGCPercent(50)

// Soft memory limit (Go 1.19+)
debug.SetMemoryLimit(1024 * 1024 * 1024)  // 1GB
```

## Memory Allocation

### new() vs make()

**new() - allocates zeroed memory:**
```go
// Returns pointer to zero value
p := new(int)  // *p == 0

type Person struct {
    Name string
    Age  int
}
p := new(Person)  // p.Name == "", p.Age == 0
```

**make() - initializes slices, maps, channels:**
```go
// Only for slice, map, channel
slice := make([]int, 10)      // length 10
m := make(map[string]int)      // empty map
ch := make(chan int, 5)        // buffered channel

// make allocates and initializes
// new only allocates
```

## Memory Leaks in Go

**Yes, possible even with GC!**

### 1. Goroutine Leaks
```go
// BAD - goroutine never exits
func leak() {
    ch := make(chan int)
    go func() {
        <-ch  // blocks forever
    }()
    // channel never receives, goroutine leaked
}

// GOOD - use context or timeout
func noLeak(ctx context.Context) {
    ch := make(chan int)
    go func() {
        select {
        case <-ch:
        case <-ctx.Done():
            return
        }
    }()
}
```

### 2. Slice Leaks
```go
// BAD - small slice holds large array
data := make([]byte, 1000000)
small := data[:10]  // still references entire array!

// GOOD - copy to new slice
small := make([]byte, 10)
copy(small, data[:10])
```

### 3. Map Leaks
```go
// Maps never shrink
m := make(map[int]string)
for i := 0; i < 1000000; i++ {
    m[i] = "value"
}

// Deleting doesn't free memory
for k := range m {
    delete(m, k)
}
// Memory still allocated!

// Solution: create new map
m = make(map[int]string)
```

### 4. Timer Leaks
```go
// BAD - timer not stopped
func process() {
    timer := time.NewTimer(5 * time.Second)
    // if not stopped, timer leaks
}

// GOOD - stop timer
func process() {
    timer := time.NewTimer(5 * time.Second)
    defer timer.Stop()
    // ...
}
```

### 5. Callback Leaks
```go
// BAD - circular reference
type Handler struct {
    callback func()
}

func setup() {
    h := &Handler{}
    h.callback = func() {
        // Captures h, creating circular reference
        processHandler(h)
    }
}
```

## Memory Profiling

**pprof for memory profiling:**
```go
import (
    "os"
    "runtime/pprof"
)

func main() {
    // Start memory profiling
    f, _ := os.Create("mem.prof")
    defer f.Close()
    defer pprof.WriteHeapProfile(f)
    
    // Your code here
    doWork()
}
```

**Analyze profile:**
```bash
go tool pprof mem.prof

# Commands in pprof:
# top - show top memory users
# list funcName - show source
# web - graphical view
```

**HTTP profiling (for services):**
```go
import _ "net/http/pprof"

go func() {
    http.ListenAndServe("localhost:6060", nil)
}()

// Access: http://localhost:6060/debug/pprof/
```

## Object Pooling

**Reduce GC pressure with sync.Pool:**
```go
import "sync"

// Pool of byte buffers
var bufferPool = sync.Pool{
    New: func() interface{} {
        return make([]byte, 1024)
    },
}

func processData() {
    // Get from pool
    buf := bufferPool.Get().([]byte)
    defer bufferPool.Put(buf)  // Return to pool
    
    // Use buffer
    // ...
}
```

**When to use pools:**
- Frequently allocated objects
- Objects expensive to create
- High allocation rate
- GC pressure issues

## Escape Analysis

**Understand what goes to heap:**
```go
// Doesn't escape - stack allocated
func stack() {
    x := 42
    fmt.Println(x)  // x doesn't escape
}

// Escapes - heap allocated
func heap() *int {
    x := 42
    return &x  // escapes to heap
}

// Interface causes escape
func interfaceEscape() {
    x := 42
    fmt.Println(x)  // x escapes (fmt.Println takes interface{})
}

// Closure causes escape
func closureEscape() func() int {
    x := 42
    return func() int {
        return x  // x escapes (captured by closure)
    }
}
```

**Check with compiler:**
```bash
go build -gcflags="-m -m" main.go
```

## Memory Optimization Tips

### 1. Use Value Types
```go
// Prefer value over pointer for small structs
type Point struct {
    X, Y int
}

// Good for small types
func process(p Point) {}

// Pointer only if needed
func modify(p *Point) {}
```

### 2. Pre-allocate Slices
```go
// BAD - many allocations
var result []int
for i := 0; i < 1000; i++ {
    result = append(result, i)
}

// GOOD - pre-allocate
result := make([]int, 0, 1000)
for i := 0; i < 1000; i++ {
    result = append(result, i)
}
```

### 3. Reuse Buffers
```go
// BAD - allocate every time
func process(data []byte) []byte {
    buf := make([]byte, len(data))
    copy(buf, data)
    return buf
}

// GOOD - reuse buffer
var bufPool = sync.Pool{
    New: func() interface{} {
        return make([]byte, 1024)
    },
}
```

### 4. Avoid String Concatenation
```go
// BAD - creates many string objects
var result string
for i := 0; i < 1000; i++ {
    result += "item"
}

// GOOD - use strings.Builder
var builder strings.Builder
for i := 0; i < 1000; i++ {
    builder.WriteString("item")
}
result := builder.String()
```

### 5. Use Struct Embedding Wisely
```go
// Consider memory layout
type Bad struct {
    a bool   // 1 byte + 7 bytes padding
    b int64  // 8 bytes
    c bool   // 1 byte + 7 bytes padding
}
// Total: 24 bytes

type Good struct {
    b int64  // 8 bytes
    a bool   // 1 byte
    c bool   // 1 byte + 6 bytes padding
}
// Total: 16 bytes
```

## Finalizers (Avoid!)

**C++ destructors vs Go finalizers:**
```go
// AVOID - finalizers are unpredictable
import "runtime"

func setupResource() *Resource {
    r := &Resource{}
    runtime.SetFinalizer(r, func(r *Resource) {
        r.Close()  // Don't rely on this!
    })
    return r
}

// PREFER - explicit cleanup
r := NewResource()
defer r.Close()
```

## Memory Models

**Go memory model guarantees:**
- Happens-before relationship
- Synchronization through channels
- Sync package primitives
- Atomic operations

```go
var a int
var done = make(chan bool)

func setup() {
    a = 42
    done <- true  // synchronization point
}

func main() {
    go setup()
    <-done  // synchronization point
    fmt.Println(a)  // guaranteed to see 42
}
```

## Learning Path

### Basic Level
- Garbage collection basics
- new() vs make()
- Understanding stack vs heap
- Basic memory stats
- Avoiding simple leaks

### Intermediate Level
- Escape analysis
- Memory profiling
- sync.Pool usage
- Pre-allocation strategies
- Common leak patterns

### Advanced Level
- GC tuning
- Memory model understanding
- Advanced profiling
- Performance optimization
- Low-level memory tricks
- unsafe package

## Key Differences from C++

1. **Automatic GC** - No manual delete
2. **Escape analysis** - Compiler decides stack/heap
3. **No destructors** - Use defer instead
4. **Safe by default** - Bounds checking
5. **GC pauses** - Trade-off for safety
6. **No control over layout** - Compiler optimizes
7. **Reference counting** - Not used (unlike shared_ptr)

## Best Practices

1. **Measure first** - Profile before optimizing
2. **Avoid premature optimization** - GC is good enough
3. **Pre-allocate** - When size known
4. **Use defer** - For cleanup
5. **Watch goroutine leaks** - Most common leak
6. **Pool expensive objects** - When allocation is hot path
7. **Understand escape** - Know what goes to heap

## Common Pitfalls

1. **Assuming stack allocation** - Check with -gcflags=-m
2. **Not stopping timers** - Timer leaks
3. **Slice of full array** - Keeps entire array alive
4. **Growing maps indefinitely** - Never shrink
5. **Goroutine leaks** - Most common
6. **Finalizer reliance** - Don't depend on them
7. **Ignoring GC pauses** - Can affect latency

## Practice Context

Focus on:
- Understanding GC behavior
- Profiling memory usage
- Avoiding common leaks
- Optimizing allocations
- Using sync.Pool effectively
- Escape analysis understanding
- Converting C++ RAII to Go patterns
