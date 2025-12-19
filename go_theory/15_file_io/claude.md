# Go File I/O - Learning Context

## Topic Overview
File I/O in Go is simpler than C++ with better error handling and built-in support for common operations.

## Basic File Reading

**C++:**
```cpp
#include <fstream>
#include <string>

// Read entire file
std::ifstream file("data.txt");
std::string content((std::istreambuf_iterator<char>(file)),
                     std::istreambuf_iterator<char>());

// Or line by line
std::string line;
while (std::getline(file, line)) {
    // process line
}
```

**Go - Multiple Ways:**
```go
import (
    "io"
    "os"
    "bufio"
)

// 1. Read entire file (simple)
data, err := os.ReadFile("data.txt")
if err != nil {
    log.Fatal(err)
}
fmt.Println(string(data))

// 2. Open and read
file, err := os.Open("data.txt")
if err != nil {
    log.Fatal(err)
}
defer file.Close()

data, err := io.ReadAll(file)

// 3. Buffered reading (efficient for large files)
file, err := os.Open("data.txt")
defer file.Close()

scanner := bufio.NewScanner(file)
for scanner.Scan() {
    line := scanner.Text()
    fmt.Println(line)
}
if err := scanner.Err(); err != nil {
    log.Fatal(err)
}
```

## Basic File Writing

**C++:**
```cpp
#include <fstream>

std::ofstream file("output.txt");
file << "Hello World\n";
file.close();
```

**Go:**
```go
// 1. Write entire file (simple)
data := []byte("Hello World\n")
err := os.WriteFile("output.txt", data, 0644)
if err != nil {
    log.Fatal(err)
}

// 2. Open and write
file, err := os.Create("output.txt")
if err != nil {
    log.Fatal(err)
}
defer file.Close()

file.WriteString("Hello World\n")
// or
file.Write([]byte("Hello World\n"))

// 3. Buffered writing (efficient)
file, err := os.Create("output.txt")
defer file.Close()

writer := bufio.NewWriter(file)
writer.WriteString("Hello World\n")
writer.Flush()  // important!
```

## File Opening Modes

**C++:** Various mode flags
**Go:**
```go
// Read only
file, err := os.Open("file.txt")

// Write only (create/truncate)
file, err := os.Create("file.txt")

// Append
file, err := os.OpenFile("file.txt", os.O_APPEND|os.O_WRONLY, 0644)

// Read and write
file, err := os.OpenFile("file.txt", os.O_RDWR, 0644)

// Create if not exists
file, err := os.OpenFile("file.txt", os.O_CREATE|os.O_WRONLY, 0644)
```

**Common flags:**
```go
os.O_RDONLY    // Read only
os.O_WRONLY    // Write only
os.O_RDWR      // Read and write
os.O_APPEND    // Append mode
os.O_CREATE    // Create if not exists
os.O_TRUNC     // Truncate to 0
os.O_EXCL      // With O_CREATE, fail if exists
```

## File Permissions

**Unix-style permissions:**
```go
// 0644 = rw-r--r--
// Owner: read+write (6 = 4+2)
// Group: read (4)
// Others: read (4)

os.Create("file.txt")  // default 0666
os.WriteFile("file.txt", data, 0644)
os.Chmod("file.txt", 0755)
```

## File Information

**C++:** stat() system call
**Go:**
```go
info, err := os.Stat("file.txt")
if err != nil {
    if os.IsNotExist(err) {
        fmt.Println("File doesn't exist")
    }
    log.Fatal(err)
}

fmt.Println("Name:", info.Name())
fmt.Println("Size:", info.Size())
fmt.Println("Mode:", info.Mode())
fmt.Println("ModTime:", info.ModTime())
fmt.Println("IsDir:", info.IsDir())
```

## Directory Operations

### Creating Directories
```go
// Create single directory
err := os.Mkdir("newdir", 0755)

// Create with parents (like mkdir -p)
err := os.MkdirAll("path/to/newdir", 0755)
```

