# Defer - Theory

## C++ RAII vs Go Defer

### C++
```cpp
{
    std::lock_guard<std::mutex> lock(mtx);
    // Automatic unlock at scope end
}
```

### Go
```go
mu.Lock()
defer mu.Unlock()  // Runs when function exits
// Do work
```

## Defer Order (LIFO)
```go
func example() {
    defer fmt.Println("1")
    defer fmt.Println("2")
    defer fmt.Println("3")
}
// Prints: 3, 2, 1
```

## Common Uses
```go
// File handling
f, _ := os.Open("file.txt")
defer f.Close()

// Mutex
mu.Lock()
defer mu.Unlock()

// Cleanup
defer cleanup()
```
