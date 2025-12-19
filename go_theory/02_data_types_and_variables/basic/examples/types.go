package main

import "fmt"

func main() {
    // Integer types
    var i8 int8 = 127
    var i16 int16 = 32767
    var i32 int32 = 2147483647
    var i64 int64 = 9223372036854775807
    
    fmt.Printf("int8:  %d\n", i8)
    fmt.Printf("int16: %d\n", i16)
    fmt.Printf("int32: %d\n", i32)
    fmt.Printf("int64: %d\n", i64)
    
    // Zero values
    var zeroInt int
    var zeroFloat float64
    var zeroString string
    var zeroBool bool
    
    fmt.Printf("\nZero values:\n")
    fmt.Printf("int:     %d\n", zeroInt)
    fmt.Printf("float64: %f\n", zeroFloat)
    fmt.Printf("string:  '%s'\n", zeroString)
    fmt.Printf("bool:    %t\n", zeroBool)
    
    // Type inference
    x := 42
    y := 3.14
    s := "hello"
    
    fmt.Printf("\nInferred types:\n")
    fmt.Printf("x: %T\n", x)
    fmt.Printf("y: %T\n", y)
    fmt.Printf("s: %T\n", s)
}