### Removing Files/Directories
```go
// Remove file or empty directory
err := os.Remove("file.txt")

// Remove directory and contents (like rm -rf)
err := os.RemoveAll("directory")
```

### Listing Directory Contents
```go
// Read all entries
entries, err := os.ReadDir(".")
if err != nil {
    log.Fatal(err)
}

for _, entry := range entries {
    fmt.Println(entry.Name())
    if entry.IsDir() {
        fmt.Println("  [DIR]")
    }
}

// Or with file info
files, err := os.ReadDir(".")
for _, file := range files {
    info, _ := file.Info()
    fmt.Printf("%s %d bytes\n", file.Name(), info.Size())
}
```

## Walking Directory Tree

**C++:** Complex with system calls
**Go:**
```go
import "path/filepath"

err := filepath.Walk(".", func(path string, info os.FileInfo, err error) error {
    if err != nil {
        return err
    }
    fmt.Printf("%s (%d bytes)\n", path, info.Size())
    return nil
})

// Or WalkDir (more efficient, Go 1.16+)
err := filepath.WalkDir(".", func(path string, d fs.DirEntry, err error) error {
    if err != nil {
        return err
    }
    fmt.Println(path)
    return nil
})
```

## Working with Paths

**C++:** String manipulation
**Go - path/filepath:**
```go
import "path/filepath"

// Join paths (OS-specific separator)
path := filepath.Join("dir", "subdir", "file.txt")

// Split path
dir, file := filepath.Split("/path/to/file.txt")

// Get directory
dir := filepath.Dir("/path/to/file.txt")  // /path/to

// Get filename
name := filepath.Base("/path/to/file.txt")  // file.txt

// Get extension
ext := filepath.Ext("file.txt")  // .txt

// Absolute path
abs, err := filepath.Abs("relative/path")

// Clean path
clean := filepath.Clean("./dir/../file.txt")  // file.txt
```

## Temporary Files

```go
import "os"

// Temporary file
tmpFile, err := os.CreateTemp("", "prefix-*.txt")
if err != nil {
    log.Fatal(err)
}
defer os.Remove(tmpFile.Name())  // cleanup
defer tmpFile.Close()

tmpFile.WriteString("temporary data")

// Temporary directory
tmpDir, err := os.MkdirTemp("", "prefix-")
defer os.RemoveAll(tmpDir)
```

## io.Reader and io.Writer Interfaces

**Core interfaces for I/O:**
```go
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}
```

**Many types implement these:**
```go
var r io.Reader

r = os.Stdin
r = strings.NewReader("hello")
r = bytes.NewReader([]byte("hello"))

// Copy between any Reader and Writer
io.Copy(os.Stdout, os.Stdin)
```

## Buffered I/O

**bufio package for efficiency:**
```go
import "bufio"

// Buffered reader
file, _ := os.Open("large.txt")
reader := bufio.NewReader(file)

// Read line
line, err := reader.ReadString('\n')

// Read exactly n bytes
buf := make([]byte, 100)
n, err := io.ReadFull(reader, buf)

// Buffered writer
file, _ := os.Create("output.txt")
writer := bufio.NewWriter(file)

writer.WriteString("data\n")
writer.Flush()  // Must flush!
```

## Binary File I/O

**encoding/binary package:**
```go
import "encoding/binary"

// Writing binary data
file, _ := os.Create("data.bin")
defer file.Close()

// Write integers
binary.Write(file, binary.LittleEndian, int32(42))
binary.Write(file, binary.BigEndian, uint64(123))

// Reading binary data
file, _ := os.Open("data.bin")
var value int32
binary.Read(file, binary.LittleEndian, &value)
```

## JSON File I/O

