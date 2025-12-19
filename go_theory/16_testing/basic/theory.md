# Testing - Theory

## C++ vs Go

### C++ (Google Test)
```cpp
TEST(MathTest, Addition) {
    EXPECT_EQ(Add(2, 3), 5);
}
```

### Go (Built-in)
```go
func TestAdd(t *testing.T) {
    result := Add(2, 3)
    if result != 5 {
        t.Errorf("Expected 5, got %d", result)
    }
}
```

## File Naming
- Test file: `math_test.go`
- Same package: `package math`
- Run: `go test`

## Table-Driven Tests
```go
func TestAdd(t *testing.T) {
    tests := []struct{
        name string
        a, b int
        want int
    }{
        {"positive", 2, 3, 5},
        {"negative", -1, -2, -3},
        {"zero", 0, 0, 0},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := Add(tt.a, tt.b)
            if got != tt.want {
                t.Errorf("got %d, want %d", got, tt.want)
            }
        })
    }
}
```
