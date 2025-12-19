# Closures and Variadic - Theory

## Variadic Functions
```go
// Like C++ variadic templates
func sum(nums ...int) int {
    total := 0
    for _, n := range nums {
        total += n
    }
    return total
}

sum(1, 2, 3, 4)
```

## Closures
```go
func counter() func() int {
    count := 0
    return func() int {
        count++
        return count
    }
}

c := counter()
fmt.Println(c())  // 1
fmt.Println(c())  // 2
```

## Function Types
```go
type operation func(int, int) int

func apply(op operation, a, b int) int {
    return op(a, b)
}
```
