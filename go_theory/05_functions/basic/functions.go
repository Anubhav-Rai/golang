package main

import "fmt"

// Basic function
func add(a, b int) int {
return a + b
}

// Multiple returns
func swap(x, y string) (string, string) {
return y, x
}

// Named returns
func split(sum int) (x, y int) {
x = sum * 4 / 9
y = sum - x
return
}

func main() {
fmt.Println(add(3, 5))

a, b := swap("hello", "world")
fmt.Println(a, b)

x, y := split(17)
fmt.Println(x, y)
}
