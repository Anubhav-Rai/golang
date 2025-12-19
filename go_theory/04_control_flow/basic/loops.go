package main

import "fmt"

func main() {
// Traditional for
for i := 0; i < 5; i++ {
fmt.Println(i)
}

// While equivalent
count := 0
for count < 3 {
fmt.Println("Count:", count)
count++
}

// Range over slice
nums := []int{1, 2, 3}
for i, v := range nums {
fmt.Println(i, v)
}
}
