package main

import "fmt"

func main() {
// Create slice
s := []int{1, 2, 3}
fmt.Println(s)

// Append
s = append(s, 4, 5)
fmt.Println(s)

// Slicing
fmt.Println(s[1:3])  // [2 3]

// Make with capacity
s2 := make([]int, 0, 10)
fmt.Printf("len=%d cap=%d\n", len(s2), cap(s2))
}
