# Go Reflection - Learning Context

## Topic Overview
Reflection in Go (reflect package) allows runtime inspection and manipulation of types. Similar to C++ RTTI but more powerful. Use sparingly - prefer interfaces.

## Reflection vs C++ RTTI

**C++ (Limited):**
```cpp
#include <typeinfo>

class Base { virtual ~Base() {} };
class Derived : public Base {};

Base* b = new Derived();
if (typeid(*b) == typeid(Derived)) {
    // is Derived
}

// dynamic_cast
Derived* d = dynamic_cast<Derived*>(b);
```

**Go (Powerful):**
```go
import "reflect"

var x interface{} = 42

t := reflect.TypeOf(x)      // type information
v := reflect.ValueOf(x)     // value information

fmt.Println(t.Kind())       // int
fmt.Println(v.Int())        // 42
```

## Type and Value

**Two main types:**
```go
// reflect.Type - type information
t := reflect.TypeOf(x)

// reflect.Value - value + type
v := reflect.ValueOf(x)

// Get Type from Value
t = v.Type()

// Get interface{} from Value
i := v.Interface()  // converts back
```

## Inspecting Types

```go
type Person struct {
    Name string
    Age  int
}

p := Person{"Alice", 25}
t := reflect.TypeOf(p)

fmt.Println(t.Name())       // Person
fmt.Println(t.Kind())       // struct
fmt.Println(t.NumField())   // 2

// Iterate fields
for i := 0; i < t.NumField(); i++ {
    field := t.Field(i)
    fmt.Printf("%s: %s\n", field.Name, field.Type)
}
```

## Kind vs Type

```go
type MyInt int

x := MyInt(42)
t := reflect.TypeOf(x)

fmt.Println(t.Name())  // MyInt (type name)
fmt.Println(t.Kind())  // int (underlying kind)

// Kinds: Bool, Int, Int8, Int16, Int32, Int64,
//        Uint, Uint8, ..., Float32, Float64,
//        Complex64, Complex128, Array, Chan,
//        Func, Interface, Map, Ptr, Slice,
//        String, Struct, UnsafePointer
```

## Inspecting Values

```go
v := reflect.ValueOf(42)

fmt.Println(v.Kind())      // int
fmt.Println(v.Int())       // 42
fmt.Println(v.Type())      // int

// Type-specific methods
// v.Int(), v.Uint(), v.Float(), v.Bool(),
// v.String(), v.Complex(), v.Bytes()
```

## Modifying Values

**Need pointer to modify:**
```go
x := 42
v := reflect.ValueOf(x)
// v.SetInt(100)  // panic! not addressable

// Use pointer
v = reflect.ValueOf(&x).Elem()
if v.CanSet() {
    v.SetInt(100)  // OK
}
fmt.Println(x)  // 100
```

## Struct Field Access

**Reading fields:**
```go
type Person struct {
    Name string
    age  int  // unexported
}

p := Person{"Alice", 25}
v := reflect.ValueOf(p)

// By index
name := v.Field(0).String()  // "Alice"

// By name
nameField := v.FieldByName("Name")
fmt.Println(nameField.String())

// Unexported fields readable but not settable
age := v.Field(1).Int()  // OK (read)
// v.Field(1).SetInt(30)  // panic! unexported
```

**Modifying fields:**
```go
p := Person{"Alice", 25}
v := reflect.ValueOf(&p).Elem()

nameField := v.FieldByName("Name")
if nameField.CanSet() {
    nameField.SetString("Bob")
}
fmt.Println(p.Name)  // Bob
```

## Struct Tags

**Reading tags:**
```go
type User struct {
    Name  string `json:"name" validate:"required"`
    Email string `json:"email" validate:"email"`
}

t := reflect.TypeOf(User{})
field, _ := t.FieldByName("Name")

fmt.Println(field.Tag.Get("json"))      // "name"
fmt.Println(field.Tag.Get("validate"))  // "required"
fmt.Println(field.Tag.Lookup("json"))   // "name", true

// Iterate all fields with tags
for i := 0; i < t.NumField(); i++ {
    field := t.Field(i)
    fmt.Printf("%s: json=%s\n", 
        field.Name, 
        field.Tag.Get("json"))
}
```

## Function Calls

**Invoke functions dynamically:**
```go
func Add(a, b int) int {
    return a + b
}

// Get function value
f := reflect.ValueOf(Add)

// Prepare arguments
args := []reflect.Value{
    reflect.ValueOf(2),
    reflect.ValueOf(3),
}

// Call function
results := f.Call(args)

// Extract result
sum := results[0].Int()  // 5
```

**Method calls:**
```go
type Calculator struct{}

func (c Calculator) Add(a, b int) int {
    return a + b
}

calc := Calculator{}
v := reflect.ValueOf(calc)

// Get method
method := v.MethodByName("Add")

// Call
args := []reflect.Value{
    reflect.ValueOf(10),
    reflect.ValueOf(20),
}
results := method.Call(args)
fmt.Println(results[0].Int())  // 30
```

## Creating New Values

```go
// New instance of type
t := reflect.TypeOf(Person{})
v := reflect.New(t)  // returns *Person as reflect.Value

// Convert to actual type
ptr := v.Interface().(*Person)
ptr.Name = "Alice"

// Make slice
sliceType := reflect.SliceOf(reflect.TypeOf(0))
slice := reflect.MakeSlice(sliceType, 0, 10)

// Make map
mapType := reflect.MapOf(
    reflect.TypeOf(""),
    reflect.TypeOf(0),
)
m := reflect.MakeMap(mapType)

// Make channel
chanType := reflect.ChanOf(reflect.BothDir, reflect.TypeOf(0))
ch := reflect.MakeChan(chanType, 0)
```

