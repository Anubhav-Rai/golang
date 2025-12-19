#!/bin/bash

# Topic 11: Error Handling
cd 11_error_handling
cat > claude.md << 'EOF'
# Topic 11: Error Handling

## Context
No exceptions! Errors as values - explicit handling.

## Structure
- `basic/` - Error basics, if err != nil
- `intermediate/` - Custom errors, wrapping
- `advanced/` - panic/recover, sentinel errors

## Key Focus
- Errors are values
- No try/catch
- Multiple return values
- Error wrapping
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
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
EOF

cat > errors.go << 'EOF'
package main

import (
"errors"
"fmt"
)

func divide(a, b int) (int, error) {
if b == 0 {
return 0, errors.New("division by zero")
}
return a / b, nil
}

func main() {
result, err := divide(10, 2)
if err != nil {
fmt.Println("Error:", err)
return
}
fmt.Println("Result:", result)

result, err = divide(10, 0)
if err != nil {
fmt.Println("Error:", err)
}
}
EOF

cd ../intermediate && rm .gitkeep
cat > theory.md << 'EOF'
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
EOF

cd ../../

# Topic 12: Packages and Modules
cd 12_packages_and_modules
cat > claude.md << 'EOF'
# Topic 12: Packages and Modules

## Context
Go modules system - simpler than C++ build systems.

## Structure
- `basic/` - Package basics, imports, go.mod
- `intermediate/` - internal/, vendor/, replace directives

## Key Focus
- go.mod for dependencies
- No Makefiles needed
- internal/ for private packages
- Semantic versioning
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Packages - Theory

## Package Layout
```
myproject/
├── go.mod
├── main.go
├── util/
│   └── helper.go
└── internal/
    └── secret.go
```

## go.mod
```bash
go mod init github.com/user/project
go mod tidy
```

## Imports
```go
import (
    "fmt"                          // Standard library
    "myproject/util"               // Local package
    "github.com/user/pkg"          // External
)
```

## Visibility
- Uppercase = exported
- Lowercase = package private
- `internal/` = accessible only by parent
EOF

cd ../../

# Topic 13: Concurrency
cd 13_concurrency
cat > claude.md << 'EOF'
# Topic 13: Concurrency

## Context
Goroutines - lightweight threads, Go's superpower.

## Structure
- `basic/` - Goroutines basics, WaitGroup
- `intermediate/` - Mutex, RWMutex, sync primitives
- `advanced/` - Race detector, atomic, context

## Key Focus
- go keyword creates goroutine
- Much lighter than threads
- WaitGroup for synchronization
- Mutex for shared state
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Goroutines - Theory

## C++ vs Go

### C++ Threads
```cpp
#include <thread>

void task() { }

std::thread t(task);
t.join();
```

### Go Goroutines
```go
func task() { }

go task()  // That's it!

// Wait for completion
var wg sync.WaitGroup
wg.Add(1)
go func() {
    defer wg.Done()
    task()
}()
wg.Wait()
```

## Goroutines
- Very lightweight (~2KB stack)
- Multiplexed onto threads
- Can have thousands/millions
- Started with `go` keyword

## WaitGroup
```go
var wg sync.WaitGroup

for i := 0; i < 10; i++ {
    wg.Add(1)
    go func(id int) {
        defer wg.Done()
        work(id)
    }(i)
}

wg.Wait()
```
EOF

cat > goroutines.go << 'EOF'
package main

import (
"fmt"
"sync"
"time"
)

func worker(id int, wg *sync.WaitGroup) {
defer wg.Done()
fmt.Printf("Worker %d starting\n", id)
time.Sleep(time.Second)
fmt.Printf("Worker %d done\n", id)
}

func main() {
var wg sync.WaitGroup

for i := 1; i <= 5; i++ {
wg.Add(1)
go worker(i, &wg)
}

wg.Wait()
fmt.Println("All workers done")
}
EOF

cd ../intermediate && rm .gitkeep
cat > theory.md << 'EOF'
# Mutex - Theory

## Protecting Shared State
```go
type Counter struct {
    mu    sync.Mutex
    value int
}

func (c *Counter) Inc() {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.value++
}

func (c *Counter) Value() int {
    c.mu.Lock()
    defer c.mu.Unlock()
    return c.value
}
```

## RWMutex
```go
type Cache struct {
    mu   sync.RWMutex
    data map[string]string
}

func (c *Cache) Get(key string) string {
    c.mu.RLock()
    defer c.mu.RUnlock()
    return c.data[key]
}

func (c *Cache) Set(key, val string) {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.data[key] = val
}
```
EOF

