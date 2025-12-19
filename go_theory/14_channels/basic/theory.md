# Channels - Theory

## Creating Channels
```go
ch := make(chan int)        // Unbuffered
ch := make(chan int, 10)    // Buffered (capacity 10)
```

## Send and Receive
```go
ch <- value     // Send
value := <-ch   // Receive
value, ok := <-ch  // Receive with closed check
```

## Unbuffered vs Buffered
```go
// Unbuffered - blocks until received
ch := make(chan int)
ch <- 1  // Blocks until someone receives!

// Buffered - blocks when full
ch := make(chan int, 3)
ch <- 1  // OK
ch <- 2  // OK
ch <- 3  // OK
ch <- 4  // Blocks!
```

## Closing Channels
```go
close(ch)

// Check if closed
value, ok := <-ch
if !ok {
    // Channel closed
}

// Range over channel
for value := range ch {
    // Stops when closed
}
```
