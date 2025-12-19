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
