package main

import "fmt"

func main() {
// Create map
m := make(map[string]int)
m["age"] = 25
m["year"] = 2024

// Access
fmt.Println(m["age"])

// Check existence
if val, ok := m["age"]; ok {
fmt.Println("Found:", val)
}

// Delete
delete(m, "year")

// Iterate
for k, v := range m {
fmt.Println(k, v)
}
}
