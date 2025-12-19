# Operators - Theory

## C++ vs Go

### Increment (BIG DIFFERENCE!)
```cpp
// C++
int x = 5;
int y = x++;     // OK
int z = ++x;     // OK
if (x++) {}      // OK
```

```go
// Go
x := 5
y := x++         // ERROR! ++ is statement
z := ++x         // ERROR! No prefix ++
x++              // OK - standalone statement
```

## No Ternary
```cpp
// C++
int x = (a > b) ? a : b;
```

```go
// Go - use if/else
var x int
if a > b {
    x = a
} else {
    x = b
}
```

## Operators
- Arithmetic: + - * / %
- Comparison: == != < > <= >=
- Logical: && || !
- Bitwise: & | ^ << >> &^