## Deep Equal

**Compare complex structures:**
```go
import "reflect"

m1 := map[string]int{"a": 1, "b": 2}
m2 := map[string]int{"a": 1, "b": 2}

// m1 == m2  // ERROR! Can't compare maps

// Use reflect
if reflect.DeepEqual(m1, m2) {
    fmt.Println("Equal")
}

// Works for slices, maps, structs, etc.
s1 := []int{1, 2, 3}
s2 := []int{1, 2, 3}
reflect.DeepEqual(s1, s2)  // true
```

## Type Switches vs Reflection

**Prefer type switch:**
```go
// Type switch (preferred)
switch v := x.(type) {
case int:
    fmt.Println("int:", v)
case string:
    fmt.Println("string:", v)
}

// Reflection (when type switch not possible)
v := reflect.ValueOf(x)
switch v.Kind() {
case reflect.Int:
    fmt.Println("int:", v.Int())
case reflect.String:
    fmt.Println("string:", v.String())
}
```

## Common Use Cases

### JSON Encoding/Decoding
```go
// encoding/json uses reflection
type User struct {
    Name string `json:"name"`
    Age  int    `json:"age"`
}

user := User{"Alice", 25}
data, _ := json.Marshal(user)  // uses reflection

var user2 User
json.Unmarshal(data, &user2)  // uses reflection
```

### ORM (Database)
```go
// Scan database row into struct
type User struct {
    ID   int
    Name string
}

var user User
row := db.QueryRow("SELECT id, name FROM users WHERE id = ?", 1)

// ORM uses reflection to populate struct
v := reflect.ValueOf(&user).Elem()
// ... scan and set fields
```

### Generic Functions (Pre-Generics)
```go
func PrintSlice(s interface{}) {
    v := reflect.ValueOf(s)
    if v.Kind() != reflect.Slice {
        return
    }
    
    for i := 0; i < v.Len(); i++ {
        fmt.Println(v.Index(i))
    }
}

PrintSlice([]int{1, 2, 3})
PrintSlice([]string{"a", "b", "c"})
```

## Performance Considerations

**Reflection is slow:**
```go
// Direct access (fast)
x := 42
y := x + 1

// Reflection (slow)
v := reflect.ValueOf(x)
y := v.Int() + 1

// Benchmark shows 100x+ slower
```

**When to use:**
- Serialization/deserialization
- ORMs
- Generic algorithms (before Go 1.18 generics)
- Framework code
- Testing utilities

**When NOT to use:**
- Performance-critical paths
- When interfaces work
- Simple type assertions sufficient

## Limitations and Caveats

```go
// Can't access unexported fields
type Private struct {
    secret string  // can read but not set
}

// Can't call unexported methods
// Can't create instances of unexported types from other packages
// Performance overhead
// Loss of type safety
// Harder to read and maintain
```

## Learning Path

### Basic Level
- TypeOf and ValueOf
- Kind vs Type
- Reading struct fields
- Reading struct tags
- DeepEqual

### Intermediate Level
- Modifying values
- Function calls
- Creating new values
- Method invocation
- Complex type inspection

### Advanced Level
- Performance optimization
- Building frameworks
- Code generation
- Advanced type manipulation
- Unsafe operations

## Key Differences from C++

1. **More powerful** - Full type system access
2. **Runtime cost** - Performance penalty
3. **Type safe** - Panics on misuse
4. **Struct tags** - Metadata support
5. **No templates** - Reflection for generic code (pre-1.18)
6. **GC aware** - No manual memory management

## Best Practices

1. **Avoid if possible** - Use interfaces instead
2. **Check CanSet()** - Before modifying
3. **Handle panics** - Reflection can panic
4. **Cache reflect.Type** - Don't recreate
5. **Document usage** - Explain why needed
6. **Consider generics** - Go 1.18+ alternative
7. **Profile performance** - Understand cost

## Common Patterns

### Generic Print
```go
func Print(v interface{}) {
    val := reflect.ValueOf(v)
    printValue(val, 0)
}

func printValue(v reflect.Value, indent int) {
    switch v.Kind() {
    case reflect.Struct:
        for i := 0; i < v.NumField(); i++ {
            fmt.Printf("%s: ", v.Type().Field(i).Name)
            printValue(v.Field(i), indent+1)
        }
    case reflect.Slice, reflect.Array:
        for i := 0; i < v.Len(); i++ {
            printValue(v.Index(i), indent)
        }
    default:
        fmt.Println(v.Interface())
    }
}
```

### Validation
```go
func Validate(s interface{}) error {
    v := reflect.ValueOf(s)
    t := v.Type()
    
    for i := 0; i < t.NumField(); i++ {
        field := t.Field(i)
        if tag := field.Tag.Get("validate"); tag == "required" {
            if v.Field(i).IsZero() {
                return fmt.Errorf("%s is required", field.Name)
            }
        }
    }
    return nil
}
```

## Common Pitfalls

1. **Not checking CanSet()** - Panics
2. **Forgetting Elem()** - For pointers
3. **Performance ignorance** - Too slow
4. **Overuse** - When interfaces work
5. **Type assertion on Interface()** - Need correct type
6. **Not handling panics** - Crashes
7. **Accessing unexported fields** - Panics when setting

## Practice Context

Focus on:
- Understanding when to use reflection
- Reading struct tags
- Safe value modification
- Performance implications
- DeepEqual for testing
- Building simple generic functions
- Converting C++ RTTI to Go reflection
