# Maps - Theory

## C++ vs Go

### C++
```cpp
std::unordered_map<string, int> m;
m["key"] = 42;
if (m.find("key") != m.end()) {}
```

### Go
```go
m := make(map[string]int)
m["key"] = 42
if val, ok := m["key"]; ok {
    // key exists
}
```

## Creating Maps
```go
// make
m := make(map[string]int)

// Literal
m := map[string]int{
    "one": 1,
    "two": 2,
}

// Zero value is nil!
var m map[string]int  // nil map, can't use!
```

## Operations
```go
m[key] = value      // Set
val := m[key]       // Get (zero if missing)
delete(m, key)      // Delete
val, ok := m[key]   // Check existence
```
