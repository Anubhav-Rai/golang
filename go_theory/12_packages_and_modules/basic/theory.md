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
