# Go Data Types and Variables: Intermediate Concepts

## 1. No Implicit Type Conversions: A Deliberate Design Choice

### The C/C++ Problem: Implicit Conversions

C/C++ allows implicit conversions that cause subtle bugs:

```c
// C/C++ - Silent data loss and surprising behavior
int32_t a = 1000000;
int16_t b = a;        // SILENT truncation! b is now some garbage value

unsigned int u = -1;  // SILENT conversion! u is now UINT_MAX

float f = 1.5;
int i = f;            // SILENT truncation! i is 1

// The "billion dollar mistake"
if (a < u) { ... }    // Signed/unsigned comparison - undefined behavior!
```

### Go's Approach: Explicit Conversions Only

```go
// Go - Every conversion must be explicit
var a int32 = 1000000
var b int16 = a        // COMPILE ERROR: cannot use a (int32) as int16

// Must be explicit:
var b int16 = int16(a) // OK, but you're acknowledging potential truncation

// No implicit numeric conversions at all:
var i int = 42
var f float64 = i      // COMPILE ERROR
var f float64 = float64(i)  // OK, explicit

// Even between int and int64:
var x int = 42
var y int64 = x        // COMPILE ERROR (even though int might be 64-bit!)
var y int64 = int64(x) // OK, explicit
```

### Why Force Explicit Conversions?

**1. Prevents Silent Data Loss**
```go
// You see the conversion, you think about it
var big int64 = 9223372036854775807  // Max int64
var small int32 = int32(big)          // You wrote this - you own this bug
// Value is now -1 due to overflow
```

**2. Eliminates Signed/Unsigned Confusion**
```go
var signed int = -1
var unsigned uint = uint(signed)  // You explicitly chose this
// unsigned is now 18446744073709551615 on 64-bit
```

**3. Makes Code Intent Clear**
```go
// Reading this code, you know a conversion happens
result := float64(numerator) / float64(denominator)

// vs C where you might miss it:
// result = numerator / denominator;  // Integer division? Float? Who knows!
```

### The Trade-off: Safety vs Convenience

**What You Lose:**
```go
// More verbose code
func average(nums []int) float64 {
    sum := 0
    for _, n := range nums {
        sum += n
    }
    return float64(sum) / float64(len(nums))  // Two explicit conversions
}
```

**What You Gain:**
- No silent truncation bugs
- No signed/unsigned comparison surprises
- Code is self-documenting
- Compiler catches type mismatches

### Common Conversion Patterns

```go
// Numeric conversions
i := 42
f := float64(i)
i2 := int(f)  // Truncates toward zero

// String conversions (these are special!)
s := string(65)        // "A" (Unicode code point, NOT "65"!)
s := strconv.Itoa(65)  // "65" (what you probably wanted)

n, _ := strconv.Atoi("42")  // Parse string to int

// Byte slice to string
bytes := []byte{72, 101, 108, 108, 111}
s := string(bytes)  // "Hello"

// String to byte slice
s := "Hello"
bytes := []byte(s)  // []byte{72, 101, 108, 108, 111}
```

---

## 2. Strings as First-Class Types

### C's Approach: Strings as Char Arrays

```c
// C - strings are just char arrays with null terminator
char* s = "hello";           // Pointer to static memory
char s2[] = "hello";         // Array on stack, 6 bytes (including \0)
char* s3 = malloc(6);        // Manual allocation
strcpy(s3, "hello");         // Manual copy
// ... later ...
free(s3);                    // Manual deallocation

// Problems:
// - Buffer overflows
// - Null terminator bugs
// - Manual memory management
// - No length stored (strlen is O(n))
```

### Go's Approach: Strings as Values

```go
// Go - strings are immutable, length-prefixed values
s := "hello"          // Immutable string value
s2 := s               // Copy is cheap (just pointer + length)
s3 := s + " world"    // Concatenation creates new string

// String header (internal representation):
// type stringHeader struct {
//     Data uintptr  // pointer to bytes
//     Len  int      // length (not capacity!)
// }
```

