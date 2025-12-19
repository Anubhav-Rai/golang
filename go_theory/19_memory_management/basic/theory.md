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
