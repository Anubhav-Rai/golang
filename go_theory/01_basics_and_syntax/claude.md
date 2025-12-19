# Go Basics and Syntax - Learning Context

## Topic Overview
This section covers the fundamental syntax and structure of Go programs, comparing with C/C++ concepts you already know.

## Key Differences from C/C++

### Program Structure
**C/C++:**
```cpp
#include <iostream>
using namespace std;

int main() {
    cout << "Hello World" << endl;
    return 0;
}
```

**Go:**
```go
package main

import "fmt"

func main() {
    fmt.Println("Hello World")
}
```

### Key Points:
1. **No semicolons required** - Go automatically inserts them
2. **Package system** - Every file belongs to a package (like namespaces but more powerful)
3. **No header files** - Everything in one place
4. **Implicit main return** - main() doesn't need return 0
5. **Capital letters matter** - Exported names start with capital letters

## Basic Syntax Rules

### Comments
Same as C/C++:
```go
// Single line comment
/* Multi-line
   comment */
```

### Brace Style (MANDATORY)
```go
// Correct - opening brace must be on same line
func main() {
    // code
}

// ERROR - will not compile!
func main()
{
    // code
}
```

### Variable Declaration
**C/C++:**
```cpp
int x = 10;
string name = "John";
```

**Go (Type After Name):**
```go
var x int = 10
var name string = "John"

// Short declaration (type inference)
y := 20  // only inside functions
```

### Visibility Rules
- **Capitalized** = Public/Exported: `func PrintMessage()`
- **Lowercase** = Private/Package-level: `func printMessage()`

No public/private keywords like C++!

## Learning Path

### Basic Level
- Setting up Go environment
- Writing first program
- Understanding packages
- Basic syntax rules
- Simple input/output

### Intermediate Level
- Package organization
- Import management
- Code formatting with gofmt
- Build and run commands
- Understanding GOPATH and modules

### Advanced Level
- Build tags and constraints
- Cross-compilation
- Custom build processes
- Compiler directives
- AST manipulation

## Quick Reference Commands

```bash
# Run a Go program
go run main.go

# Build executable
go build main.go

# Format code (ALWAYS do this!)
go fmt main.go

# Get dependencies
go get package_name

# Initialize module
go mod init module_name
```

## Common Pitfalls from C/C++

1. **Unused variables/imports** = Compilation error (not warning!)
2. **No implicit type conversions** - Must be explicit
3. **No pointer arithmetic** - Safer than C/C++
4. **defer statement** - Cleanup runs at function exit (like RAII but simpler)
5. **Multiple return values** - Common pattern, no tuples needed

## Practice Questions Context

When working on this topic, focus on:
- Converting simple C++ programs to Go
- Understanding the build system
- Getting comfortable with go fmt
- Learning the standard library organization
