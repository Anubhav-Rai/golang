# Slice Internals - Theory

## Slice Structure
```
┌────────────────┐
│  ptr  │ len │ cap │
└───┬────────────┘
    │
    ▼
┌───┬───┬───┬───┬───┐
│ 1 │ 2 │ 3 │ 4 │ 5 │
└───┴───┴───┴───┴───┘
```

## Copy vs Assignment
```go
s1 := []int{1, 2, 3}
s2 := s1          // s2 references same array!
s2[0] = 99        // Modifies s1 too!

// To copy:
s3 := make([]int, len(s1))
copy(s3, s1)      // Now independent
```

## Pre-allocation
```go
// Bad - many allocations
var result []int
for i := 0; i < 1000; i++ {
    result = append(result, i)
}

// Good - one allocation
result := make([]int, 0, 1000)
for i := 0; i < 1000; i++ {
    result = append(result, i)
}
```
