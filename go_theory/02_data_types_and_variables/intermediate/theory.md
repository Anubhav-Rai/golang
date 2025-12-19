# Type Conversions - Theory

## C++ vs Go

### C++ (Implicit)
```cpp
int x = 10;
double y = x;      // Implicit
int z = 3.14;      // Implicit (loses precision)
```

### Go (Explicit)
```go
x := 10
y := float64(x)    // Must be explicit
z := int(3.14)     // Must be explicit
```

## Custom Types
```go
type Celsius float64
type Fahrenheit float64

// These are DIFFERENT types!
var c Celsius = 20
var f Fahrenheit = 68
// c = f  // ERROR! Different types
```

## Constants with iota
```go
const (
    Sunday = iota    // 0
    Monday           // 1
    Tuesday          // 2
)
```
