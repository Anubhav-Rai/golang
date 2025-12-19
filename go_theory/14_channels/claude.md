# Go Channels - Learning Context

## Topic Overview
Channels are Go's unique feature for goroutine communication - implementing CSP (Communicating Sequential Processes). No direct equivalent in C++.

## Channels vs C++ Alternatives

**C++ (Shared Memory + Mutex):**
```cpp
#include <queue>
#include <mutex>

std::queue<int> dataQueue;
std::mutex mtx;

// Producer
void produce() {
    std::lock_guard<std::mutex> lock(mtx);
    dataQueue.push(42);
}

// Consumer
int consume() {
    std::lock_guard<std::mutex> lock(mtx);
    int val = dataQueue.front();
    dataQueue.pop();
    return val;
}
```

**Go (Channels):**
```go
ch := make(chan int)

// Producer
go func() {
    ch <- 42  // send
}()

// Consumer
val := <-ch  // receive
```

## Creating Channels

```go
// Unbuffered channel
ch := make(chan int)

// Buffered channel
ch := make(chan int, 10)  // capacity 10

// Channel of any type
ch := make(chan string)
ch := make(chan *User)
ch := make(chan chan int)  // channel of channels!
```

## Channel Operations

### Send
```go
ch <- value  // send value to channel
```

### Receive
```go
value := <-ch  // receive and assign
<-ch           // receive and discard
```

### Close
```go
close(ch)  // close channel (sender only!)

// Receiving from closed channel
val, ok := <-ch
if !ok {
    // channel closed
}
```

## Unbuffered Channels

**Synchronous - blocks until both send and receive:**
```go
ch := make(chan int)  // no buffer

// This blocks until someone receives
ch <- 42

// This blocks until someone sends
val := <-ch

// Example
func main() {
    ch := make(chan int)
    
    go func() {
        time.Sleep(time.Second)
        ch <- 42  // unblocks main
    }()
    
    val := <-ch  // blocks here until value sent
    fmt.Println(val)
}
```

## Buffered Channels

**Asynchronous up to capacity:**
```go
ch := make(chan int, 3)  // buffer size 3

// These don't block (buffer not full)
ch <- 1
ch <- 2
ch <- 3

// This blocks (buffer full)
ch <- 4  // blocks until someone receives

// Receive
val := <-ch  // 1 (FIFO)
```

**Buffer properties:**
```go
ch := make(chan int, 5)
ch <- 1
ch <- 2

len(ch)  // 2 (current items)
cap(ch)  // 5 (capacity)
```

## Channel Direction

**Restrict operations:**
```go
// Send-only channel
func producer(ch chan<- int) {
    ch <- 42
    // val := <-ch  // ERROR! receive not allowed
}

// Receive-only channel
func consumer(ch <-chan int) {
    val := <-ch
    // ch <- 42  // ERROR! send not allowed
}

// Bidirectional (default)
func both(ch chan int) {
    ch <- 42
    val := <-ch
}
```

## Range over Channels

**Iterate until closed:**
```go
ch := make(chan int, 3)
ch <- 1
ch <- 2
ch <- 3
close(ch)  // must close for range to exit

for val := range ch {
    fmt.Println(val)  // 1, 2, 3
}
// exits when channel closed
```

## Select Statement

**Like switch but for channel operations:**
```go
select {
case val := <-ch1:
    fmt.Println("Received from ch1:", val)
case val := <-ch2:
    fmt.Println("Received from ch2:", val)
case ch3 <- value:
    fmt.Println("Sent to ch3")
default:
    fmt.Println("No communication")
}
```

### Select Properties
- **Non-blocking with default:** If no case ready, runs default
- **Random selection:** If multiple cases ready, picks randomly
- **Nil channels:** Never ready (useful for disabling cases)

## Select Patterns

### Timeout
```go
select {
case result := <-ch:
    fmt.Println("Got result:", result)
case <-time.After(1 * time.Second):
    fmt.Println("Timeout!")
}
```

### Non-blocking Send/Receive
```go
// Non-blocking receive
select {
case val := <-ch:
    fmt.Println("Received:", val)
default:
    fmt.Println("No data available")
}

// Non-blocking send
select {
case ch <- value:
    fmt.Println("Sent")
default:
    fmt.Println("Channel full")
}
```

### Multiple Channels
```go
for {
    select {
    case msg := <-ch1:
        handleMessage(msg)
    case sig := <-quit:
        return
    case <-time.After(30 * time.Second):
        fmt.Println("Idle timeout")
    }
}
```

## Nil Channels

**Useful for disabling select cases:**
```go
var ch1, ch2 chan int = make(chan int), make(chan int)

for i := 0; i < 2; i++ {
    select {
    case val := <-ch1:
        fmt.Println("ch1:", val)
        ch1 = nil  // disable this case
    case val := <-ch2:
        fmt.Println("ch2:", val)
        ch2 = nil  // disable this case
    }
}
```

## Channel Patterns

### Pipeline
```go
// Generator
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

// Processor
func square(in <-chan int) <-chan int {
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
for n := range square(gen(2, 3, 4)) {
    fmt.Println(n)  // 4, 9, 16
}
```

