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
