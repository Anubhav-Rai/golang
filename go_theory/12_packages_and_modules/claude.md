# Go Packages and Modules - Learning Context

## Topic Overview
Go's package and module system is cleaner than C/C++ headers and more straightforward than modern C++ modules.

## Packages vs C++ Namespaces

**C++:**
```cpp
// math.h
#ifndef MATH_H
#define MATH_H
namespace math {
    int add(int a, int b);
}
#endif

// math.cpp
#include "math.h"
namespace math {
    int add(int a, int b) { return a + b; }
}

// main.cpp
#include "math.h"
using namespace math;  // or math::add()
```

**Go:**
```go
// math/math.go
package math

func Add(a, b int) int {  // Capital = exported
    return a + b
}

// main.go
package main

import "myproject/math"

func main() {
    sum := math.Add(1, 2)
}
```

## Package Basics

### Package Declaration
```go
// Every .go file starts with package
package main  // executable package

package utils  // library package
```

### Naming Rules
- Package name = last element of import path
- lowercase, no underscores
- Short, concise names

```go
import "encoding/json"  // package name is json
import "net/http"       // package name is http
```

## Visibility Rules

**C++:** public/private/protected keywords
```cpp
class MyClass {
private:
    int privateField;
public:
    int publicField;
};
```

**Go - Capitalization:**
```go
package mypackage

// Exported (public) - starts with capital
type User struct {
    Name string  // exported field
    age  int     // unexported field
}

func NewUser() *User {}  // exported function
func validate() bool {}  // unexported function

// From other packages:
// Can access: User, Name, NewUser
// Cannot access: age, validate
```

## Import Statements

### Basic Import
```go
import "fmt"
import "os"

// Or grouped
import (
    "fmt"
    "os"
)
```

### Import Alias
```go
import (
    "crypto/rand"
    mrand "math/rand"  // alias to avoid conflict
)

// Use as mrand.Int()
```

### Dot Import (Discouraged)
```go
import . "fmt"

// Now can use without qualifier
Println("Hello")  // instead of fmt.Println
```

### Blank Import (Side Effects)
```go
import _ "image/png"

// Runs init() but doesn't use package
// Used for driver registration, etc.
```

## Internal Package

**Special directory name:**
```
myproject/
  internal/
    auth/
      auth.go  // only accessible to myproject
  api/
    api.go  // can access internal/auth
```

## Go Modules (go.mod)

**Like package managers in other languages:**

### Initialize Module
```bash
go mod init github.com/user/project
```

**Creates go.mod:**
```go
module github.com/user/project

go 1.21

require (
    github.com/gorilla/mux v1.8.0
    golang.org/x/sync v0.3.0
)
```

### Adding Dependencies
```bash
go get github.com/gorilla/mux
go get github.com/pkg/errors@v0.9.1  # specific version
```

### Module Structure
```
myproject/
├── go.mod          # module definition
├── go.sum          # dependency checksums
├── main.go
└── internal/
    └── utils/
        └── utils.go
```

## Package Layout

### Single Package
```
calculator/
├── go.mod
├── calc.go
└── calc_test.go
```

### Multiple Packages
```
myapp/
├── go.mod
├── main.go
├── handlers/
│   └── handlers.go
├── models/
│   └── user.go
└── utils/
    └── helpers.go
```

### Standard Project Layout
```
project/
├── cmd/              # Main applications
│   └── myapp/
│       └── main.go
├── internal/         # Private code
│   ├── service/
│   └── repository/
├── pkg/             # Public libraries
│   └── api/
├── go.mod
└── go.sum
```

## init() Function

**Runs automatically on package import:**
```go
package database

import "database/sql"

var DB *sql.DB

func init() {
    // Runs before main()
    // Can have multiple init() in same package
    DB = connectDatabase()
}

// Another init in same file
func init() {
    registerDrivers()
}
```

**Execution order:**
1. Import dependencies
2. Initialize package-level variables
3. Run init() functions
4. Repeat for all packages
5. Run main()

## Circular Dependencies - NOT ALLOWED

**C++:** Possible with forward declarations
**Go:** Compile error!

