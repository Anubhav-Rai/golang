# Go Maps - Learning Context

## Topic Overview
Maps in Go are similar to C++ `std::map` or `std::unordered_map`, but with simpler syntax and built-in language support.

## Basic Map Operations

**C++:**
```cpp
#include <map>
std::map<string, int> ages;
ages["Alice"] = 25;
ages["Bob"] = 30;

// Or unordered_map
#include <unordered_map>
std::unordered_map<string, int> ages;
```

**Go - Built-in Type:**
```go
// Declare and initialize
ages := map[string]int{
    "Alice": 25,
    "Bob":   30,
}

// Or with make
ages := make(map[string]int)
ages["Alice"] = 25
ages["Bob"] = 30

// Zero value is nil
var ages map[string]int  // nil map, can't use yet!
ages["Alice"] = 25       // panic!
```

## Creating Maps

**Three ways:**
```go
// 1. Literal
m := map[string]int{"a": 1, "b": 2}

// 2. make
m := make(map[string]int)

// 3. make with size hint (optimization)
m := make(map[string]int, 100)  // capacity hint

// Nil map
var m map[string]int  // nil, len=0
m == nil              // true
// m["key"] = 1       // panic!
```

## Accessing Elements

**C++:**
```cpp
// operator[] creates if not exists
int age = ages["Alice"];

// at() throws if not exists
int age = ages.at("Alice");

// find() for checking
auto it = ages.find("Alice");
if (it != ages.end()) {
    int age = it->second;
}
```

**Go - Comma Ok Idiom:**
```go
// Access (creates zero value if not exists)
age := ages["Alice"]  // 0 if not found

// Check existence with comma-ok
age, ok := ages["Alice"]
if ok {
    fmt.Println("Found:", age)
} else {
    fmt.Println("Not found")
}

// Common pattern
if age, ok := ages["Alice"]; ok {
    fmt.Println(age)
}
```

## Deleting Elements

**C++:**
```cpp
ages.erase("Alice");
```

**Go:**
```go
delete(ages, "Alice")

// Safe even if key doesn't exist
delete(ages, "NonExistent")  // no-op, no error
```

## Iterating Maps

**C++:**
```cpp
for (const auto& [key, value] : ages) {
    cout << key << ": " << value << endl;
}
```

**Go:**
```go
// Iteration order is RANDOM!
for key, value := range ages {
    fmt.Println(key, ":", value)
}

// Just keys
for key := range ages {
    fmt.Println(key)
}

// Just values
for _, value := range ages {
    fmt.Println(value)
}
```

## Map Key Types

**Requirements:**
```go
// Valid key types: comparable types
// - Booleans, numbers, strings
// - Pointers, channels, interfaces
// - Structs/arrays (if fields are comparable)

// Valid
map[string]int
map[int]string
map[[2]int]string  // array as key

// Invalid - slices, maps, functions not comparable
// map[[]int]string     // ERROR
// map[map[string]int]string  // ERROR
```

## Map as Sets

**C++:**
```cpp
std::set<int> numbers;
numbers.insert(1);
numbers.insert(2);
```

**Go - Map with Empty Struct:**
```go
// Use map[type]bool or map[type]struct{}
set := make(map[int]bool)
set[1] = true
set[2] = true

// Check membership
if set[1] {
    fmt.Println("1 is in set")
}

// Better: use empty struct (no memory)
set := make(map[int]struct{})
set[1] = struct{}{}
set[2] = struct{}{}

// Check membership
if _, exists := set[1]; exists {
    fmt.Println("1 is in set")
}
```

## Maps are Reference Types

**Like slices:**
```go
m1 := map[string]int{"a": 1}
m2 := m1  // Both refer to same map!

m2["a"] = 100
fmt.Println(m1["a"])  // 100

// To copy, must iterate
m2 := make(map[string]int)
for k, v := range m1 {
    m2[k] = v
}
```

## Nested Maps