### Key Properties of Go Strings

**1. Immutable**
```go
s := "hello"
s[0] = 'H'  // COMPILE ERROR: cannot assign to s[0]

// Must create new string:
s = "H" + s[1:]  // "Hello"

// Or use byte slice for mutation:
b := []byte(s)
b[0] = 'H'
s = string(b)
```

**2. Length is O(1)**
```go
s := "hello world"
n := len(s)  // O(1), length is stored in header
// Unlike C's strlen which is O(n)
```

**3. Safe to Share**
```go
// Substring shares underlying memory but is safe because immutable
s := "hello world"
sub := s[0:5]  // "hello" - shares bytes with s
// Modifying s doesn't affect sub (can't modify anyway!)
```

**4. Can Contain Any Bytes (Including Null)**
```go
s := "hello\x00world"
fmt.Println(len(s))  // 11 (not 5!)
// Unlike C where \0 would terminate the string
```

### Strings vs Byte Slices

```go
// String: immutable, for text
var s string = "hello"

// []byte: mutable, for binary data or when mutation needed
var b []byte = []byte("hello")
b[0] = 'H'  // OK

// []byte is also used for:
// - Reading files
// - Network I/O
// - Crypto operations
// - Any binary data

// Conversions (copies data!):
s := string(b)    // []byte → string (copy)
b := []byte(s)    // string → []byte (copy)
```

### Why Immutability Matters

```go
// Safe for concurrent access
var globalConfig string = "default"

func handler() {
    cfg := globalConfig  // Safe! Strings are immutable
    // Another goroutine can't modify cfg through globalConfig
}

// Safe as map keys
m := map[string]int{
    "key1": 1,
    "key2": 2,
}
// If strings were mutable, keys could change after insertion!
```

---

## 3. UTF-8 by Default: A Modern Design

### The Historical Problem

```c
// C/C++ - encoding chaos
char* s = "hello";           // ASCII? Latin-1? UTF-8? Who knows!
wchar_t* ws = L"hello";      // Wide chars - platform dependent size!
char16_t* u16 = u"hello";    // C++11 UTF-16
char32_t* u32 = U"hello";    // C++11 UTF-32

// Different platforms, different defaults, endless bugs
```

### Go's Solution: UTF-8 Everywhere

```go
// All string literals are UTF-8
s := "Hello, 世界"  // UTF-8 encoded
s := "Привет"      // UTF-8 encoded
s := "🎉"          // UTF-8 encoded

// Source files are UTF-8
// String constants are UTF-8
// Standard library assumes UTF-8
```

### Why UTF-8?

1. **ASCII compatible** - ASCII text is valid UTF-8
2. **No byte-order issues** - Unlike UTF-16/32
3. **Self-synchronizing** - Can find character boundaries from any position
4. **Space efficient** - ASCII uses 1 byte, common chars use few bytes
5. **Web standard** - HTTP, JSON, HTML all default to UTF-8

### UTF-8 Encoding Basics

```go
s := "Hello, 世界"

// Byte representation:
// 'H' 'e' 'l' 'l' 'o' ',' ' ' [世: 3 bytes] [界: 3 bytes]
// 48  65  6c  6c  6f  2c  20  e4 b8 96     e7 95 8c

fmt.Println(len(s))  // 13 bytes (not 9 characters!)

// Bytes vs characters:
for i := 0; i < len(s); i++ {
    fmt.Printf("%x ", s[i])  // Prints bytes
}
// Output: 48 65 6c 6c 6f 2c 20 e4 b8 96 e7 95 8c

// Characters (runes):
for _, r := range s {
    fmt.Printf("%c ", r)  // Prints characters
}
// Output: H e l l o ,   世 界
```

---

## 4. Runes vs Chars: Unicode Handling Done Right

### The Concept of a Rune