```go
// package a
import "myproject/b"  // ERROR if b imports a

// Must refactor to break cycle
// Common solution: introduce third package
```

## Vendoring

**Copy dependencies into project:**
```bash
go mod vendor
```

```
myproject/
├── go.mod
├── go.sum
├── vendor/         # dependencies copied here
│   ├── github.com/
│   └── golang.org/
└── main.go
```

## Replace Directive

**Use local or forked version:**
```go
// go.mod
module myproject

require github.com/some/package v1.2.3

// Use local version
replace github.com/some/package => ../local/package

// Or fork
replace github.com/some/package => github.com/myuser/package v1.2.4
```

## Package Documentation

**Comments before package:**
```go
// Package math provides mathematical functions.
//
// This package implements basic arithmetic operations
// and more advanced mathematical computations.
package math

// Add returns the sum of two integers.
// It handles both positive and negative numbers.
func Add(a, b int) int {
    return a + b
}
```

**View documentation:**
```bash
go doc math
go doc math.Add
```

## Comparing to C++

### Header Files
**C++:** Separate .h and .cpp
**Go:** Single .go file, no headers

### Namespaces
**C++:** namespace keyword, can nest
**Go:** Package system, flat structure

### Include Guards
**C++:** #ifndef, #define, #endif
**Go:** Not needed, each file imports once

### Linking
**C++:** Complex linking, symbol resolution
**Go:** Simpler, compiler handles it

## Module Commands

```bash
# Initialize module
go mod init module/path

# Add dependency
go get package@version

# Update dependencies
go get -u
go get -u=patch  # patch version only

# Tidy (remove unused)
go mod tidy

# Verify checksums
go mod verify

# Download dependencies
go mod download

# Create vendor directory
go mod vendor

# Show dependency graph
go mod graph
```

## Version Selection

**Semantic versioning:**
```
v1.2.3
 │ │ └── Patch: bug fixes
 │ └──── Minor: new features, backward compatible
 └────── Major: breaking changes
```

**Import with version:**
```go
import "github.com/user/package/v2"  // v2+ uses /v2
```

## Learning Path

### Basic Level
- Package declaration
- Import statements
- Visibility rules (capitalization)
- Creating simple packages
- Using standard library

### Intermediate Level
- Module creation (go.mod)
- Dependency management
- Package organization
- internal packages
- init() function
- Documentation

### Advanced Level
- Module versioning
- Replace directives
- Vendoring
- Module proxies
- Private modules
- Build constraints

## Best Practices

### Package Naming
```go
// Good
package user
package http
package json

// Bad
package user_management
package myPackage
package utils  // too generic
```

### Package Size
```go
// Keep packages focused
// Good: One clear responsibility
package auth

// Bad: Kitchen sink
package stuff
```

### Imports Organization
```go
import (
    // Standard library first
    "fmt"
    "os"
    
    // External packages
    "github.com/gorilla/mux"
    
    // Internal packages last
    "myproject/internal/models"
)
```

## Common Pitfalls

1. **Circular imports** - Refactor needed
2. **Package name != directory** - Can differ
3. **Too many small packages** - Over-engineering
4. **utils/helpers packages** - Code smell
5. **Forgetting go mod tidy** - Unused deps
6. **Wrong visibility** - Check capitalization
7. **Dot imports** - Avoid except tests

## Testing Packages

**Test files in same package:**
```go
// calc.go
package calc

func Add(a, b int) int { return a + b }

// calc_test.go
package calc

import "testing"

func TestAdd(t *testing.T) {
    result := Add(2, 3)
    if result != 5 {
        t.Errorf("Expected 5, got %d", result)
    }
}
```

**Black-box testing:**
```go
// calc_test.go
package calc_test  // different package!

import (
    "testing"
    "myproject/calc"
)

func TestAdd(t *testing.T) {
    result := calc.Add(2, 3)  // test as external user
}
```

## Practice Context

Focus on:
- Creating well-organized packages
- Understanding module system
- Managing dependencies
- Visibility rules
- Package naming conventions
- Converting C++ project structure to Go
- Writing package documentation
