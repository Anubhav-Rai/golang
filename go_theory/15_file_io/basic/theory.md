# File I/O - Theory

## Reading Files
```go
// Read entire file
data, err := os.ReadFile("file.txt")
if err != nil {
    log.Fatal(err)
}
fmt.Println(string(data))

// Read with control
f, err := os.Open("file.txt")
if err != nil {
    log.Fatal(err)
}
defer f.Close()

scanner := bufio.NewScanner(f)
for scanner.Scan() {
    fmt.Println(scanner.Text())
}
```

## Writing Files
```go
// Write entire file
err := os.WriteFile("out.txt", []byte("content"), 0644)

// Write with control
f, err := os.Create("out.txt")
if err != nil {
    log.Fatal(err)
}
defer f.Close()

f.WriteString("Hello\n")
```
