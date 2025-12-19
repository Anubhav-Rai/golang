# Control Flow - Theory

## If Statement

### C++ vs Go
```cpp
// C++
if (x > 10) {
    // ...
}
```

```go
// Go - no parentheses!
if x > 10 {
    // ...
}

// With initialization
if y := compute(); y > 10 {
    // y scoped to if block
}
```

## For Loop (Only Loop!)

```go
// Traditional for
for i := 0; i < 10; i++ {
}

// While equivalent
for condition {
}

// Infinite loop
for {
}

// Range (like C++ range-for)
for i, v := range slice {
}
```

## Switch (No Fallthrough!)
```go
switch day {
case "Monday":
    // Automatic break!
case "Tuesday":
    // No fallthrough by default
default:
}
```
