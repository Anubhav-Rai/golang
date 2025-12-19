# Control Flow - Theory with Design Rationale

## The `for` Loop: Go's ONLY Loop

### C++ Has Three Loop Types

```cpp
// for loop
for (int i = 0; i < 10; i++) {
    cout << i;
}

// while loop
while (condition) {
    // ...
}

// do-while loop
do {
    // ...
} while (condition);
```

### Go Has ONE: `for`

```go
// Traditional for
for i := 0; i < 10; i++ {
    fmt.Println(i)
}

// While equivalent  
for condition {
    // ...
}

// Infinite loop
for {
    // ...
}

// Range loop
for i, v := range slice {
    fmt.Println(i, v)
}
```

### Design Rationale: WHY Only `for`?

**The Problem with Multiple Loop Types:**

1. **Unnecessary Complexity:**
   ```cpp
   // C++ - Three ways to do the same thing
   for (int i = 0; i < 10; i++) { }
   
   int i = 0;
   while (i < 10) { i++; }
   
   int i = 0;
   do { i++; } while (i < 10);
   
   // All do similar things, which to use?
   ```

2. **Style Debates:**
   - "Should we use `while` or `for`?"
   - "When to use `do-while`?"
   - Code reviews focus on style, not logic

3. **`do-while` is Rarely Needed:**
   ```cpp
   // C++ do-while - how often do you write this?
   do {
       input = readInput();
   } while (!input.isValid());
   
   // More common pattern:
   input = readInput();
   while (!input.isValid()) {
       input = readInput();
   }
   ```

**Go's Solution: One Flexible `for`**

```go
// Traditional three-part for
for init; condition; post {
}

// While (just condition)
for condition {
}

// Infinite
for {
}

// Range (iteration)
for key, value := range collection {
}
```

**Why This Works:**

1. **All Needs Covered:**
   ```go
   // Counter loop
   for i := 0; i < 10; i++ {
   }
   
   // Condition loop
   for !done {
   }
   
   // Infinite with break
   for {
       if shouldStop {
           break
       }
   }
   
   // Collection iteration
   for _, item := range items {
   }
   ```

2. **No `do-while`?**
   ```go
   // Instead of do-while, use:
   for {
       doSomething()
       if !condition {
           break
       }
   }
   
   // Or simply:
   doSomething()
   for condition {
       doSomething()
   }
   ```

3. **Simplicity:**
   - One keyword to remember
   - One concept to learn
   - Less cognitive load

**Historical Context:**

Go designers asked: "Do we really need three loop keywords?"
- Answer: No
- `for` can do everything
- Simpler language, same power

**Trade-offs:**
- ✅ **Pro**: Simpler language (one keyword)
- ✅ **Pro**: No debates about which loop to use
- ❌ **Con**: No explicit `do-while` (but rare anyway)
- ✅ **Pro**: Consistent syntax

---

## `if` Statement

### No Parentheses

**C++:**
```cpp
if (x > 10) {
    cout << "big";
}
```

**Go:**
```go
if x > 10 {
    fmt.Println("big")
}
```

### Initialization in `if`

**C++ (C++17):**
```cpp
if (auto result = calculate(); result > 0) {
    use(result);
}
// result out of scope here
```

**Go (Always Supported):**
```go
if result := calculate(); result > 0 {
    use(result)
}
// result out of scope here
```

### Design Rationale: WHY Initialization in `if`?

**Common Pattern:**

```go
// Check error and handle
if err := doSomething(); err != nil {
    return err
}

// Check map value
if value, ok := myMap[key]; ok {
    use(value)
}

// Check type assertion
if conn, ok := netConn.(*TCPConn); ok {
    conn.SetKeepAlive(true)
}
```

**Without Initialization Statement:**

```go
// Would have to write:
value, ok := myMap[key]
if ok {
    use(value)
}
// value still in scope! (accidental use?)

// With initialization:
if value, ok := myMap[key]; ok {
    use(value)
}
// value out of scope (safer)
```

**Benefits:**

