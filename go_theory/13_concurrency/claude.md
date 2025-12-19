# Go Concurrency - Learning Context

## Topic Overview
Go's concurrency model (goroutines and channels) is fundamentally different from C++ threads - simpler, more powerful, and built into the language.

## Goroutines vs C++ Threads

**C++ (Heavy Threads):**
```cpp
#include <thread>
#include <iostream>

void task() {
    std::cout << "Running task\n";
}

int main() {
    std::thread t(task);  // OS thread (expensive)
    t.join();
    return 0;
}
```

**Go (Lightweight Goroutines):**
```go
func task() {
    fmt.Println("Running task")
}

func main() {
    go task()  // goroutine (cheap, thousands possible)
    time.Sleep(time.Second)  // wait (better: use channels)
}
```

## Key Differences

**Goroutines:**
- Lightweight (2KB initial stack vs 1MB+ for threads)
- Multiplexed onto OS threads (M:N threading)
- Managed by Go runtime
- Can launch millions

**C++ Threads:**
- OS threads (1:1 mapping)
- Expensive (memory, context switching)
- Typically limited to thousands

## Creating Goroutines

**Simple:**
```go
go function()
go func() {
    // anonymous function
    fmt.Println("Hello from goroutine")
}()
```

**With parameters:**
```go
func process(id int, data string) {
    fmt.Printf("Goroutine %d processing %s\n", id, data)
}

go process(1, "data1")
go process(2, "data2")
```

## Main Goroutine

**Program exits when main() returns:**
```go
func main() {
    go fmt.Println("Hello")
    // Program might exit before goroutine runs!
    
    // Need to wait
    time.Sleep(100 * time.Millisecond)
    
    // Better: use sync.WaitGroup or channels
}
```

## WaitGroup - Waiting for Goroutines

**C++:** thread.join()
```cpp
std::thread t1(task);
std::thread t2(task);
t1.join();
t2.join();
```

**Go:** sync.WaitGroup
```go
import "sync"

var wg sync.WaitGroup

func worker(id int) {
    defer wg.Done()  // decrement counter
    fmt.Printf("Worker %d starting\n", id)
    time.Sleep(time.Second)
    fmt.Printf("Worker %d done\n", id)
}

func main() {
    for i := 1; i <= 5; i++ {
        wg.Add(1)  // increment counter
        go worker(i)
    }
    wg.Wait()  // block until counter is 0
}
```

## Concurrency vs Parallelism

**Concurrency:** Dealing with multiple things at once (structure)
**Parallelism:** Doing multiple things at once (execution)

```go
// Concurrent but not parallel on single core
// Parallel on multi-core

runtime.GOMAXPROCS(4)  // use 4 CPU cores
// Default: runtime.NumCPU()
```

## Race Conditions

**C++ (mutex needed):**
```cpp
#include <mutex>
int counter = 0;
std::mutex mtx;

void increment() {
    std::lock_guard<std::mutex> lock(mtx);
    counter++;
}
```

**Go (multiple solutions):**

### 1. Mutex
```go
import "sync"

var (
    counter int
    mu      sync.Mutex
)

func increment() {
    mu.Lock()
    counter++
    mu.Unlock()
}

// Or with defer
func increment() {
    mu.Lock()
    defer mu.Unlock()
    counter++
}
```

### 2. Channels (Better)
```go
// Share memory by communicating
counter := make(chan int, 1)
counter <- 0  // initial value

go func() {
    val := <-counter
    counter <- val + 1
}()
```

### 3. Atomic Operations
```go
import "sync/atomic"

var counter int64

func increment() {
    atomic.AddInt64(&counter, 1)
}

value := atomic.LoadInt64(&counter)
```

## Sync Primitives

### Mutex (Mutual Exclusion)
```go
var (
    data map[string]int
    mu   sync.Mutex
)

func updateData(key string, value int) {
    mu.Lock()
    defer mu.Unlock()
    data[key] = value
}
```

### RWMutex (Read-Write Lock)
```go
var (
    data map[string]int
    mu   sync.RWMutex
)

func read(key string) int {
    mu.RLock()  // multiple readers OK
    defer mu.RUnlock()
    return data[key]
}

func write(key string, value int) {
    mu.Lock()  // exclusive write
    defer mu.Unlock()
    data[key] = value
}
```

### Once (Run Once)
```go
var (
    instance *Database
    once     sync.Once
)

func GetDatabase() *Database {
    once.Do(func() {
        instance = &Database{}
        instance.Connect()
    })
    return instance
}
```

## Goroutine Leaks