### Fan-Out (Distribute work)
```go
func fanOut(in <-chan int, n int) []<-chan int {
    workers := make([]<-chan int, n)
    for i := 0; i < n; i++ {
        workers[i] = worker(in)
    }
    return workers
}

func worker(in <-chan int) <-chan int {
    out := make(chan int)
    go func() {
        for val := range in {
            out <- process(val)
        }
        close(out)
    }()
    return out
}
```

### Fan-In (Collect results)
```go
func fanIn(channels ...<-chan int) <-chan int {
    out := make(chan int)
    var wg sync.WaitGroup
    
    output := func(ch <-chan int) {
        defer wg.Done()
        for val := range ch {
            out <- val
        }
    }
    
    wg.Add(len(channels))
    for _, ch := range channels {
        go output(ch)
    }
    
    go func() {
        wg.Wait()
        close(out)
    }()
    
    return out
}
```

### Quit Channel
```go
func worker(quit <-chan bool) {
    for {
        select {
        case <-quit:
            fmt.Println("Exiting")
            return
        default:
            // do work
        }
    }
}

func main() {
    quit := make(chan bool)
    go worker(quit)
    
    time.Sleep(time.Second)
    close(quit)  // signal quit
}
```

### Done Channel Pattern
```go
func worker(done <-chan struct{}) {
    for {
        select {
        case <-done:
            return
        default:
            // do work
        }
    }
}

func main() {
    done := make(chan struct{})
    go worker(done)
    
    time.Sleep(time.Second)
    close(done)  // broadcast to all workers
}
```

## Semaphore Pattern

**Limit concurrency:**
```go
func main() {
    // Allow max 3 concurrent operations
    sem := make(chan struct{}, 3)
    
    for i := 0; i < 10; i++ {
        sem <- struct{}{}  // acquire
        go func(id int) {
            defer func() { <-sem }()  // release
            performTask(id)
        }(i)
    }
}
```

## Channel Closing Rules

**Important rules:**
1. **Only sender closes** - Never receiver
2. **Check before close** - Can't close closed channel (panic)
3. **Check on receive** - val, ok := <-ch
4. **Close to broadcast** - All receivers get zero value and ok=false

```go
// Safe close pattern
func safeSend(ch chan int, value int) bool {
    defer func() {
        if recover() != nil {
            // channel closed
        }
    }()
    ch <- value
    return true
}
```

## Deadlock Detection

**Go runtime detects:**
```go
func main() {
    ch := make(chan int)
    ch <- 42  // blocks forever (no receiver)
}
// fatal error: all goroutines are asleep - deadlock!
```

## Buffered vs Unbuffered

**When to use buffered:**
- Known capacity needs
- Decoupling producer/consumer speed
- Reducing context switches

**When to use unbuffered:**
- Synchronization required
- Guaranteed delivery
- Simple communication

```go
// Unbuffered - synchronous
ch := make(chan int)

// Buffered - asynchronous (until full)
ch := make(chan int, 100)
```

## Context with Channels

**Cancellation:**
```go
func worker(ctx context.Context, ch <-chan int) {
    for {
        select {
        case val := <-ch:
            process(val)
        case <-ctx.Done():
            fmt.Println("Cancelled")
            return
        }
    }
}

ctx, cancel := context.WithCancel(context.Background())
go worker(ctx, ch)

// Cancel when done
cancel()
```

## Learning Path

### Basic Level
- Creating channels
- Send and receive operations
- Closing channels
- Unbuffered vs buffered
- Range over channels

### Intermediate Level
- Select statement
- Channel direction restrictions
- Timeout patterns
- Nil channels
- Basic pipeline patterns

### Advanced Level
- Fan-out/fan-in patterns
- Complex select scenarios
- Channel-based semaphores
- Lock-free algorithms
- Performance optimization
- Context integration

## Key Concepts

1. **CSP Model:** Communicating Sequential Processes
2. **Don't communicate by sharing memory; share memory by communicating**
3. **Channels are first-class values**
4. **Select enables multiplexing**
5. **Closing is for signaling, not cleanup**

## Best Practices

1. **Close from sender side only**
2. **Use buffered channels for known capacity**
3. **Prefer unbuffered for synchronization**
4. **Check closed status: val, ok := <-ch**
5. **Use select for timeouts and cancellation**
6. **Nil channels in select to disable cases**
7. **Use struct{} for signal-only channels**

## Common Pitfalls

1. **Closing from receiver** - Wrong pattern
2. **Closing closed channel** - Panic
3. **Sending on closed channel** - Panic
4. **Deadlocks** - No sender/receiver
5. **Goroutine leaks** - Blocked send/receive
6. **Not closing channels** - Range loops block forever
7. **Buffer size mistakes** - Deadlock or memory waste

## Anti-Patterns

**Don't do:**
```go
// Closing from wrong side
go func() {
    for val := range ch {
        process(val)
    }
    close(ch)  // NO! Receiver shouldn't close
}()

// Checking length before receive
if len(ch) > 0 {
    val := <-ch  // Race condition!
}

// Sending on possibly closed channel
ch <- value  // Might panic if closed
```

## Channel vs Mutex

**Use channels when:**
- Passing ownership of data
- Distributing work
- Communicating async results

**Use mutex when:**
- Caching
- State management
- Protecting shared data structures

## Practice Context

Focus on:
- Understanding channel semantics
- Using select effectively
- Pipeline patterns
- Proper channel closing
- Avoiding deadlocks
- Converting C++ condition variables to channels
- Buffered vs unbuffered choice
- Context integration