1. **Scope Limitation:**
   - Variable only exists in if/else
   - Can't accidentally use it later
   - Cleaner code

2. **Common Go Idiom:**
   ```go
   // Error checking (very common)
   if err := file.Write(data); err != nil {
       return err
   }
   
   // Much cleaner than:
   err := file.Write(data)
   if err != nil {
       return err
   }
   ```

3. **Reduces Variable Pollution:**
   - Temporary variables don't leak
   - Namespace stays clean

**Why C++ Added This Later:**

C++17 added this feature after seeing it work well in Go!
- Shows good language design spreads
- C++ acknowledged Go's pattern was useful

---

## `switch` Statement

### C++ Switch (With Fallthrough)

```cpp
switch (day) {
case 1:
case 2:
case 3:
case 4:
case 5:
    cout << "Weekday";
    break;              // Must use break!
case 6:
case 7:
    cout << "Weekend";
    break;
default:
    cout << "Invalid";
}

// Forgotten break = Bug!
switch (x) {
case 1:
    doOne();
    // FALL THROUGH (bug!)
case 2:
    doTwo();
}
```

### Go Switch (No Fallthrough by Default!)

```go
switch day {
case 1, 2, 3, 4, 5:     // Multiple values in one case
    fmt.Println("Weekday")
    // Automatic break!
case 6, 7:
    fmt.Println("Weekend")
default:
    fmt.Println("Invalid")
}

// Explicit fallthrough if needed
switch x {
case 1:
    doOne()
    fallthrough         // Explicit keyword
case 2:
    doTwo()
}
```

### Design Rationale: WHY No Automatic Fallthrough?

**The C++ Fallthrough Problem:**

1. **Most Common Bug:**
   ```cpp
   // Famous bug pattern in C++
   switch (status) {
   case CONNECTED:
       sendData();
       // Forgot break! Falls through!
   case DISCONNECTED:
       closeConnection();  // BUG: Runs even when connected!
   }
   ```

2. **Accidental Fallthrough is Common:**
   - Surveys show 90%+ of fallthrough is accidental
   - Intentional fallthrough is rare
   - But missing `break` is a common bug

3. **Code Review Overhead:**
   - Every switch needs review: "Is missing break intentional?"
   - Comments like `// Fall through` needed
   - Defensive programming required

**Go's Solution:**

Default behavior = what you want 99% of the time:
```go
switch status {
case Connected:
    sendData()
    // Automatic break!
case Disconnected:
    closeConnection()
}
```

If you really need fallthrough (rare):
```go
switch status {
case Starting:
    initialize()
    fallthrough     // EXPLICIT keyword
case Running:
    process()
}
```

**Additional Go Switch Features:**

1. **Switch Without Expression:**
   ```go
   // Like if-else chain, but cleaner
   switch {
   case x < 0:
       fmt.Println("negative")
   case x == 0:
       fmt.Println("zero")
   case x > 0:
       fmt.Println("positive")
   }
   ```

2. **Type Switch:**
   ```go
   switch v := value.(type) {
   case int:
       fmt.Println("integer:", v)
   case string:
       fmt.Println("string:", v)
   default:
       fmt.Println("unknown type")
   }
   ```

3. **Multiple Values:**
   ```go
   switch char {
   case 'a', 'e', 'i', 'o', 'u':
       fmt.Println("vowel")
   default:
       fmt.Println("consonant")
   }
   ```

**Why This Design:**

From Go creators:
> "Automatic fallthrough is a common source of bugs. Making break automatic and fallthrough explicit prevents most switch bugs."

**Statistics:**
- In C++ codebases: ~5% of fallthrough is intentional
- 95% of fallthrough = missing break bug
- Better to require keyword for the 5% case

**Trade-offs:**
- ✅ **Pro**: Prevents 95% of switch bugs
- ✅ **Pro**: Cleaner code (no break everywhere)
- ❌ **Con**: Need `fallthrough` keyword for rare cases
- ✅ **Pro**: Code review is easier

---

## `defer`: Go's Unique Feature

