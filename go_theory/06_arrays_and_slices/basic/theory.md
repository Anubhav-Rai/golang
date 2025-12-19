# Slices - Theory

## C++ vs Go

### C++ Vector
```cpp
std::vector<int> v;
v.push_back(1);
v.push_back(2);
```

### Go Slice
```go
var s []int
s = append(s, 1)
s = append(s, 2)
```

## Arrays (Rarely Used)
```go
var arr [5]int      // Fixed size, value type
arr[0] = 1
```

## Slices (Use These!)
```go
// Create slice
s := []int{1, 2, 3}
s := make([]int, 5)      // len=5, cap=5
s := make([]int, 0, 10)  // len=0, cap=10

// Append
s = append(s, 4, 5, 6)

// Length and capacity
len(s)  // number of elements
cap(s)  // capacity
```

## Slicing
```go
s := []int{0, 1, 2, 3, 4, 5}
s[1:4]   // [1 2 3]
s[:3]    // [0 1 2]
s[3:]    // [3 4 5]
s[:]     // all
```
