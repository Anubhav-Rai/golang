package main

import "fmt"

func main() {
// Zero values
var i int
var f float64
var b bool
var s string
fmt.Println(i, f, b, s) // 0 0 false ""

// Short declaration
name := "Go"
age := 14
pi := 3.14

fmt.Println(name, age, pi)
}
