# Go Testing - Learning Context

## Topic Overview
Go has built-in testing support - no external frameworks needed. Much simpler than C++ testing frameworks like Google Test or Catch2.

## Basic Test Structure

**C++ (Google Test):**
```cpp
#include <gtest/gtest.h>

TEST(MathTest, Addition) {
    EXPECT_EQ(add(2, 3), 5);
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
```

**Go (Built-in):**
```go
// math.go
package math

func Add(a, b int) int {
    return a + b
}

// math_test.go
package math

import "testing"

func TestAdd(t *testing.T) {
    result := Add(2, 3)
    if result != 5 {
        t.Errorf("Expected 5, got %d", result)
    }
}
```

**Run tests:**
```bash
go test
go test -v  # verbose
go test ./...  # all packages
```

## Test Function Rules

**Must follow pattern:**
```go
func TestXxx(t *testing.T) {
    // Test name must start with Test
    // Must take *testing.T parameter
}
```

## Testing Methods

### t.Error vs t.Fatal
```go
func TestExample(t *testing.T) {
    // Error - continues test
    if result != expected {
        t.Error("Test failed but continues")
        t.Errorf("Failed: got %d, want %d", result, expected)
    }
    
    // Fatal - stops test immediately
    if critical != expected {
        t.Fatal("Critical failure, stopping")
        t.Fatalf("Fatal: got %d, want %d", critical, expected)
    }
    // Code after Fatal not executed
}
```

### Other Methods
```go
t.Log("Logging message")
t.Logf("Logging %s", "formatted")

t.Skip("Skipping this test")
t.Skipf("Skipping because %s", reason)

t.Fail()        // Mark failed, continue
t.FailNow()     // Mark failed, stop immediately
```

## Table-Driven Tests

**Go idiom for multiple test cases:**
```go
func TestAdd(t *testing.T) {
    tests := []struct {
        name string
        a, b int
        want int
    }{
        {"positive", 2, 3, 5},
        {"negative", -1, -2, -3},
        {"zero", 0, 5, 5},
        {"mixed", -1, 2, 1},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := Add(tt.a, tt.b)
            if got != tt.want {
                t.Errorf("Add(%d, %d) = %d, want %d", 
                    tt.a, tt.b, got, tt.want)
            }
        })
    }
}
```

**Run specific subtest:**
```bash
go test -run TestAdd/positive
```

## Subtests

**Organize related tests:**
```go
func TestMath(t *testing.T) {
    t.Run("Addition", func(t *testing.T) {
        if Add(2, 3) != 5 {
            t.Error("Addition failed")
        }
    })
    
    t.Run("Subtraction", func(t *testing.T) {
        if Sub(5, 3) != 2 {
            t.Error("Subtraction failed")
        }
    })
}
```

## Test Setup and Teardown

**TestMain for package-level setup:**
```go
func TestMain(m *testing.M) {
    // Setup
    fmt.Println("Setup before tests")
    db := setupDatabase()
    
    // Run tests
    code := m.Run()
    
    // Teardown
    fmt.Println("Cleanup after tests")
    db.Close()
    
    os.Exit(code)
}
```

**Per-test setup:**
```go
func setupTest(t *testing.T) (*Database, func()) {
    db := createTestDB()
    
    // Return cleanup function
    cleanup := func() {
        db.Close()
    }
    
    return db, cleanup
}

func TestSomething(t *testing.T) {
    db, cleanup := setupTest(t)
    defer cleanup()
    
    // use db
}
```

## Benchmarking

**C++:** Complex setup
**Go - Built-in:**
```go
func BenchmarkAdd(b *testing.B) {
    for i := 0; i < b.N; i++ {
        Add(2, 3)
    }
}

// Run benchmarks
// go test -bench=.
// go test -bench=Add
// go test -bench=. -benchmem  # memory stats
```

**Advanced benchmarking:**
```go
func BenchmarkComplex(b *testing.B) {
    // Setup (not timed)
    data := generateLargeDataset()
    
    b.ResetTimer()  // Reset timer after setup
    
    for i := 0; i < b.N; i++ {
        processData(data)
    }
    
    b.StopTimer()  // Stop timing
    // Cleanup
    b.StartTimer()  // Resume if needed
}
```

**Parallel benchmarks:**
```go
func BenchmarkParallel(b *testing.B) {
    b.RunParallel(func(pb *testing.PB) {
        for pb.Next() {
            // Test code
        }
    })
}
```

## Example Tests (Documentation)

**Testable examples that appear in godoc:**
```go
func ExampleAdd() {
    result := Add(2, 3)
    fmt.Println(result)
    // Output: 5
}

func ExampleAdd_negative() {
    result := Add(-1, -2)
    fmt.Println(result)
    // Output: -3
}

// Unordered output
func ExampleMap() {
    m := map[string]int{"a": 1, "b": 2}
    for k, v := range m {
        fmt.Printf("%s:%d\n", k, v)
    }
    // Unordered output:
    // a:1
    // b:2
}
```

## Test Coverage

**Check how much code is tested:**
```bash
# Run tests with coverage
go test -cover

# Generate coverage profile
go test -coverprofile=coverage.out

# View in browser
go tool cover -html=coverage.out

# Coverage by function
go tool cover -func=coverage.out
```

**Coverage in code:**
```go
func TestCoverage(t *testing.T) {
    // Tests should cover all branches
    if condition {
        // branch 1
    } else {
        // branch 2
    }
}
```

## Mocking and Interfaces

