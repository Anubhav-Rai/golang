# JSON and Interfaces - Theory

## JSON Encoding
```go
type Person struct {
    Name string `json:"name"`
    Age  int    `json:"age"`
}

p := Person{Name: "Alice", Age: 30}

// Marshal to JSON
data, err := json.Marshal(p)

// Unmarshal from JSON
var p2 Person
err = json.Unmarshal(data, &p2)
```

## io.Reader/Writer
```go
func processReader(r io.Reader) {
    data, _ := io.ReadAll(r)
    // Works with files, network, strings, etc.
}

// Works with any Reader
processReader(os.Stdin)
processReader(strings.NewReader("data"))
```
