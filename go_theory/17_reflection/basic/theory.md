# Reflection - Theory

## Basic Reflection
```go
import "reflect"

var x float64 = 3.4

t := reflect.TypeOf(x)
fmt.Println(t)  // float64

v := reflect.ValueOf(x)
fmt.Println(v)  // 3.4
```

## Struct Tags
```go
type User struct {
    Name string `json:"name" db:"user_name"`
    Age  int    `json:"age"`
}

t := reflect.TypeOf(User{})
field, _ := t.FieldByName("Name")
tag := field.Tag.Get("json")  // "name"
```

## Type Assertions
```go
var i interface{} = "hello"

s := i.(string)        // Panic if wrong type
s, ok := i.(string)    // Safe
```