**Common pattern:**
```go
import "encoding/json"

type Person struct {
    Name string `json:"name"`
    Age  int    `json:"age"`
}

// Write JSON to file
people := []Person{
    {Name: "Alice", Age: 25},
    {Name: "Bob", Age: 30},
}

data, _ := json.MarshalIndent(people, "", "  ")
os.WriteFile("people.json", data, 0644)

// Read JSON from file
data, _ := os.ReadFile("people.json")
var people []Person
json.Unmarshal(data, &people)

// Or directly with encoder/decoder
file, _ := os.Create("people.json")
encoder := json.NewEncoder(file)
encoder.Encode(people)

file, _ := os.Open("people.json")
decoder := json.NewDecoder(file)
decoder.Decode(&people)
```

## File Seeking

**Random access:**
```go
file, _ := os.Open("data.txt")
defer file.Close()

// Seek to position
offset, err := file.Seek(10, 0)  // 10 bytes from start

// Seek modes
file.Seek(0, 0)   // Start of file (os.SEEK_SET)
file.Seek(10, 1)  // 10 bytes from current (os.SEEK_CUR)
file.Seek(-5, 2)  // 5 bytes before end (os.SEEK_END)

// Get current position
pos, _ := file.Seek(0, 1)
```

## File Locking

**Using flock (Unix):**
```go
import "syscall"

file, _ := os.OpenFile("file.txt", os.O_RDWR, 0644)
defer file.Close()

// Exclusive lock
err := syscall.Flock(int(file.Fd()), syscall.LOCK_EX)
defer syscall.Flock(int(file.Fd()), syscall.LOCK_UN)

// Shared lock
err = syscall.Flock(int(file.Fd()), syscall.LOCK_SH)

// Non-blocking
err = syscall.Flock(int(file.Fd()), syscall.LOCK_EX|syscall.LOCK_NB)
```

## Error Handling Patterns

```go
// Check if file exists
if _, err := os.Stat("file.txt"); os.IsNotExist(err) {
    fmt.Println("File doesn't exist")
}

// Check permission errors
if _, err := os.Open("file.txt"); os.IsPermission(err) {
    fmt.Println("Permission denied")
}

// Check if error is specific type
if pathErr, ok := err.(*os.PathError); ok {
    fmt.Println("Path:", pathErr.Path)
    fmt.Println("Op:", pathErr.Op)
    fmt.Println("Err:", pathErr.Err)
}
```

## Learning Path

### Basic Level
- Reading/writing files
- Opening modes and permissions
- defer for closing files
- File existence checks
- Basic directory operations

### Intermediate Level
- Buffered I/O
- Walking directories
- Path manipulation
- io.Reader/Writer interfaces
- JSON file operations
- Temporary files

### Advanced Level
- Binary file I/O
- File seeking and random access
- File locking
- Memory-mapped files
- Performance optimization
- Cross-platform considerations

## Key Differences from C++

1. **Simpler API** - Less boilerplate
2. **Built-in error handling** - Return errors, not exceptions
3. **defer for cleanup** - Guaranteed cleanup
4. **Interface-based** - io.Reader/Writer everywhere
5. **UTF-8 by default** - String handling simpler
6. **Path package** - OS-independent paths
7. **No manual close checking** - defer handles it

## Best Practices

1. **Always check errors** - Don't ignore file errors
2. **Use defer for Close()** - Prevents resource leaks
3. **Buffer large I/O** - Use bufio for efficiency
4. **Use filepath.Join()** - OS-independent paths
5. **Check file existence** - Before operations
6. **Use ReadFile/WriteFile** - For simple cases
7. **Flush buffered writers** - Don't forget!

## Common Pitfalls

1. **Forgetting to close files** - Use defer
2. **Not checking errors** - Always check
3. **Forgetting Flush()** - Buffered writers
4. **Wrong permissions** - Check file modes
5. **Path separator issues** - Use filepath
6. **Not handling EOF** - Check err == io.EOF
7. **Large files in memory** - Use streaming

## Practice Context

Focus on:
- Reading and writing files efficiently
- Proper error handling
- Using defer for cleanup
- Working with paths correctly
- Buffered vs unbuffered I/O
- JSON file operations
- Converting C++ file I/O to Go
