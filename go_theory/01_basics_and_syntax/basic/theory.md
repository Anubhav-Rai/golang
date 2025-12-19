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
