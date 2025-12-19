# Go Generics - Learning Context

## Topic Overview
Generics (Go 1.18+) bring type parameters to Go, similar to C++ templates but simpler and with constraints.

## Generics vs C++ Templates

**C++ Templates:**
```cpp
template<typename T>
T max(T a, T b) {
    return a > b ? a : b;
}

int x = max(1, 2);
double y = max(1.5, 2.5);
```

**Go Generics:**
```go
func Max[T comparable](a, b T) T {
    if a > b {
        return a
    }
    return b
}

x := Max(1, 2)
y := Max(1.5, 2.5)
```

## Basic Syntax

**Type parameter:**
```go
// [T any] means T can be any type
func Print[T any](s []T) {
    for _, v := range s {
        fmt.Println(v)
    }
}

// Usage
Print([]int{1, 2, 3})
Print([]string{"a", "b", "c"})

// Type inference
Print([]int{1, 2, 3})  // T inferred as int
```

## Type Constraints

**any (interface{}) - no constraints:**
```go
func Identity[T any](x T) T {
    return x
}
```

**comparable - can use == and !=:**
```go
func Contains[T comparable](slice []T, elem T) bool {
    for _, v := range slice {
        if v == elem {
            return true
        }
    }
    return false
}
```

**Custom constraints:**
```go
type Number interface {
    int | int64 | float64
}

func Sum[T Number](numbers []T) T {
    var sum T
    for _, n := range numbers {
        sum += n
    }
    return sum
}
```

## Built-in Constraints

**constraints package (golang.org/x/exp/constraints):**
```go
import "golang.org/x/exp/constraints"

// Ordered: types that support <, <=, >, >=
func Min[T constraints.Ordered](a, b T) T {
    if a < b {
        return a
    }
    return b
}

// Signed: signed integers
// Unsigned: unsigned integers
// Integer: all integers
// Float: all floats
// Complex: complex numbers
```

## Generic Types

**Generic structs:**
```go
type Stack[T any] struct {
    items []T
}

func (s *Stack[T]) Push(item T) {
    s.items = append(s.items, item)
}

func (s *Stack[T]) Pop() (T, bool) {
    if len(s.items) == 0 {
        var zero T
        return zero, false
    }
    item := s.items[len(s.items)-1]
    s.items = s.items[:len(s.items)-1]
    return item, true
}

// Usage
intStack := Stack[int]{}
intStack.Push(1)
intStack.Push(2)

stringStack := Stack[string]{}
stringStack.Push("hello")
```

## Multiple Type Parameters

```go
type Pair[T, U any] struct {
    First  T
    Second U
}

func MakePair[T, U any](first T, second U) Pair[T, U] {
    return Pair[T, U]{first, second}
}

// Usage
p := MakePair(1, "one")  // Pair[int, string]
fmt.Println(p.First, p.Second)
```

## Type Constraints with Methods

**Interface as constraint:**
```go
type Stringer interface {
    String() string
}

func PrintStrings[T Stringer](items []T) {
    for _, item := range items {
        fmt.Println(item.String())
    }
}
```

**Union constraints:**
```go
type Numeric interface {
    int | int64 | float32 | float64
}

func Add[T Numeric](a, b T) T {
    return a + b
}
```

**Approximation constraint (~):**
```go
type MyInt int

type Integer interface {
    ~int | ~int64  // ~ means "underlying type"
}

func Double[T Integer](x T) T {
    return x * 2
}

// Works with custom types
var x MyInt = 5
result := Double(x)  // OK because MyInt has underlying type int
```

## Generic Functions

### Map
```go
func Map[T, U any](slice []T, f func(T) U) []U {
    result := make([]U, len(slice))
    for i, v := range slice {
        result[i] = f(v)
    }
    return result
}

// Usage
numbers := []int{1, 2, 3}
doubled := Map(numbers, func(x int) int { return x * 2 })
strings := Map(numbers, func(x int) string { return fmt.Sprint(x) })
```

### Filter
```go
func Filter[T any](slice []T, predicate func(T) bool) []T {
    result := []T{}
    for _, v := range slice {
        if predicate(v) {
            result = append(result, v)
        }
    }
    return result
}

// Usage
numbers := []int{1, 2, 3, 4, 5}
evens := Filter(numbers, func(x int) bool { return x%2 == 0 })
```

### Reduce
```go
func Reduce[T, U any](slice []T, initial U, f func(U, T) U) U {
    result := initial
    for _, v := range slice {
        result = f(result, v)
    }
    return result
}

// Usage
numbers := []int{1, 2, 3, 4, 5}
sum := Reduce(numbers, 0, func(acc, x int) int { return acc + x })
```

## Generic Data Structures

### Linked List
```go
type Node[T any] struct {
    Value T
    Next  *Node[T]
}

type LinkedList[T any] struct {
    Head *Node[T]
}

func (l *LinkedList[T]) Add(value T) {
    node := &Node[T]{Value: value, Next: l.Head}
    l.Head = node
}

func (l *LinkedList[T]) Find(predicate func(T) bool) *T {
    for node := l.Head; node != nil; node = node.Next {
        if predicate(node.Value) {
            return &node.Value
        }
    }
    return nil
}
```

### Binary Tree
```go
type Tree[T any] struct {
    Value T
    Left  *Tree[T]
    Right *Tree[T]
}

func (t *Tree[T]) Insert(value T, compare func(T, T) bool) {
    if t == nil {
        return
    }
    if compare(value, t.Value) {
        if t.Left == nil {
            t.Left = &Tree[T]{Value: value}
        } else {
            t.Left.Insert(value, compare)
        }
    } else {
        if t.Right == nil {
            t.Right = &Tree[T]{Value: value}
        } else {
            t.Right.Insert(value, compare)
        }
    }
}
```