cd ../../

# Topic 14: Channels
cd 14_channels
cat > claude.md << 'EOF'
# Topic 14: Channels

## Context
CSP model - communicate by sharing, not share by communicating.

## Structure
- `basic/` - Channel basics, send/receive
- `intermediate/` - Buffered channels, select, close
- `advanced/` - Patterns: pipeline, fan-out, cancellation

## Key Focus
- Channels for communication
- Buffered vs unbuffered
- select statement
- Channel directions
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# Channels - Theory

## Creating Channels
```go
ch := make(chan int)        // Unbuffered
ch := make(chan int, 10)    // Buffered (capacity 10)
```

## Send and Receive
```go
ch <- value     // Send
value := <-ch   // Receive
value, ok := <-ch  // Receive with closed check
```

## Unbuffered vs Buffered
```go
// Unbuffered - blocks until received
ch := make(chan int)
ch <- 1  // Blocks until someone receives!

// Buffered - blocks when full
ch := make(chan int, 3)
ch <- 1  // OK
ch <- 2  // OK
ch <- 3  // OK
ch <- 4  // Blocks!
```

## Closing Channels
```go
close(ch)

// Check if closed
value, ok := <-ch
if !ok {
    // Channel closed
}

// Range over channel
for value := range ch {
    // Stops when closed
}
```
EOF

cat > channels.go << 'EOF'
package main

import "fmt"

func producer(ch chan int) {
for i := 0; i < 5; i++ {
ch <- i
}
close(ch)
}

func main() {
ch := make(chan int)

go producer(ch)

for val := range ch {
fmt.Println("Received:", val)
}
}
EOF

cd ../intermediate && rm .gitkeep
cat > theory.md << 'EOF'
# Select Statement - Theory

## Select (Like switch for channels)
```go
select {
case msg := <-ch1:
    fmt.Println("From ch1:", msg)
case msg := <-ch2:
    fmt.Println("From ch2:", msg)
case ch3 <- value:
    fmt.Println("Sent to ch3")
default:
    fmt.Println("No activity")
}
```

## Timeout Pattern
```go
select {
case result := <-ch:
    // Got result
case <-time.After(5 * time.Second):
    // Timeout
}
```

## Channel Directions
```go
// Send-only
func producer(ch chan<- int) {
    ch <- 42
}

// Receive-only
func consumer(ch <-chan int) {
    val := <-ch
}
```
EOF

cd ../../

# Topic 15: File I/O
cd 15_file_io
cat > claude.md << 'EOF'
# Topic 15: File I/O

## Context
Go I/O - interface-based, simpler than C++ streams.

## Structure
- `basic/` - Reading/writing files, os package
- `intermediate/` - bufio, io.Reader/Writer, JSON

## Key Focus
- os.Open, os.Create
- io.Reader/Writer interfaces
- bufio for buffering
- JSON encoding/decoding
EOF

cd basic && rm .gitkeep
cat > theory.md << 'EOF'
# File I/O - Theory

## Reading Files
```go
// Read entire file
data, err := os.ReadFile("file.txt")
if err != nil {
    log.Fatal(err)
}
fmt.Println(string(data))

// Read with control
f, err := os.Open("file.txt")
if err != nil {
    log.Fatal(err)
}
defer f.Close()

scanner := bufio.NewScanner(f)
for scanner.Scan() {
    fmt.Println(scanner.Text())
}
```

## Writing Files
```go
// Write entire file
err := os.WriteFile("out.txt", []byte("content"), 0644)

// Write with control
f, err := os.Create("out.txt")
if err != nil {
    log.Fatal(err)
}
defer f.Close()

f.WriteString("Hello\n")
```
EOF

cd ../intermediate && rm .gitkeep
cat > theory.md << 'EOF'
# JSON and Interfaces - Theory

## JSON Encoding
```go
type Person struct {
    Name string `json:"name"`
    Age  int    `json:"age"`
}

p := Person{Name: "Alice", Age: 30}

// Marshal to JSON
data, err := json.Marshal(p)

// Unmarshal from JSON
var p2 Person
err = json.Unmarshal(data, &p2)
```

## io.Reader/Writer
```go
func processReader(r io.Reader) {
    data, _ := io.ReadAll(r)
    // Works with files, network, strings, etc.
}

// Works with any Reader
processReader(os.Stdin)
processReader(strings.NewReader("data"))
```
EOF

cd ../../

echo "Topics 11-15 done"
