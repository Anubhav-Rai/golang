# Go Basics and Syntax - Advanced Level

## Compiler Internals, Optimization & Low-Level Details

### 1. Compiler Directives

**Go Directives:**
```go
//go:noescape
func memmove(to, from unsafe.Pointer, n uintptr)

//go:nosplit
func criticalFunction() {
    // Don't allow stack split here
}

//go:linkname localname importpath.name
var now func() (sec int64, nsec int32)

//go:noinline
func debugFunction() {
    // Force no inlining for debugging
}
```

**C/C++:**
```cpp
__attribute__((noinline)) void func();           // GCC
__declspec(noinline) void func();                // MSVC
#pragma GCC optimize("no-inline")                // Pragma
```

**Design Rationale:**
- **Why**: Give escape hatches for performance tuning
- **Safety**: Most are in runtime package, not user code
- **C/C++ Comparison**: Less standardized, compiler-specific
- **Trade-off**: Powerful but can break assumptions

### 2. Escape Analysis

**Concept:**
```go
// Allocates on stack (faster)
func stackAlloc() int {
    x := 42
    return x
}

// Allocates on heap (slower, but necessary)
func heapAlloc() *int {
    x := 42
    return &x  // x escapes!
}
```

**Analysis Tool:**
```bash
go build -gcflags='-m' main.go
# Shows: moved to heap: x
```

**C/C++:**
```cpp
// Manual control
int* heapAlloc() {
    int* x = new int(42);  // Explicitly heap
    return x;  // Must delete later!
}

int stackAlloc() {
    int x = 42;  // Stack
    return x;
}
```

**Design Rationale:**
- **Why Automatic**: Compiler decides stack vs heap
- **C/C++ Problem**: Manual memory management error-prone (memory leaks, dangling pointers)
- **Go Benefit**: Safety (no dangling pointers) + performance (stack when possible)
- **Trade-off**: Less control, but safer
- **Analysis**: Compiler is conservative (when in doubt, heap)

**What Causes Escape:**
- Returning pointer to local variable
- Storing pointer in global/heap structure  
- Sending pointer to channel
- Interface conversion (sometimes)
- Closures capturing variables

### 3. Inline Assembly

**Go Approach:**
```go
//go:noescape
//go:linkname add runtime.add
func add(x, y uintptr) uintptr

// Assembly file: add_amd64.s
TEXT ·add(SB),$0
    MOVQ x+0(FP), AX
    ADDQ y+8(FP), AX
    MOVQ AX, ret+16(FP)
    RET
```

**C/C++:**
```cpp
int add(int x, int y) {
    int result;
    __asm__ (
        "addl %%ebx, %%eax"
        : "=a" (result)
        : "a" (x), "b" (y)
    );
    return result;
}
```

**Design Rationale:**
- **Why Separate Files**: Keep .go files portable
- **Plan 9 Assembler**: Different syntax from AT&T/Intel
- **Use Cases**: Runtime internals, crypto, hot paths
- **C/C++ Comparison**: Inline asm less portable
- **Rarity**: Most code never needs this

### 4. CGo - Calling C Code

**Go Calling C:**
```go
package main

/*
#include <stdlib.h>
#include <stdio.h>

void greet(char* name) {
    printf("Hello, %s!
", name);
}
*/
import "C"
import "unsafe"

func main() {
    cstr := C.CString("World")
    defer C.free(unsafe.Pointer(cstr))
    C.greet(cstr)
}
```

**Design Rationale:**
- **Why CGo**: Interoperability with C libraries
- **Cost**: Overhead of crossing Go/C boundary (10x slower)
- **Benefits**: Access massive C ecosystem
- **Pitfalls**:
  - C doesn't know about Go GC
  - Must manually free C memory
  - Can't pass Go pointers to C (runtime may panic)
  - Slows down compilation
  - Cross-compilation harder

**C/C++ Comparison:**
- C++ can call C directly (extern "C")
- Go needs explicit bridge (cgo)
- **Why**: Different memory models, GC, calling conventions

### 5. Build Modes

**Different Build Outputs:**
```bash
# Standard binary
go build -o myapp

# Static library (.a)
go build -buildmode=c-archive -o lib.a

# Shared library (.so)
go build -buildmode=c-shared -o lib.so

# Plugin (loadable at runtime)
go build -buildmode=plugin -o plug.so
```

**C/C++:**
```bash
gcc -c file.c                    # Object file
gcc -shared -o lib.so file.c     # Shared library
gcc -static -o binary file.c     # Static binary
```

**Design Rationale:**
- **Flexibility**: Go can produce different artifact types
- **Default**: Static binary (easy deployment)
- **C-archive/C-shared**: Embed Go in C/C++ applications
- **Plugin**: Hot reload modules (experimental)
- **Trade-off**: Static linking = larger binaries but simpler deployment

### 6. Linker and Symbol Visibility

**Go Linker Flags:**
```bash
# Strip debug symbols (smaller binary)
go build -ldflags="-s -w"

# Set variable at link time
go build -ldflags="-X main.version=1.0.0"

# Custom linking
go build -ldflags="-linkmode external -extldflags -static"
```

