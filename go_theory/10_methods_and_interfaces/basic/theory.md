# Interfaces - Theory

## C++ vs Go

### C++ (Explicit)
```cpp
class Shape {
public:
    virtual double Area() = 0;
};

class Circle : public Shape {
    double Area() override { }
};
```

### Go (Implicit!)
```go
type Shape interface {
    Area() float64
}

type Circle struct {
    Radius float64
}

// Implements Shape automatically!
func (c Circle) Area() float64 {
    return 3.14 * c.Radius * c.Radius
}
```

## Methods
```go
type Person struct {
    Name string
}

// Value receiver
func (p Person) Greet() {
    fmt.Println("Hi", p.Name)
}

// Pointer receiver (can modify)
func (p *Person) SetName(name string) {
    p.Name = name
}
```