**Go approach - use interfaces:**
```go
// Production code
type Database interface {
    Query(sql string) ([]Row, error)
}

type UserService struct {
    db Database
}

// Mock for testing
type MockDatabase struct {
    QueryFunc func(string) ([]Row, error)
}

func (m *MockDatabase) Query(sql string) ([]Row, error) {
    return m.QueryFunc(sql)
}

// Test
func TestUserService(t *testing.T) {
    mock := &MockDatabase{
        QueryFunc: func(sql string) ([]Row, error) {
            return []Row{{ID: 1}}, nil
        },
    }
    
    service := UserService{db: mock}
    // test service
}
```

## Testing HTTP Handlers

**httptest package:**
```go
import "net/http/httptest"

func TestHandler(t *testing.T) {
    // Create request
    req := httptest.NewRequest("GET", "/api/users", nil)
    
    // Create response recorder
    w := httptest.NewRecorder()
    
    // Call handler
    handler(w, req)
    
    // Check response
    if w.Code != http.StatusOK {
        t.Errorf("Expected 200, got %d", w.Code)
    }
    
    body := w.Body.String()
    if !strings.Contains(body, "expected") {
        t.Error("Response doesn't contain expected data")
    }
}
```

**Test server:**
```go
func TestAPICall(t *testing.T) {
    // Create test server
    server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        w.WriteHeader(http.StatusOK)
        w.Write([]byte(`{"status":"ok"}`))
    }))
    defer server.Close()
    
    // Make request to test server
    resp, err := http.Get(server.URL)
    if err != nil {
        t.Fatal(err)
    }
    defer resp.Body.Close()
    
    // Check response
    if resp.StatusCode != http.StatusOK {
        t.Errorf("Expected 200, got %d", resp.StatusCode)
    }
}
```

## Test Helpers

**Helper functions:**
```go
func assertEqual(t *testing.T, got, want interface{}) {
    t.Helper()  // Marks as helper (better error messages)
    if got != want {
        t.Errorf("got %v, want %v", got, want)
    }
}

func TestWithHelper(t *testing.T) {
    assertEqual(t, Add(2, 3), 5)
}
```

## Testing with Race Detector

**Detect race conditions:**
```bash
go test -race

# Example
func TestConcurrent(t *testing.T) {
    var counter int
    
    var wg sync.WaitGroup
    for i := 0; i < 100; i++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            counter++  // Race detected!
        }()
    }
    wg.Wait()
}
```

## Testing Time

**Mock time for tests:**
```go
// Production code with time interface
type Clock interface {
    Now() time.Time
}

type RealClock struct{}
func (RealClock) Now() time.Time { return time.Now() }

// Test with mock clock
type MockClock struct {
    CurrentTime time.Time
}
func (m MockClock) Now() time.Time { return m.CurrentTime }

func TestWithTime(t *testing.T) {
    clock := MockClock{CurrentTime: time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)}
    // test with fixed time
}
```

## Golden Files

**Compare output to saved files:**
```go
import "io/ioutil"

func TestGolden(t *testing.T) {
    output := generateOutput()
    
    goldenFile := "testdata/golden.txt"
    
    // Update golden file
    if *update {
        ioutil.WriteFile(goldenFile, output, 0644)
    }
    
    // Compare
    expected, _ := ioutil.ReadFile(goldenFile)
    if !bytes.Equal(output, expected) {
        t.Error("Output doesn't match golden file")
    }
}
```

## Test Flags

**Custom test flags:**
```go
var integration = flag.Bool("integration", false, "Run integration tests")

func TestIntegration(t *testing.T) {
    if !*integration {
        t.Skip("Skipping integration test")
    }
    // integration test code
}

// Run with: go test -integration
```

## Learning Path

### Basic Level
- Writing simple tests
- Table-driven tests
- Running tests
- t.Error vs t.Fatal
- Test coverage basics

### Intermediate Level
- Subtests and t.Run
- Benchmarking
- Example tests
- HTTP testing
- Mocking with interfaces
- Test helpers

### Advanced Level
- TestMain for setup
- Race detector
- Golden files
- Parallel tests
- Advanced mocking
- Performance testing
- Integration tests

## Key Differences from C++

1. **Built-in support** - No external frameworks
2. **Simple syntax** - Just functions
3. **Table-driven** - Idiomatic pattern
4. **Benchmarking** - Built into test framework
5. **Coverage tools** - Integrated
6. **Example tests** - Documentation + tests
7. **HTTP testing** - Standard library support

## Best Practices

1. **Use table-driven tests** - Multiple cases easily
2. **Name tests clearly** - TestFunctionName_Scenario
3. **Use t.Helper()** - For helper functions
4. **Check coverage** - Aim for high coverage
5. **Benchmark critical code** - Performance matters
6. **Use interfaces for mocking** - Testability
7. **Keep tests fast** - Quick feedback loop
8. **Test behavior, not implementation**

## Common Pitfalls

1. **Not using t.Helper()** - Confusing error locations
2. **Testing implementation** - Test behavior instead
3. **Slow tests** - Keep them fast
4. **No table-driven tests** - Repetitive code
5. **Ignoring benchmarks** - Performance surprises
6. **Not using -race** - Hidden race conditions
7. **Forgetting edge cases** - Nil, empty, errors

## Test Organization

**File structure:**
```
package/
├── math.go
├── math_test.go      # same package tests
├── math_internal_test.go  # internal tests
├── export_test.go    # expose internals for testing
└── testdata/         # test fixtures
    └── golden.txt
```

## Practice Context

Focus on:
- Writing comprehensive tests
- Table-driven test patterns
- Benchmarking code
- Using coverage tools
- Mocking with interfaces
- HTTP handler testing
- Converting C++ tests to Go
- Test organization
