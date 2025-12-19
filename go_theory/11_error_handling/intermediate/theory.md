# Error Wrapping - Theory

## Error Wrapping (Go 1.13+)
```go
import "fmt"

err := doSomething()
if err != nil {
    return fmt.Errorf("failed to do: %w", err)
}
```

## Unwrap Errors
```go
import "errors"

if errors.Is(err, ErrNotFound) {
    // Handle specific error
}

var pathErr *os.PathError
if errors.As(err, &pathErr) {
    // Handle specific error type
}
```

## Custom Errors
```go
type MyError struct {
    Code int
    Msg  string
}

func (e *MyError) Error() string {
    return fmt.Sprintf("[%d] %s", e.Code, e.Msg)
}
```
