# Error Handling - Theory

## C++ vs Go

### C++ (Exceptions)
```cpp
try {
    int result = divide(10, 0);
} catch (std::exception& e) {
    std::cerr << e.what();
}
```

### Go (Return Values)
```go
result, err := divide(10, 0)
if err != nil {
    log.Fatal(err)
}
// Use result
```

## Error Interface
```go
type error interface {
    Error() string
}
```

## Creating Errors
```go
import "errors"

err := errors.New("something failed")
err := fmt.Errorf("failed: %v", details)
```

## Pattern
```go
func doSomething() error {
    if somethingWrong {
        return errors.New("failed")
    }
    return nil
}

if err := doSomething(); err != nil {
    return err
}
```