**2D map:**
```go
// Map of maps
graph := make(map[string]map[string]int)

// Must initialize inner map
graph["A"] = make(map[string]int)
graph["A"]["B"] = 10

// Or check and create
if _, ok := graph["A"]; !ok {
    graph["A"] = make(map[string]int)
}
graph["A"]["B"] = 10
```

## Sorting Maps

**Maps are unordered, must extract keys:**
```go
import "sort"

ages := map[string]int{
    "Charlie": 35,
    "Alice":   25,
    "Bob":     30,
}

// Extract and sort keys
keys := make([]string, 0, len(ages))
for k := range ages {
    keys = append(keys, k)
}
sort.Strings(keys)

// Iterate in sorted order
for _, k := range keys {
    fmt.Println(k, ages[k])
}
```

## Concurrency and Maps

**Maps are NOT thread-safe:**
```go
// This is dangerous with concurrent access
m := make(map[string]int)

// Bad - race condition
go func() { m["key"] = 1 }()
go func() { m["key"] = 2 }()

// Solution 1: sync.Mutex
var mu sync.Mutex
mu.Lock()
m["key"] = 1
mu.Unlock()

// Solution 2: sync.Map (concurrent map)
var m sync.Map
m.Store("key", 1)
value, ok := m.Load("key")
```

## Common Patterns

### Count occurrences
```go
counts := make(map[string]int)
words := []string{"a", "b", "a", "c", "b", "a"}

for _, word := range words {
    counts[word]++  // zero value (0) used if not exists
}
// counts: {"a": 3, "b": 2, "c": 1}
```

### Group by key
```go
type Person struct {
    Name string
    Age  int
}

people := []Person{
    {"Alice", 25},
    {"Bob", 30},
    {"Charlie", 25},
}

// Group by age
groups := make(map[int][]Person)
for _, p := range people {
    groups[p.Age] = append(groups[p.Age], p)
}
```

### Default values
```go
// Provide default if not found
cache := make(map[string]int)

value, ok := cache["key"]
if !ok {
    value = computeValue()
    cache["key"] = value
}

// Or function
func getOrDefault(m map[string]int, key string, def int) int {
    if v, ok := m[key]; ok {
        return v
    }
    return def
}
```

## Performance Considerations

### Pre-allocate capacity
```go
// Bad - many allocations
m := make(map[string]int)
for i := 0; i < 1000; i++ {
    m[fmt.Sprint(i)] = i
}

// Good - size hint
m := make(map[string]int, 1000)
for i := 0; i < 1000; i++ {
    m[fmt.Sprint(i)] = i
}
```

### String keys
```go
// String keys are compared by value
// Large strings = slower lookups
// Consider using hash or ID instead
```

## Learning Path

### Basic Level
- Creating maps
- Adding/accessing/deleting elements
- Comma-ok idiom
- Iterating maps
- Map as set

### Intermediate Level
- Nil maps vs empty maps
- Reference semantics
- Nested maps
- Sorting map keys
- Common patterns

### Advanced Level
- Concurrent access (sync.Map)
- Performance optimization
- Custom key types
- Memory considerations
- Hash collision handling

## Key Differences from C/C++

1. **Built-in type** - No need to import
2. **Simpler syntax** - map[K]V
3. **Comma-ok idiom** - Safe access checking
4. **Random iteration order** - Cannot rely on order
5. **Reference type** - Assignment doesn't copy
6. **No sorting** - Must manually sort keys
7. **Not thread-safe** - Unlike some C++ implementations

## Common Pitfalls

1. **Nil map usage** - Must initialize with make or literal
2. **Assuming order** - Iteration is random
3. **Concurrent access** - Not thread-safe
4. **Forgetting comma-ok** - Zero value vs not present
5. **Nested map initialization** - Must create inner maps
6. **Reference semantics** - Assignment shares map

## Practice Context

Focus on:
- Map vs slice choice
- Using comma-ok idiom
- Understanding reference semantics
- Concurrent access patterns
- Performance optimization
- Converting C++ maps/sets to Go
