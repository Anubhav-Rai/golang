#!/bin/bash

# Topic 01: Basics and Syntax
cd 01_basics_and_syntax

cat > claude.md << 'EOF'
# Topic 01: Go Basics and Syntax

## Context
Learning Go program structure, syntax basics, comparing with C/C++.

## Structure
- `basic/` - Hello world, program structure, basic syntax
- `intermediate/` - Packages, imports, visibility, multiple files
- `advanced/` - Build tags, compiler directives, cross-compilation

## Key Focus
- No semicolons, no headers
- Package system vs C++ includes
- Capitalization = visibility
- defer keyword
EOF

cd basic
rm .gitkeep
cat > theory.md << 'EOF'
# Go Basics - Theory

## Program Structure

### C++ vs Go
```cpp
// C++
#include <iostream>
int main() {
    std::cout << "Hello\n";
    return 0;
}
```

```go
// Go
package main
import "fmt"
func main() {
    fmt.Println("Hello")
}
```

## Key Differences
1. **No semicolons** (auto-inserted)
2. **package** declaration required
3. **No return 0** in main
4. **Capitalization = visibility**
   - Uppercase = exported (public)
   - Lowercase = unexported (private)
5. **No header files** - all in .go files

## Syntax Rules
- Opening brace must be on same line
- Use `go fmt` to format code
- Unused imports/variables = compile error
EOF

cat > hello.go << 'EOF'
// Your first Go program
package main

import "fmt"

func main() {
fmt.Println("Hello, Go!")
fmt.Println("Welcome, C++ developer!")
}
EOF

cat > variables.go << 'EOF'
// Basic variables example
package main

import "fmt"

func main() {
// Short declaration (most common)
name := "Gopher"
age := 10

// Explicit type
var country string = "Go Land"

// Multiple declarations
x, y := 10, 20

fmt.Println(name, age, country)
fmt.Println("Sum:", x+y)
}
EOF

cd ../intermediate
rm .gitkeep
cat > theory.md << 'EOF'
# Package System - Theory

## C++ vs Go Packages

### C++
```cpp
// math.h
#ifndef MATH_H
#define MATH_H
int Add(int a, int b);
#endif

// math.cpp
#include "math.h"
int Add(int a, int b) { return a + b; }
```

### Go
```go
// math.go (no header needed!)
package math
func Add(a, b int) int { return a + b }
```

## Visibility Rules
- **Uppercase** = Exported (public)
- **Lowercase** = Unexported (private)

```go
package mypack

func PublicFunc() {}   // Exported
func privateFunc() {}  // Not exported
```

## Imports
```go
import "fmt"                    // Single
import (                        // Multiple
    "fmt"
    "strings"
)
import f "fmt"                  // Alias
import . "fmt"                  // Don't do this
import _ "database/sql/driver"  // Side effects only
```
EOF

cd ../advanced
rm .gitkeep
cat > theory.md << 'EOF'
# Advanced Build - Theory

## Build Tags
```go
// +build linux darwin

package main
// This file only builds on Linux/Mac
```

## Cross Compilation
```bash
# Build for Windows from Linux
GOOS=windows GOARCH=amd64 go build

# Build for Mac ARM
GOOS=darwin GOARCH=arm64 go build

# Common targets
GOOS=linux GOARCH=amd64     # Linux 64-bit
GOOS=windows GOARCH=amd64   # Windows 64-bit
GOOS=darwin GOARCH=arm64    # Mac M1/M2
```

## Compiler Directives
```go
//go:noinline
func heavyFunc() { }

//go:nosplit
func lowLevel() { }
```

## Build Optimization
```bash
# Reduce binary size
go build -ldflags="-s -w" main.go

# Enable race detector
go build -race main.go
```
EOF

cd ../../

echo "Topic 01 done"
