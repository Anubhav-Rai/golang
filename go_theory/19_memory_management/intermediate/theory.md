# Memory Profiling - Theory

## pprof
```go
import _ "net/http/pprof"

go func() {
    http.ListenAndServe("localhost:6060", nil)
}()
```

Visit: http://localhost:6060/debug/pprof/

## sync.Pool
```go
var bufferPool = sync.Pool{
    New: func() interface{} {
        return make([]byte, 1024)
    },
}

buf := bufferPool.Get().([]byte)
defer bufferPool.Put(buf)
```
