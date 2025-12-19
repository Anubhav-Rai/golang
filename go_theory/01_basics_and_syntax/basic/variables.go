// Basic variables example
package main

import "fmt"

func main() {
// Short declaration (most common)
name := "Gopher"
age := 10

// Explicit type
var country string = "Go Land"

// Multiple declarations
x, y := 10, 20

fmt.Println(name, age, country)
fmt.Println("Sum:", x+y)
}
