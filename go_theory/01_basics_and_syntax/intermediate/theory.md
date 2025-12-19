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
