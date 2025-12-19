# Select Statement - Theory

## Select (Like switch for channels)
```go
select {
case msg := <-ch1:
    fmt.Println("From ch1:", msg)
case msg := <-ch2:
    fmt.Println("From ch2:", msg)
case ch3 <- value:
    fmt.Println("Sent to ch3")
default:
    fmt.Println("No activity")
}
```

## Timeout Pattern
```go
select {
case result := <-ch:
    // Got result
case <-time.After(5 * time.Second):
    // Timeout
}
```

## Channel Directions
```go
// Send-only
func producer(ch chan<- int) {
    ch <- 42
}

// Receive-only
func consumer(ch <-chan int) {
    val := <-ch
}
```
