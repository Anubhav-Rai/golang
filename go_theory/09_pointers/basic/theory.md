# Pointers - Theory

## C++ vs Go

### C++
```cpp
int x = 10;
int* p = &x;
(*p)++;
p++;  // Pointer arithmetic
```

### Go
```go
x := 10
p := &x
(*p)++
// p++  // ERROR! No pointer arithmetic

// Auto-dereference
type Person struct { Name string }
p := &Person{Name: "Alice"}
p.Name = "Bob"  // Auto-dereference!
```

## Returning Pointers (Safe!)
```go
func createInt() *int {
    x := 42
    return &x  // OK! Escapes to heap
}
```

## new() Function
```go
p := new(int)     // Allocates, returns pointer
*p = 42

// Equivalent to:
x := 0
p := &x
```