### Generic Map Type
```go
type SafeMap[K comparable, V any] struct {
    mu   sync.RWMutex
    data map[K]V
}

func NewSafeMap[K comparable, V any]() *SafeMap[K, V] {
    return &SafeMap[K, V]{
        data: make(map[K]V),
    }
}

func (m *SafeMap[K, V]) Set(key K, value V) {
    m.mu.Lock()
    defer m.mu.Unlock()
    m.data[key] = value
}

func (m *SafeMap[K, V]) Get(key K) (V, bool) {
    m.mu.RLock()
    defer m.mu.RUnlock()
    val, ok := m.data[key]
    return val, ok
}
```

## Type Inference

**Go can infer types:**
```go
func Print[T any](x T) {
    fmt.Println(x)
}

// Explicit type
Print[int](42)

// Type inference (preferred)
Print(42)  // T inferred as int
```

**Partial inference:**
```go
func Convert[T, U any](x T, converter func(T) U) U {
    return converter(x)
}

// Must specify U, T inferred
result := Convert[int, string](42, func(x int) string {
    return fmt.Sprint(x)
})
```

## Constraints with Type Sets

**Type set definition:**
```go
type SignedInteger interface {
    ~int | ~int8 | ~int16 | ~int32 | ~int64
}

type UnsignedInteger interface {
    ~uint | ~uint8 | ~uint16 | ~uint32 | ~uint64
}

type Integer interface {
    SignedInteger | UnsignedInteger
}
```

## Generic Methods

**Methods on generic types:**
```go
type Option[T any] struct {
    value   T
    present bool
}

func Some[T any](value T) Option[T] {
    return Option[T]{value: value, present: true}
}

func None[T any]() Option[T] {
    return Option[T]{present: false}
}

func (o Option[T]) IsSome() bool {
    return o.present
}

func (o Option[T]) Unwrap() T {
    if !o.present {
        panic("called Unwrap on None")
    }
    return o.value
}

func (o Option[T]) UnwrapOr(def T) T {
    if o.present {
        return o.value
    }
    return def
}
```

## Limitations

**What you CAN'T do:**
```go
// No generic methods on non-generic types
type MyType struct{}

// ERROR: methods cannot have type parameters
// func (m MyType) Generic[T any]() {}

// No type parameters on methods (only on receiver type)
type Container[T any] struct{}

// OK - type parameter on receiver
func (c Container[T]) Get() T { ... }

// ERROR - additional type parameter
// func (c Container[T]) Convert[U any]() U { ... }

// No operator overloading
type Number[T any] struct {
    value T
}

// Can't do: n1 + n2
// Must use method: n1.Add(n2)
```

## Comparing to C++

**C++ Templates:**
- Compile-time code generation
- Duck typing (no explicit constraints)
- Complex error messages
- Template specialization
- SFINAE

**Go Generics:**
- Simpler constraints system
- Clear error messages
- No specialization
- Type checking at definition
- Runtime overhead (small)

## Performance

**Generics have minimal overhead:**
```go
// GCShape stenciling (not full monomorphization)
// Similar performance to interface{} but type-safe
// Some cases: dictionary passing
```

## Real-World Examples

### Result Type
```go
type Result[T any] struct {
    value T
    err   error
}

func Ok[T any](value T) Result[T] {
    return Result[T]{value: value}
}

func Err[T any](err error) Result[T] {
    return Result[T]{err: err}
}

func (r Result[T]) IsOk() bool {
    return r.err == nil
}

func (r Result[T]) Unwrap() (T, error) {
    return r.value, r.err
}
```

### Set Implementation
```go
type Set[T comparable] struct {
    items map[T]struct{}
}

func NewSet[T comparable]() *Set[T] {
    return &Set[T]{items: make(map[T]struct{})}
}

func (s *Set[T]) Add(item T) {
    s.items[item] = struct{}{}
}

func (s *Set[T]) Contains(item T) bool {
    _, ok := s.items[item]
    return ok
}

func (s *Set[T]) Remove(item T) {
    delete(s.items, item)
}
```

## Learning Path

### Basic Level
- Type parameters [T any]
- Generic functions
- Built-in constraints (any, comparable)
- Type inference
- Generic slices and maps

### Intermediate Level
- Custom constraints
- Union types
- Approximation (~)
- Generic structs
- Multiple type parameters

### Advanced Level
- Complex constraints
- Type sets
- Performance implications
- Design patterns with generics
- Migration from interface{}

## Best Practices

1. **Use constraints** - Be specific when possible
2. **Prefer comparable** - Over custom equality
3. **Keep it simple** - Don't over-genericize
4. **Use type inference** - Cleaner code
5. **Document constraints** - Explain why
6. **Consider interfaces** - Sometimes better than generics
7. **Profile performance** - Understand cost

## Common Pitfalls

1. **Over-generalization** - Not everything needs generics
2. **Constraint too broad** - Use specific constraints
3. **Forgetting ~** - For custom types with same underlying type
4. **Complex constraints** - Keep them readable
5. **No method type parameters** - Design around this
6. **Performance assumptions** - Profile first

## When to Use Generics

**Good uses:**
- Collection types (List, Set, Stack, Queue)
- Algorithms (Sort, Filter, Map, Reduce)
- Option/Result types
- Generic utilities
- Type-safe containers

**When to use interfaces instead:**
- Polymorphism needed
- Method-based behavior
- Dynamic dispatch required
- Simpler code

## Practice Context

Focus on:
- Writing generic functions
- Creating generic data structures
- Understanding constraints
- Type inference
- Converting interface{} code to generics
- Performance considerations
- Comparing to C++ templates
