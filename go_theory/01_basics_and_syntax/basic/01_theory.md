# Basic Go Syntax - Theory

## Hello World Comparison

### C++
```cpp
#include <iostream>
using namespace std;

int main() {
    cout << "Hello World" << endl;
    return 0;
}
```

### Go
```go
package main

import "fmt"

func main() {
    fmt.Println("Hello World")
}
```

## Key Differences

1. **No semicolons** - Automatically inserted by compiler
2. **package main** - Entry point package
3. **import** - Not #include
4. **func** - Function keyword
5. **No return 0** - Implicit for main()

## Running Go Programs

```bash
# Run directly
go run hello.go

# Build executable
go build hello.go
./hello

# Format code
go fmt hello.go
```
