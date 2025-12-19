# Go Error Handling - Learning Context

## Topic Overview
Go uses explicit error values instead of exceptions - a fundamentally different approach from C++.

## Error vs Exceptions

**C++ (Exceptions):**
```cpp
int divide(int a, int b) {
    if (b == 0) {
        throw std::runtime_error("division by zero");
    }
    return a / b;
}

try {
    int result = divide(10, 0);
} catch (const std::exception& e) {
    std::cerr << e.what() << std::endl;
}
```

**Go (Error Values):**
```go
func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

result, err := divide(10, 0)
if err != nil {
    log.Fatal(err)
}
```

## The error Interface

**Simple interface:**
```go
type error interface {
    Error() string
}

// Any type with Error() string implements error
```

## Creating Errors

### errors.New
```go
import "errors"

err := errors.New("something went wrong")
```

### fmt.Errorf (formatted)
```go
import "fmt"

age := -5
err := fmt.Errorf("invalid age: %d", age)
```

### Custom Error Types
```go
type ValidationError struct {
    Field   string
    Message string
}

func (e ValidationError) Error() string {
    return fmt.Sprintf("%s: %s", e.Field, e.Message)
}

func validate(age int) error {
    if age < 0 {
        return ValidationError{
            Field:   "age",
            Message: "cannot be negative",
        }
    }
    return nil
}
```

## Error Handling Patterns

### Immediate Return
```go
func process() error {
    err := step1()
    if err != nil {
        return err  // propagate error
    }
    
    err = step2()
    if err != nil {
        return err
    }
    
    return nil
}
```

### Error Wrapping (Go 1.13+)
```go
import "fmt"

func readConfig() error {
    err := openFile()
    if err != nil {
        return fmt.Errorf("read config: %w", err)
    }
    return nil
}

// Unwrap to check original error
err := readConfig()
if err != nil {
    if errors.Is(err, fs.ErrNotExist) {
        // file doesn't exist
    }
}
```

### Sentinel Errors
```go
var (
    ErrNotFound    = errors.New("not found")
    ErrInvalidInput = errors.New("invalid input")
    ErrTimeout     = errors.New("timeout")
)

func findUser(id int) (*User, error) {
    if id < 0 {
        return nil, ErrInvalidInput
    }
    // ... search ...
    if notFound {
        return nil, ErrNotFound
    }
    return user, nil
}

// Check specific error
user, err := findUser(123)
if err == ErrNotFound {
    // handle not found
} else if err != nil {
    // other error
}
```

## errors.Is and errors.As (Go 1.13+)

### errors.Is - Check error type
```go
err := someOperation()

// Old way
if err == ErrNotFound {
    // handle
}

// New way (works with wrapped errors)
if errors.Is(err, ErrNotFound) {
    // handle
}
```

### errors.As - Extract error type
```go
type ValidationError struct {
    Field string
}

func (e *ValidationError) Error() string {
    return e.Field
}

err := validate()
var ve *ValidationError
if errors.As(err, &ve) {
    fmt.Println("Validation failed on:", ve.Field)
}
```

## Multiple Error Returns

**Common pattern:**
```go
func readFile(path string) ([]byte, error) {
    // return data and error
    data, err := os.ReadFile(path)
    if err != nil {
        return nil, err
    }
    return data, nil
}
```

## Defer for Cleanup

**C++ RAII:**
```cpp
void process() {
    File* f = open("file.txt");
    // do work
    f->close();  // might forget if error!
}
```

**Go defer:**
```go
func process() error {
    f, err := os.Open("file.txt")
    if err != nil {
        return err
    }
    defer f.Close()  // always runs!
    
    // do work
    // error or success, Close() is called
    return nil
}
```

## Error Wrapping Best Practices

**Add context:**
```go
func getUserFromDB(id int) (*User, error) {
    user, err := db.Query(id)
    if err != nil {
        return nil, fmt.Errorf("get user %d: %w", id, err)
    }
    return user, nil
}

// Error chain: "get user 123: connection refused"
```

## panic and recover

**Similar to exceptions but for unrecoverable errors:**

### panic - Don't Use for Normal Errors!
```go
func divide(a, b int) int {
    if b == 0 {
        panic("division by zero")  // program crash!
    }
    return a / b
}
```

### recover - Catch panic
```go
func safeCall() {
    defer func() {
        if r := recover(); r != nil {
            fmt.Println("Recovered from panic:", r)
        }
    }()
    
    // code that might panic
    panic("something went wrong")
}
```

**When to use panic:**
- Programming errors (bugs)
- Initialization failures
- Impossible situations
- NOT for expected errors!