**Common problem:**
```go
// BAD - goroutine never exits
func leak() {
    ch := make(chan int)
    go func() {
        val := <-ch  // blocks forever if nothing sent
        fmt.Println(val)
    }()
    // channel never receives, goroutine leaks
}

// GOOD - use context or timeout
func noLeak(ctx context.Context) {
    ch := make(chan int)
    go func() {
        select {
        case val := <-ch:
            fmt.Println(val)
        case <-ctx.Done():
            return  // cleanup
        }
    }()
}
```

## Worker Pool Pattern

**C++ thread pool is complex:**
**Go version:**
```go
func worker(id int, jobs <-chan int, results chan<- int) {
    for job := range jobs {
        fmt.Printf("Worker %d processing job %d\n", id, job)
        time.Sleep(time.Second)
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

## Context Package

**Cancellation and timeouts:**
```go
import "context"

func operation(ctx context.Context) error {
    select {
    case <-time.After(2 * time.Second):
        return nil
    case <-ctx.Done():
        return ctx.Err()  // cancelled or timeout
    }
}

func main() {
    // With timeout
    ctx, cancel := context.WithTimeout(context.Background(), 1*time.Second)
    defer cancel()
    
    if err := operation(ctx); err != nil {
        fmt.Println("Operation failed:", err)
    }
}
```

### Context Types
```go
// Background context
ctx := context.Background()

// With cancellation
ctx, cancel := context.WithCancel(ctx)
cancel()  // cancel when done

// With timeout
ctx, cancel := context.WithTimeout(ctx, 5*time.Second)

// With deadline
ctx, cancel := context.WithDeadline(ctx, time.Now().Add(5*time.Second))

// With value (use sparingly)
ctx = context.WithValue(ctx, "userID", 123)
```

## Race Detector

**Go has built-in race detector:**
```bash
go run -race main.go
go test -race
go build -race
```

**Example:**
```go
// Race condition
var counter int

func increment() {
    counter++  // race detected!
}

go increment()
go increment()
```

## Common Concurrency Patterns

### Fan-Out (Distribute Work)
```go
func fanOut(input <-chan int) []<-chan int {
    workers := make([]<-chan int, 3)
    for i := 0; i < 3; i++ {
        workers[i] = worker(input)
    }
    return workers
}
```

### Fan-In (Collect Results)
```go
func fanIn(channels ...<-chan int) <-chan int {
    out := make(chan int)
    var wg sync.WaitGroup
    
    for _, ch := range channels {
        wg.Add(1)
        go func(c <-chan int) {
            defer wg.Done()
            for val := range c {
                out <- val
            }
        }(ch)
    }
    
    go func() {
        wg.Wait()
        close(out)
    }()
    
    return out
}
```

### Pipeline
```go
func gen(nums ...int) <-chan int {
    out := make(chan int)
    go func() {
        for _, n := range nums {
            out <- n
        }
        close(out)
    }()
    return out
}

func sq(in <-chan int) <-chan int {
    out := make(chan int)
    go func() {
        for n := range in {
            out <- n * n
        }
        close(out)
    }()
    return out
}

// Usage
for n := range sq(sq(gen(2, 3))) {
    fmt.Println(n)  // 16, 81
}
```

## Learning Path

### Basic Level
- Starting goroutines
- Basic synchronization (sleep, WaitGroup)
- Understanding concurrency vs parallelism
- Race conditions awareness
- Simple mutex usage

### Intermediate Level
- Channels (covered in next topic)
- RWMutex
- Atomic operations
- Worker pools
- Context package
- Race detector

### Advanced Level
- Complex synchronization patterns
- Lock-free algorithms
- Performance optimization
- Goroutine scheduling
- Memory models
- Advanced context usage

## Key Differences from C++

1. **Lightweight goroutines** - Not OS threads
2. **Built-in language support** - go keyword
3. **Channels for communication** - CSP model
4. **Race detector** - Built into toolchain
5. **Context package** - Cancellation propagation
6. **Simpler primitives** - Less boilerplate
7. **GC-aware** - No manual memory management

## Best Practices

1. **Don't communicate by sharing memory; share memory by communicating**
2. **Use channels or sync primitives, not both**
3. **Always have goroutine exit strategy**
4. **Avoid premature optimization**
5. **Use race detector in tests**
6. **Context for cancellation**
7. **Defer unlock() calls**

## Common Pitfalls

1. **Goroutine leaks** - Always have exit path
2. **Race conditions** - Use -race flag
3. **Forgetting WaitGroup.Done()** - Deadlock
4. **Closing channel from receiver** - Close from sender
5. **Sending on closed channel** - Panic
6. **Mutex copying** - Pass by pointer
7. **No goroutine cleanup** - Use context

## Practice Context

Focus on:
- Launching goroutines correctly
- Synchronizing with WaitGroup
- Avoiding race conditions
- Using mutex and RWMutex
- Understanding goroutine lifecycle
- Context for cancellation
- Race detector usage
- Converting C++ threads to Go goroutines
