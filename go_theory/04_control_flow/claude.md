# Go Control Flow - Learning Context

## Topic Overview
Control flow in Go is cleaner than C/C++ - no parentheses required, but braces are mandatory.

## If Statement

**C/C++:**
```cpp
if (x > 10) {
    // code
}

if (x > 10)
    single_statement();  // dangerous!
```

**Go - No Parentheses, Braces Required:**
```go
if x > 10 {
    // code
}

// ERROR - braces required even for single statement
// if x > 10
//     statement()

// UNIQUE: initialization in if
if y := compute(); y > 10 {
    // y is scoped to if/else block
    fmt.Println(y)
}
// y is not accessible here
```

## For Loop - The ONLY Loop!

**C/C++ has multiple loops:**
```cpp
for (int i = 0; i < 10; i++) { }  // for
while (condition) { }              // while
do { } while (condition);          // do-while
```

**Go - Only 'for' (but versatile):**
```go
// Traditional for loop
for i := 0; i < 10; i++ {
    // code
}

// While-style (no 'while' keyword!)
for condition {
    // like while in C++
}

// Infinite loop (no 'while(true)')
for {
    // infinite
    break  // to exit
}

// Range-based iteration (like C++11 range-for)
arr := []int{1, 2, 3, 4, 5}
for i, v := range arr {
    // i is index, v is value
}

// Just values
for _, v := range arr {
    // _ ignores index
}

// Just indices
for i := range arr {
    // just index
}
```

## Switch Statement - Much Better!

**C/C++:**
```cpp
switch (x) {
    case 1:
        // code
        break;  // MUST remember break!
    case 2:
        // code
        break;
    default:
        // code
}
```

**Go - No Break Needed, No Fall-through:**
```go
switch x {
case 1:
    // code
    // automatic break!
case 2:
    // code
default:
    // code
}

// Multiple values in case
switch x {
case 1, 2, 3:
    fmt.Println("1, 2, or 3")
case 4, 5:
    fmt.Println("4 or 5")
}

// Switch with initialization
switch y := compute(); y {
case 1:
    // y accessible here
default:
    // and here
}

// Switch without expression (like if-else chain)
switch {
case x > 0:
    fmt.Println("positive")
case x < 0:
    fmt.Println("negative")
default:
    fmt.Println("zero")
}

// Explicit fall-through (rarely needed)
switch x {
case 1:
    fmt.Println("one")
    fallthrough  // explicitly continue to next case
case 2:
    fmt.Println("one or two")
}
```

## Defer Statement - Unique to Go!

**C++:** Use RAII, destructors
```cpp
void function() {
    File* f = open("file.txt");
    // do work
    f->close();  // must remember!
}

// Better C++ with RAII
void function() {
    std::ifstream f("file.txt");
    // do work
    // automatically closed
}
```

**Go - Defer:**
```go
func function() {
    f, err := os.Open("file.txt")
    if err != nil {
        return
    }
    defer f.Close()  // Will run when function exits
    
    // do work
    // multiple returns? no problem!
    // panic? defer still runs!
}

// Multiple defers - LIFO order
func example() {
    defer fmt.Println("1")
    defer fmt.Println("2")
    defer fmt.Println("3")
    // Output: 3, 2, 1
}
```

## Goto - Exists but Discouraged

**Both C/C++ and Go have goto:**
```go
func example() {
    goto label
    fmt.Println("skipped")
label:
    fmt.Println("jumped here")
}

// More common use: break nested loops
func search() {
outer:
    for i := 0; i < 10; i++ {
        for j := 0; j < 10; j++ {
            if found(i, j) {
                break outer  // breaks outer loop
            }
        }
    }
}
```

## Break and Continue

**Same as C/C++, plus labels:**
```go
// Basic break/continue
for i := 0; i < 10; i++ {
    if i == 5 {
        continue
    }
    if i == 8 {
        break
    }
}

// Labeled break/continue
outer:
for i := 0; i < 5; i++ {
    for j := 0; j < 5; j++ {
        if j == 3 {
            continue outer  // continues outer loop
        }
        if j == 4 {
            break outer     // breaks outer loop
        }
    }
}
```

## Select Statement - For Channels (Unique!)

**No equivalent in C++:**
```go
// Like switch but for channel operations
select {
case msg := <-ch1:
    fmt.Println("Received from ch1:", msg)
case msg := <-ch2:
    fmt.Println("Received from ch2:", msg)
case ch3 <- value:
    fmt.Println("Sent to ch3")
default:
    fmt.Println("No communication")
}
```

## Common Patterns

### Early Return Pattern
```go
func validate(x int) error {
    if x < 0 {
        return errors.New("negative")
    }
    if x > 100 {
        return errors.New("too large")
    }
    // happy path at lowest indent
    return nil
}
```

### Guard Clauses
```go
func process(data []int) {
    if len(data) == 0 {
        return  // guard clause
    }
    if data[0] < 0 {
        return  // guard clause
    }
    // main logic here
}
```

## Learning Path

### Basic Level
- if/else statements
- for loops (all forms)
- switch statements
- break and continue
- Basic defer usage

### Intermediate Level
- Initialization in if/switch
- Range with multiple return values
- Labeled break/continue
- Defer execution order
- Switch without expression
- Type switches

### Advanced Level
- Select statement for concurrency
- Complex defer scenarios
- Performance implications
- Goto for error handling
- Compiler optimizations

## Key Differences from C/C++

1. **No parentheses** around conditions
2. **Braces always required** - no single-statement shortcuts
3. **No while/do-while** - just 'for'
4. **Switch doesn't fall through** - explicit fallthrough keyword
5. **Defer statement** - simpler than RAII
6. **Range iteration** - cleaner than iterators
7. **Select for channels** - unique to Go
8. **Init statement** in if/switch

## Common Pitfalls

1. **Forgotten braces** - Won't compile
2. **Trying to use parentheses** - Not needed
3. **Expecting fall-through** in switch
4. **Shadowing variables** in init statements
5. **Range loop gotchas** - value is copy, not reference

## Practice Context

Focus on:
- Converting C++ loops to Go
- Using defer for cleanup
- Understanding range iteration
- Switch without fall-through
- Early return patterns