### C++ RAII Pattern

```cpp
void processFile() {
    std::ifstream file("data.txt");
    // RAII: file closed automatically at end of scope
    
    std::lock_guard<std::mutex> lock(mtx);
    // RAII: mutex unlocked automatically
    
    // Process file...
}  // Destructors run here
```

### Go `defer` Statement

```go
func processFile() {
    file, err := os.Open("data.txt")
    if err != nil {
        return
    }
    defer file.Close()      // Runs when function exits
    
    mu.Lock()
    defer mu.Unlock()       // Runs when function exits
    
    // Process file...
}  // Deferred functions run here (LIFO order)
```

### Design Rationale: WHY `defer`?

**Problems `defer` Solves:**

1. **Error Handling Without Exceptions:**
   ```cpp
   // C++ with exceptions (RAII works)
   void process() {
       File file("data");
       // If exception: destructor runs automatically
   }
   
   // C without exceptions (manual cleanup)
   void process() {
       FILE* file = fopen("data", "r");
       if (!file) return;
       
       // Complex logic here...
       if (error1) {
           fclose(file);  // Must remember!
           return;
       }
       
       if (error2) {
           fclose(file);  // Must remember!
           return;
       }
       
       fclose(file);  // Must remember!
   }
   ```

   ```go
   // Go with defer (simple cleanup)
   func process() error {
       file, err := os.Open("data")
       if err != nil {
           return err
       }
       defer file.Close()  // Once! Always runs
       
       // Complex logic here...
       if error1 {
           return error1   // file.Close() runs
       }
       
       if error2 {
           return error2   // file.Close() runs
       }
       
       return nil          // file.Close() runs
   }
   ```

2. **Cleanup Next to Acquisition:**
   ```go
   file, err := os.Open("data")
   if err != nil {
       return err
   }
   defer file.Close()  // Cleanup right after acquisition!
   
   // 500 lines of code...
   // Don't have to scroll to bottom to see cleanup
   ```

**Why Not Just Use RAII?**

Go doesn't have:
- Destructors
- Exceptions
- Automatic cleanup

But Go has:
- Multiple return values (including errors)
- Explicit error handling
- `defer` for cleanup

**`defer` Execution Order: LIFO (Last In, First Out)**

```go
func example() {
    defer fmt.Println("1")
    defer fmt.Println("2")
    defer fmt.Println("3")
    fmt.Println("body")
}
// Output:
// body
// 3
// 2
// 1
```

**Why LIFO?**

Mirrors C++ destructor order:
```cpp
{
    Resource r1;
    Resource r2;
    Resource r3;
}
// Destroyed in order: r3, r2, r1
```

**Common Defer Patterns:**

1. **File Handling:**
   ```go
   f, err := os.Open("file.txt")
   if err != nil {
       return err
   }
   defer f.Close()
   ```

2. **Mutex Locking:**
   ```go
   mu.Lock()
   defer mu.Unlock()
   // No need to remember to unlock before every return
   ```

3. **Database Transactions:**
   ```go
   tx, err := db.Begin()
   if err != nil {
       return err
   }
   defer tx.Rollback()  // Rollback if commit not called
   
   // Do work...
   
   return tx.Commit()  // Commit overrides rollback
   ```

4. **Timing Functions:**
   ```go
   func trace(name string) func() {
       start := time.Now()
       fmt.Println("enter:", name)
       return func() {
           fmt.Println("exit:", name, time.Since(start))
       }
   }
   
   func bigFunction() {
       defer trace("bigFunction")()
       // Function execution...
   }
   ```

**Defer Gotcha: Argument Evaluation**

```go
func example() {
    x := 1
    defer fmt.Println(x)    // Captures value: 1
    x++
    // Prints: 1 (not 2!)
}

// To capture final value:
func example() {
    x := 1
    defer func() {
        fmt.Println(x)      // Closure captures variable
    }()
    x++
    // Prints: 2
}
```

**Performance:**

`defer` has a small cost (~50ns), but:
- Negligible in most code
- Correctness > micro-optimization
- Modern Go optimizes simple defers

