package main

import (
	"encoding/json"
	"fmt"
)

// Person struct defines a person with a Name and Age
type Person struct {
	Name string
	Age  int
}

func main() {
	// Create a Person instance
	p := Person{Name: "Alice", Age: 30}

	// Convert the Person instance to JSON
	jsonData, err := json.Marshal(p)
	if err != nil {
		fmt.Println("Error marshaling JSON:", err)
		return
	}

	fmt.Println(string(jsonData))
}