```go
// rune is an alias for int32
type rune = int32

// A rune represents a Unicode code point
var r rune = 'A'      // 65
var r2 rune = '世'    // 19990
var r3 rune = '🎉'    // 127881

// Single quotes = rune literal
// Double quotes = string literal
```

### Why Not `char` Like C/C++?

```c
// C/C++ - char is 1 byte, can't hold most Unicode
char c = '世';  // Won't work! 世 needs 3 bytes in UTF-8

// C++ tried to fix with wchar_t, char16_t, char32_t
// But wchar_t is 2 bytes on Windows, 4 bytes on Unix - chaos!
```

```go
// Go - rune is always 32 bits, can hold any Unicode code point
var r rune = '世'  // Works! r == 19990
var r2 rune = '🎉' // Works! r2 == 127881
```

### Working with Strings and Runes

```go
s := "Hello, 世界"

// WRONG: Iterating by byte index
for i := 0; i < len(s); i++ {
    fmt.Printf("%c", s[i])  // Garbage for multi-byte chars!
}

// RIGHT: Iterating by rune (using range)
for i, r := range s {
    fmt.Printf("Index %d: %c (U+%04X)\n", i, r, r)
}
// Output:
// Index 0: H (U+0048)
// Index 1: e (U+0065)
// ...
// Index 7: 世 (U+4E16)   <- Note: index jumps from 7 to 10!
// Index 10: 界 (U+754C)

// Getting rune count (not byte count)
runeCount := utf8.RuneCountInString(s)  // 9
byteCount := len(s)                      // 13
```

### Common Rune Operations

```go
import "unicode/utf8"

s := "Hello, 世界"

// Count runes (characters)
n := utf8.RuneCountInString(s)  // 9

// Get first rune
r, size := utf8.DecodeRuneInString(s)  // 'H', 1

// Convert to rune slice (when random access needed)
runes := []rune(s)
runes[7] = '中'  // Replace 世 with 中
s = string(runes)  // "Hello, 中界"

// Check if valid UTF-8
valid := utf8.ValidString(s)  // true
```

### Runes in Practice

```go
// Reversing a string (must use runes!)
func reverse(s string) string {
    runes := []rune(s)
    for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
        runes[i], runes[j] = runes[j], runes[i]
    }
    return string(runes)
}

reverse("Hello, 世界")  // "界世 ,olleH"

// WRONG approach (reversing bytes):
func wrongReverse(s string) string {
    b := []byte(s)
    for i, j := 0, len(b)-1; i < j; i, j = i+1, j-1 {
        b[i], b[j] = b[j], b[i]
    }
    return string(b)  // Corrupted UTF-8!
}
```

### Memory Considerations

```go
s := "Hello"

// string: 5 bytes of data + 16 bytes header
// []byte(s): 5 bytes of data + 24 bytes slice header (len, cap, ptr)
// []rune(s): 20 bytes of data (5 * 4) + 24 bytes slice header

// For large strings, []rune can use 4x more memory!
// Only convert to []rune when you need random access by character
```

---

## Summary: Go's Modern String Design

| Aspect | C/C++ | Go | Benefit |
|--------|-------|-----|---------|
| Conversion | Implicit numeric | Explicit only | No silent bugs |
| String type | char*/array | First-class value | Safety, simplicity |
| Mutability | Mutable | Immutable strings | Thread-safe, hashable |
| Encoding | Undefined | UTF-8 everywhere | Consistency |
| Character type | char (1 byte) | rune (4 bytes) | Full Unicode support |
| Length | O(n) strlen | O(1) len | Performance |

**Key Takeaways for C/C++ Developers:**
1. Explicit conversions feel verbose but prevent real bugs
2. Strings are values, not pointers - think differently
3. `len(s)` is bytes, not characters - use `utf8.RuneCountInString`
4. Use `range` to iterate over characters, not index
5. Convert to `[]rune` only when you need random character access