## Error Handling in Practice

### Database Operations
```go
func createUser(user *User) error {
    tx, err := db.Begin()
    if err != nil {
        return fmt.Errorf("begin transaction: %w", err)
    }
    defer tx.Rollback()  // no-op if committed
    
    if err := insertUser(tx, user); err != nil {
        return fmt.Errorf("insert user: %w", err)
    }
    
    if err := tx.Commit(); err != nil {
        return fmt.Errorf("commit: %w", err)
    }
    
    return nil
}
```

### HTTP Handlers
```go
func handler(w http.ResponseWriter, r *http.Request) {
    data, err := processRequest(r)
    if err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }
    
    json.NewEncoder(w).Encode(data)
}
```

### Retrying Operations
```go
func fetchWithRetry(url string, maxRetries int) ([]byte, error) {
    var lastErr error
    
    for i := 0; i < maxRetries; i++ {
        resp, err := http.Get(url)
        if err == nil {
            defer resp.Body.Close()
            return io.ReadAll(resp.Body)
        }
        lastErr = err
        time.Sleep(time.Second * time.Duration(i+1))
    }
    
    return nil, fmt.Errorf("failed after %d retries: %w", maxRetries, lastErr)
}
```

## Custom Error Types

### With Additional Context
```go
type HTTPError struct {
    StatusCode int
    Message    string
    Err        error
}

func (e *HTTPError) Error() string {
    if e.Err != nil {
        return fmt.Sprintf("HTTP %d: %s: %v", e.StatusCode, e.Message, e.Err)
    }
    return fmt.Sprintf("HTTP %d: %s", e.StatusCode, e.Message)
}

func (e *HTTPError) Unwrap() error {
    return e.Err
}
```

## Error Groups (golang.org/x/sync/errgroup)

**Handle multiple errors:**
```go
import "golang.org/x/sync/errgroup"

func processFiles(files []string) error {
    g := new(errgroup.Group)
    
    for _, file := range files {
        file := file  // capture loop variable
        g.Go(func() error {
            return processFile(file)
        })
    }
    
    // Wait for all, return first error
    return g.Wait()
}
```

## Learning Path

### Basic Level
- error interface
- Creating errors with errors.New
- Checking if err != nil
- Returning errors
- Basic error handling patterns

### Intermediate Level
- Custom error types
- fmt.Errorf with %w
- errors.Is and errors.As
- Sentinel errors
- defer for cleanup
- Error wrapping

### Advanced Level
- panic and recover
- Error groups
- Context cancellation
- Advanced error patterns
- Performance considerations
- Testing error paths

## Key Differences from C++

1. **No exceptions** - Errors are values
2. **Explicit checking** - Must check err != nil
3. **Multiple returns** - Return (value, error)
4. **No try-catch** - Use if err != nil
5. **defer for cleanup** - Instead of RAII
6. **panic/recover exists** - But rarely used
7. **Errors are composable** - Wrapping pattern

## Common Patterns

### Guard Clauses
```go
func process(input string) error {
    if input == "" {
        return ErrEmptyInput
    }
    if len(input) > 1000 {
        return ErrInputTooLarge
    }
    // happy path
    return nil
}
```

### Error Variable
```go
var err error

result, err = step1()
if err != nil {
    return err
}

result, err = step2(result)
if err != nil {
    return err
}
```

### Named Returns for Defer
```go
func process() (err error) {
    f, err := os.Open("file.txt")
    if err != nil {
        return err
    }
    defer func() {
        closeErr := f.Close()
        if err == nil {
            err = closeErr
        }
    }()
    
    // process file
    return nil
}
```

## Common Pitfalls

1. **Ignoring errors** - Always check!
2. **Swallowing errors** - At least log them
3. **Not wrapping errors** - Lose context
4. **Using panic for normal errors** - Anti-pattern
5. **Not using defer** - Resource leaks
6. **Checking wrong error** - Use errors.Is/As
7. **Error shadowing** - := creates new variable

## Error Anti-Patterns

**Don't do this:**
```go
// Ignoring errors
data, _ := readFile()  // BAD!

// Panic for normal errors
if err != nil {
    panic(err)  // BAD! Use return
}

// Lost context
if err != nil {
    return errors.New("failed")  // Lost original error!
}

// Should be:
if err != nil {
    return fmt.Errorf("operation failed: %w", err)
}
```

## Practice Context

Focus on:
- Always checking errors
- Wrapping errors with context
- Using errors.Is and errors.As
- Designing custom error types
- Proper defer usage
- When to panic (rarely!)
- Converting C++ try-catch to Go error handling