**Trade-offs:**
- ✅ **Pro**: Cleanup guaranteed, even with multiple returns
- ✅ **Pro**: Cleanup code next to acquisition
- ✅ **Pro**: Simpler than manual cleanup
- ❌ **Con**: Small runtime cost
- ✅ **Pro**: No need for destructors/RAII

---

## `break`, `continue`, and Labels

### Basic Usage (Same as C++)

```go
for i := 0; i < 10; i++ {
    if i == 5 {
        continue    // Skip to next iteration
    }
    if i == 8 {
        break       // Exit loop
    }
}
```

### Go's Labeled Breaks (Better Than C++)

**C++ Nested Loops:**
```cpp
// How to break out of nested loops?
bool found = false;
for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
        if (array[i][j] == target) {
            found = true;
            break;      // Only breaks inner loop!
        }
    }
    if (found) break;   // Need this too!
}

// Or use goto (frowned upon)
for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
        if (array[i][j] == target) {
            goto done;
        }
    }
}
done:
```

**Go Labeled Breaks:**
```go
outer:
for i := 0; i < 10; i++ {
    for j := 0; j < 10; j++ {
        if array[i][j] == target {
            break outer     // Breaks outer loop!
        }
    }
}
```

**Why This Is Better:**

1. **No Extra Variables:**
   - No need for `found` flag
   - Cleaner code

2. **Clearer Intent:**
   - `break outer` is explicit
   - Reader knows which loop breaks

3. **No `goto` Needed:**
   - Structured, not arbitrary jumps
   - Can only break to enclosing loop

**Labeled `continue`:**
```go
outer:
for i := 0; i < 3; i++ {
    for j := 0; j < 3; j++ {
        if j == 1 {
            continue outer  // Continue outer loop
        }
        fmt.Println(i, j)
    }
}
```

---

## No `goto`?

**Go HAS `goto`, But...**

```go
func example() {
    goto label
    fmt.Println("skipped")
label:
    fmt.Println("jumped here")
}
```

**When to Use `goto` (Rarely!):**

1. **Error Cleanup (Old Style):**
   ```go
   func process() error {
       resource1, err := acquire1()
       if err != nil {
           goto cleanup
       }
       
       resource2, err := acquire2()
       if err != nil {
           goto cleanup1
       }
       
       // Process...
       
       release2(resource2)
   cleanup1:
       release1(resource1)
   cleanup:
       return err
   }
   ```

   But `defer` is better:
   ```go
   func process() error {
       resource1, err := acquire1()
       if err != nil {
           return err
       }
       defer release1(resource1)
       
       resource2, err := acquire2()
       if err != nil {
           return err
       }
       defer release2(resource2)
       
       // Process...
       return nil
   }
   ```

2. **Breaking Out of Nested Loops:**
   Use labeled break instead!

**Why Keep `goto`?**

- Sometimes needed for generated code
- Can be clearer than convoluted logic (rare)
- Philosophy: Trust programmers, but encourage better ways

---

## Summary: Control Flow Design Philosophy

### Why Go's Design?

1. **Simplicity:**
   - One loop keyword (`for`)
   - No fallthrough by default (switch)
   - Clear, obvious control flow

2. **Safety:**
   - `defer` ensures cleanup
   - No automatic fallthrough bugs
   - Labeled breaks are structured

3. **Readability:**
   - Code does what it looks like
   - No hidden control flow
   - Explicit is better than implicit

**Core Principle:**
> "Make the common case simple, and the exceptional case explicit."

**The Go Way:**
- `for` for all loops (simple)
- `switch` doesn't fall through (safe)
- `defer` for cleanup (reliable)
- Labeled breaks (structured)

---

**Further Reading:**
- [Effective Go - Control Structures](https://go.dev/doc/effective_go#control-structures)
- [Go Spec - Statements](https://go.dev/ref/spec#Statements)
- [Defer, Panic, Recover](https://go.dev/blog/defer-panic-and-recover)

