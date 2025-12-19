# Go Arrays and Slices - Learning Context

## Topic Overview
Understanding Go's array and slice system - one of the biggest differences from C/C++.

## Arrays - Fixed Size

**C/C++:**
```cpp
int arr[5] = {1, 2, 3, 4, 5};
int size = sizeof(arr) / sizeof(arr[0]);
```

**Go - Size is Part of Type:**
```go
var arr [5]int = [5]int{1, 2, 3, 4, 5}
arr := [5]int{1, 2, 3, 4, 5}
arr := [...]int{1, 2, 3, 4, 5}  // compiler counts

// [5]int and [10]int are DIFFERENT types!
var a [5]int
var b [10]int
// a = b  // ERROR! Different types
```

**Arrays are values, not pointers:**
```cpp
// C++ - arrays decay to pointers
int arr1[5] = {1, 2, 3, 4, 5};
int arr2[5];
arr2 = arr1;  // ERROR in C++ (can't assign arrays)

// Go - arrays are values
arr1 := [5]int{1, 2, 3, 4, 5}
arr2 := arr1  // Copies entire array!
arr2[0] = 100
// arr1[0] is still 1
```

## Slices - Dynamic Arrays (Use These!)

**C++:** `std::vector<int>`
```cpp
std::vector<int> v = {1, 2, 3};
v.push_back(4);
v[0] = 10;
```

**Go - Slices (More Like References):**
```go
// Create slice
slice := []int{1, 2, 3}  // No size specified
slice = append(slice, 4)
slice[0] = 10

// Slices are reference types!
s1 := []int{1, 2, 3}
s2 := s1  // Both refer to same array
s2[0] = 100
// s1[0] is now 100!
```

## Slice Internals

**A slice is a struct:**
```go
type slice struct {
    ptr *array     // pointer to underlying array
    len int        // current length
    cap int        // capacity
}

// Example
s := make([]int, 3, 5)  // len=3, cap=5
// len(s) == 3
// cap(s) == 5
```

## Creating Slices

**Different ways:**
```go
// 1. Literal
s := []int{1, 2, 3}

// 2. make - specify len and cap
s := make([]int, 5)      // len=5, cap=5, [0,0,0,0,0]
s := make([]int, 3, 5)   // len=3, cap=5, [0,0,0]

// 3. From array
arr := [5]int{1, 2, 3, 4, 5}
s := arr[1:4]  // slice of arr, [2,3,4]

// 4. nil slice
var s []int    // nil, len=0, cap=0
s == nil       // true
```

## Slicing Operations

**Similar to Python:**
```go
s := []int{0, 1, 2, 3, 4, 5}

s[1:4]   // [1, 2, 3]
s[:3]    // [0, 1, 2]
s[2:]    // [2, 3, 4, 5]
s[:]     // entire slice (copy reference)

// Three-index slice: [low:high:cap]
s[1:3:4]  // from index 1 to 3, capacity up to 4
```

**Shares underlying array:**
```go
original := []int{1, 2, 3, 4, 5}
sub := original[1:3]  // [2, 3]

sub[0] = 100
// original is now [1, 100, 3, 4, 5]
```

## append - Growing Slices

**C++:**
```cpp
std::vector<int> v;
v.push_back(1);
v.push_back(2);
```

**Go:**
```go
var s []int  // nil slice
s = append(s, 1)
s = append(s, 2)
s = append(s, 3, 4, 5)  // variadic

// Append another slice
s2 := []int{6, 7, 8}
s = append(s, s2...)  // spread operator
```

**Capacity growth:**
```go
s := make([]int, 0, 2)
fmt.Println(len(s), cap(s))  // 0, 2

s = append(s, 1)  // len=1, cap=2
s = append(s, 2)  // len=2, cap=2
s = append(s, 3)  // len=3, cap=4 (doubled!)
// When cap exceeded, new array allocated
```

## copy - Copying Slices

**Explicit copy:**
```go
src := []int{1, 2, 3}
dst := make([]int, len(src))
n := copy(dst, src)  // copies min(len(dst), len(src))

// dst is independent copy
dst[0] = 100
// src[0] is still 1
```

## Multidimensional Arrays/Slices

**C++:**
```cpp
int matrix[3][4];
```

**Go Arrays:**
```go
var matrix [3][4]int
```

**Go Slices (Jagged):**
```go
// Create 2D slice
matrix := make([][]int, 3)  // 3 rows
for i := range matrix {
    matrix[i] = make([]int, 4)  // 4 columns each
}

// Or literal
matrix := [][]int{
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9},
}
```

## Common Patterns

### Remove element
```go
// Remove at index i
s = append(s[:i], s[i+1:]...)

// Remove without preserving order (faster)
s[i] = s[len(s)-1]
s = s[:len(s)-1]
```

### Filter
```go
// Filter even numbers
filtered := []int{}
for _, v := range original {
    if v%2 == 0 {
        filtered = append(filtered, v)
    }
}
```

### Insert at position
```go
// Insert x at position i
s = append(s[:i], append([]int{x}, s[i:]...)...)

// More efficient
s = append(s, 0)  // extend
copy(s[i+1:], s[i:])
s[i] = x
```

## Comparing Arrays and Slices

**Arrays can be compared:**
```go
a := [3]int{1, 2, 3}
b := [3]int{1, 2, 3}
a == b  // true
```

**Slices cannot:**
```go
s1 := []int{1, 2, 3}
s2 := []int{1, 2, 3}
// s1 == s2  // ERROR! Invalid operation

// Only comparison is with nil
var s []int
s == nil  // true
```

## Performance Considerations

### Pre-allocate capacity
```go
// Bad - many allocations
var s []int
for i := 0; i < 1000; i++ {
    s = append(s, i)
}

// Good - one allocation
s := make([]int, 0, 1000)
for i := 0; i < 1000; i++ {
    s = append(s, i)
}
```

### Avoid leaks with slices
```go
// Potential memory leak
data := make([]byte, 1000000)
small := data[:10]  // holds reference to large array!

// Fix: copy
small := make([]byte, 10)
copy(small, data[:10])
```

## Learning Path

### Basic Level
- Array declaration and initialization
- Slice creation and usage
- append and copy
- Indexing and range
- len and cap functions

### Intermediate Level
- Slice internals (pointer, len, cap)
- Slicing operations
- Sharing vs copying
- Three-index slicing
- Common slice patterns

### Advanced Level
- Performance optimization
- Memory management
- Avoiding slice gotchas
- Efficient algorithms
- Unsafe operations

## Key Differences from C/C++

1. **Arrays are values** - Assignment copies
2. **Slices are references** - Not like vectors
3. **Size is part of array type** - [5]int ≠ [10]int
4. **No pointer arithmetic** - Use slicing instead
5. **Built-in append** - No manual reallocation
6. **Capacity tracking** - Built into slice type
7. **Can't compare slices** - Only with nil

## Common Pitfalls

1. **Array vs slice confusion** - Use slices 99% of time
2. **Sharing underlying array** - Modifications affect original
3. **Growing past capacity** - Causes reallocation
4. **Loop variable gotcha** - Range gives copy
5. **Memory leaks** - Small slices holding large arrays
6. **Nil vs empty slice** - Different meanings

## Practice Context

Focus on:
- When to use arrays vs slices
- Understanding append behavior
- Slice manipulation patterns
- Avoiding memory leaks
- Performance implications
- Converting C++ vectors to Go slices