**In Code:**
```go
package main

var version string  // Set by linker

func main() {
    println(version)  // Will be "1.0.0"
}
```

**C/C++:**
```cpp
// Must pass at compile time with -DVERSION
#ifndef VERSION
#define VERSION "unknown"
#endif
```

**Design Rationale:**
- **Linker Variables**: Set values without recompiling
- **Use Case**: Build metadata (version, commit hash, date)
- **C/C++ Comparison**: Needs preprocessor defines
- **Benefit**: No recompilation needed

### 7. Go Scheduler Hints

**Controlling Goroutines:**
```go
import "runtime"

func compute() {
    runtime.Gosched()        // Yield to other goroutines
    runtime.GOMAXPROCS(4)    // Limit OS threads
    runtime.LockOSThread()   // Pin goroutine to thread (for C calls)
}
```

**C/C++:**
```cpp
#include <thread>
#include <sched.h>

std::this_thread::yield();           // Yield
sched_setaffinity(/*...*/);          // Set CPU affinity
```

**Design Rationale:**
- **M:N Scheduler**: Go multiplexes goroutines on threads
- **C/C++**: 1:1 threading (thread = OS thread)
- **Benefit**: Lightweight concurrency (goroutines are cheap)
- **Control**: Usually not needed, scheduler is smart
- **LockOSThread**: Required for C libraries expecting consistent thread

### 8. Memory Model Guarantees

**Happens-Before Relationships:**
```go
var a string
var done bool

func setup() {
    a = "hello, world"
    done = true  // Write to done happens-after write to a
}

func main() {
    go setup()
    for !done {}  // Wait
    println(a)    // Guaranteed to see "hello, world"? NO!
}
```

**Correct Version:**
```go
var a string
var done = make(chan bool)

func setup() {
    a = "hello, world"
    done <- true  // Channel send synchronizes
}

func main() {
    go setup()
    <-done        // Channel receive synchronizes
    println(a)    // NOW guaranteed to see "hello, world"
}
```

**C++:**
```cpp
#include <atomic>
#include <string>

std::string a;
std::atomic<bool> done{false};

void setup() {
    a = "hello, world";
    done.store(true, std::memory_order_release);
}

int main() {
    std::thread t(setup);
    while (!done.load(std::memory_order_acquire)) {}
    std::cout << a;  // Guaranteed
    t.join();
}
```

**Design Rationale:**
- **Memory Model**: Defines what concurrent programs can observe
- **C++ Complexity**: Six memory orderings (relaxed, acquire, release, acq_rel, seq_cst, consume)
- **Go Simplicity**: Use channels and sync primitives - they synchronize correctly
- **Principle**: "Don't communicate by sharing memory, share memory by communicating"
- **Safety**: Harder to write incorrect concurrent code

### 9. Compiler Optimizations

**Bounds Check Elimination:**
```go
// Compiler eliminates bounds checks when it can prove safety
func sum(arr []int) int {
    total := 0
    for i := 0; i < len(arr); i++ {  // Bounds check eliminated!
        total += arr[i]
    }
    return total
}

// Or use range (no bounds checks)
func sum2(arr []int) int {
    total := 0
    for _, v := range arr {  // No bounds checks at all
        total += v
    }
    return total
}
```

**Check Optimizations:**
```bash
go build -gcflags="-d=ssa/check_bce/debug=1"
```

**C/C++:**
```cpp
// No bounds checking by default!
int arr[10];
arr[100] = 5;  // Undefined behavior, no error
```

**Design Rationale:**
- **Safety vs Performance**: Go has bounds checks, C/C++ doesn't
- **Optimization**: Compiler removes checks when provably safe
- **Best of Both**: Safety + performance
- **Philosophy**: Make the right thing fast

### 10. Reflection Performance

**Reflection is Slow:**
```go
// Direct call: ~1 ns
x := obj.Method()

// Reflection call: ~100 ns  
v := reflect.ValueOf(obj)
m := v.MethodByName("Method")
result := m.Call(nil)
```

**When Reflection is Necessary:**
- JSON/XML encoding/decoding
- ORM frameworks
- Dependency injection
- Generic algorithms (before Go 1.18)

**Design Rationale:**
- **Why Slow**: Dynamic dispatch, type checking at runtime, heap allocations
- **C++ RTTI**: Also slow, often disabled in performance-critical code
- **Alternative**: Code generation (protobuf, msgpack)
- **Generics**: Go 1.18+ reduces need for reflection

### Summary: Advanced Topics

| Topic | C/C++ | Go | Key Insight |
|-------|-------|-----|-------------|
| Memory Management | Manual (new/delete) | Automatic (GC + escape analysis) | Safety with performance |
| Assembly | Inline asm | Separate .s files | Portability |
| C Interop | Native | CGo (overhead) | Different runtimes |
| Concurrency Model | OS threads (1:1) | Goroutines (M:N) | Lightweight |
| Memory Ordering | Complex (6 orders) | Simple (use channels) | Ease of use |
| Bounds Checking | None (UB) | Yes (with elimination) | Safety + speed |

**Philosophy**: Make safe code fast, not unsafe code necessary.
