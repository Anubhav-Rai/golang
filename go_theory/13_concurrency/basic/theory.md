# Goroutines - Theory

## C++ vs Go

### C++ Threads
```cpp
#include <thread>

void task() { }

std::thread t(task);
t.join();
```

### Go Goroutines
```go
func task() { }

go task()  // That's it!

// Wait for completion
var wg sync.WaitGroup
wg.Add(1)
go func() {
    defer wg.Done()
    task()
}()
wg.Wait()
```

## Goroutines
- Very lightweight (~2KB stack)
- Multiplexed onto threads
- Can have thousands/millions
- Started with `go` keyword

## WaitGroup
```go
var wg sync.WaitGroup

for i := 0; i < 10; i++ {
    wg.Add(1)
    go func(id int) {
        defer wg.Done()
        work(id)
    }(i)
}

wg.Wait()
```
