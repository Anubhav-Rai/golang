# Functions - Theory

## C++ vs Go

### Basic Function
```cpp
// C++
int add(int a, int b) {
    return a + b;
}
```

```go
// Go
func add(a, b int) int {
    return a + b
}
```

## Multiple Returns (BIG FEATURE!)
```cpp
// C++ - use tuple
std::tuple<int, int> divide(int a, int b) {
    return {a/b, a%b};
}
```

```go
// Go - built-in!
func divide(a, b int) (int, int) {
    return a / b, a % b
}

// Usage
quotient, remainder := divide(10, 3)
```

## Named Returns
```go
func divide(a, b int) (quotient, remainder int) {
    quotient = a / b
    remainder = a % b
    return  // Naked return
}
```
