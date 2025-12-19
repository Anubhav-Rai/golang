package main

import "fmt"

type Person struct {
Name string
Age  int
}

// Constructor
func NewPerson(name string, age int) *Person {
return &Person{Name: name, Age: age}
}

func main() {
p1 := Person{Name: "Alice", Age: 30}
fmt.Println(p1)

p2 := NewPerson("Bob", 25)
fmt.Println(p2)
}
