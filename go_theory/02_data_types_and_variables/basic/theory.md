# Data Types - Theory

## Basic Types

### C++ vs Go
```cpp
// C++
int x;              // Uninitialized!
int y = 10;
auto z = 20;
```

```go
// Go
var x int           // Zero value = 0
y := 10             // Type inferred
var z = 20          // Also inferred
```

## Zero Values
- int, float: `0`
- bool: `false`  
- string: `""`
- pointer: `nil`
- slice, map: `nil`

## Type List
- bool
- string
- int, int8, int16, int32, int64
- uint, uint8, uint16, uint32, uint64
- byte (alias for uint8)
- rune (alias for int32, Unicode)
- float32, float64
- complex64, complex128
