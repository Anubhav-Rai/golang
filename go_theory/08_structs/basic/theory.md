# Structs - Theory

## C++ vs Go

### C++ Class
```cpp
class Person {
private:
    string name;
    int age;
public:
    Person(string n, int a) : name(n), age(a) {}
    void greet();
};
```

### Go Struct
```go
type Person struct {
    name string  // lowercase = private
    Age  int     // Uppercase = public
}

// Constructor function
func NewPerson(name string, age int) *Person {
    return &Person{name: name, Age: age}
}
```

## Creating Structs
```go
// Literal
p := Person{name: "Alice", Age: 30}

// Pointer
p := &Person{name: "Bob", Age: 25}

// Zero value
var p Person  // name="", Age=0
```
