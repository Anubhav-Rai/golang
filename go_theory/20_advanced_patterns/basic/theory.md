# Advanced Patterns - Theory

## Functional Options
```go
type Server struct {
    host string
    port int
}

type Option func(*Server)

func WithPort(port int) Option {
    return func(s *Server) {
        s.port = port
    }
}

func NewServer(host string, opts ...Option) *Server {
    s := &Server{host: host, port: 8080}
    for _, opt := range opts {
        opt(s)
    }
    return s
}

// Usage
server := NewServer("localhost", WithPort(9000))
```

## Context Pattern
```go
ctx, cancel := context.WithTimeout(
    context.Background(),
    5*time.Second,
)
defer cancel()

select {
case <-ctx.Done():
    return ctx.Err()
case result := <-ch:
    return nil
}
```
