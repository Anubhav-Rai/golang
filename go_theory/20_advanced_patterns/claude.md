# Go Advanced Patterns - Learning Context

## Topic Overview
Advanced Go idioms and patterns for building robust, maintainable systems. Beyond basic language features.

## Functional Options Pattern

**Flexible initialization without many constructors:**
```go
type Server struct {
    host    string
    port    int
    timeout time.Duration
    maxConn int
}

type Option func(*Server)

func WithPort(port int) Option {
    return func(s *Server) {
        s.port = port
    }
}

func WithTimeout(timeout time.Duration) Option {
    return func(s *Server) {
        s.timeout = timeout
    }
}

func WithMaxConnections(n int) Option {
    return func(s *Server) {
        s.maxConn = n
    }
}

func NewServer(host string, opts ...Option) *Server {
    s := &Server{
        host:    host,
        port:    8080,           // defaults
        timeout: 30 * time.Second,
        maxConn: 100,
    }
    
    for _, opt := range opts {
        opt(s)
    }
    
    return s
}

// Usage - clean and flexible
server := NewServer("localhost",
    WithPort(9000),
    WithTimeout(1*time.Minute),
)
```

## Context Pattern

**Cancellation, timeouts, and request-scoped values:**
```go
func operation(ctx context.Context) error {
    // Check cancellation
    select {
    case <-ctx.Done():
        return ctx.Err()
    default:
    }
    
    // Do work
    result := doWork()
    
    // Pass context down
    return childOperation(ctx, result)
}

// With timeout
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

if err := operation(ctx); err != nil {
    // Handle timeout or cancellation
}

// With cancellation
ctx, cancel := context.WithCancel(context.Background())
go func() {
    time.Sleep(time.Second)
    cancel()  // Cancel after 1 second
}()

// With values (use sparingly!)
type key string
ctx = context.WithValue(ctx, key("userID"), 123)
userID := ctx.Value(key("userID")).(int)
```

## Pipeline Pattern

**Chain operations with channels:**
```go
func generator(nums ...int) <-chan int {
    out := make(chan int)
    go func() {
        defer close(out)
        for _, n := range nums {
            out <- n
        }
    }()
    return out
}

func square(in <-chan int) <-chan int {
    out := make(chan int)
    go func() {
        defer close(out)
        for n := range in {
            out <- n * n
        }
    }()
    return out
}

func filter(in <-chan int, predicate func(int) bool) <-chan int {
    out := make(chan int)
    go func() {
        defer close(out)
        for n := range in {
            if predicate(n) {
                out <- n
            }
        }
    }()
    return out
}

// Usage
nums := generator(1, 2, 3, 4, 5)
squared := square(nums)
evens := filter(squared, func(n int) bool { return n%2 == 0 })

for n := range evens {
    fmt.Println(n)  // 4, 16
}
```

## Worker Pool Pattern

**Limit concurrency with worker pool:**
```go
func worker(id int, jobs <-chan Job, results chan<- Result) {
    for job := range jobs {
        result := processJob(job)
        results <- Result{ID: id, Value: result}
    }
}

func WorkerPool(numWorkers int, jobs []Job) []Result {
    jobsChan := make(chan Job, len(jobs))
    resultsChan := make(chan Result, len(jobs))
    
    // Start workers
    for w := 1; w <= numWorkers; w++ {
        go worker(w, jobsChan, resultsChan)
    }
    
    // Send jobs
    for _, job := range jobs {
        jobsChan <- job
    }
    close(jobsChan)
    
    // Collect results
    results := make([]Result, 0, len(jobs))
    for i := 0; i < len(jobs); i++ {
        results = append(results, <-resultsChan)
    }
    
    return results
}
```

## Builder Pattern

**Complex object construction:**
```go
type QueryBuilder struct {
    table      string
    fields     []string
    conditions []string
    limit      int
}

func NewQueryBuilder(table string) *QueryBuilder {
    return &QueryBuilder{table: table}
}

func (q *QueryBuilder) Select(fields ...string) *QueryBuilder {
    q.fields = append(q.fields, fields...)
    return q
}

func (q *QueryBuilder) Where(condition string) *QueryBuilder {
    q.conditions = append(q.conditions, condition)
    return q
}

func (q *QueryBuilder) Limit(n int) *QueryBuilder {
    q.limit = n
    return q
}

func (q *QueryBuilder) Build() string {
    query := fmt.Sprintf("SELECT %s FROM %s",
        strings.Join(q.fields, ", "),
        q.table)
    
    if len(q.conditions) > 0 {
        query += " WHERE " + strings.Join(q.conditions, " AND ")
    }
    
    if q.limit > 0 {
        query += fmt.Sprintf(" LIMIT %d", q.limit)
    }
    
    return query
}

// Usage
query := NewQueryBuilder("users").
    Select("id", "name", "email").
    Where("age > 18").
    Where("active = true").
    Limit(10).
    Build()
```

## Singleton Pattern

**Single instance (use sparingly):**
```go
type Database struct {
    connection *sql.DB
}

var (
    instance *Database
    once     sync.Once
)

func GetDatabase() *Database {
    once.Do(func() {
        instance = &Database{
            connection: initConnection(),
        }
    })
    return instance
}
```

## Decorator Pattern

**Add behavior to functions:**
```go
type Handler func(http.ResponseWriter, *http.Request)

func LoggingMiddleware(next Handler) Handler {
    return func(w http.ResponseWriter, r *http.Request) {
        start := time.Now()
        log.Printf("Started %s %s", r.Method, r.URL.Path)
        
        next(w, r)
        
        log.Printf("Completed in %v", time.Since(start))
    }
}

func AuthMiddleware(next Handler) Handler {
    return func(w http.ResponseWriter, r *http.Request) {
        token := r.Header.Get("Authorization")
        if !isValid(token) {
            http.Error(w, "Unauthorized", http.StatusUnauthorized)
            return
        }
        next(w, r)
    }
}

// Usage
handler := LoggingMiddleware(AuthMiddleware(myHandler))
```

## Strategy Pattern

**Interchangeable algorithms:**
```go
type SortStrategy interface {
    Sort([]int)
}

type BubbleSort struct{}

func (BubbleSort) Sort(data []int) {
    // bubble sort implementation
}

type QuickSort struct{}

func (QuickSort) Sort(data []int) {
    // quick sort implementation
}

type Sorter struct {
    strategy SortStrategy
}

func (s *Sorter) SetStrategy(strategy SortStrategy) {
    s.strategy = strategy
}

func (s *Sorter) Sort(data []int) {
    s.strategy.Sort(data)
}

// Usage
sorter := &Sorter{}
sorter.SetStrategy(QuickSort{})
sorter.Sort(data)
```

## Observer Pattern

**Event notification:**
```go
type Observer interface {
    Update(event Event)
}

type Subject struct {
    observers []Observer
    mu        sync.RWMutex
}

func (s *Subject) Attach(o Observer) {
    s.mu.Lock()
    defer s.mu.Unlock()
    s.observers = append(s.observers, o)
}

func (s *Subject) Detach(o Observer) {
    s.mu.Lock()
    defer s.mu.Unlock()
    // remove observer
}

func (s *Subject) Notify(event Event) {
    s.mu.RLock()
    defer s.mu.RUnlock()
    for _, observer := range s.observers {
        go observer.Update(event)  // async notification
    }
}
```

## Circuit Breaker Pattern

**Prevent cascading failures:**
```go
type State int

const (
    StateClosed State = iota
    StateOpen
    StateHalfOpen
)

type CircuitBreaker struct {
    maxFailures int
    timeout     time.Duration
    failures    int
    state       State
    lastFailure time.Time
    mu          sync.Mutex
}

func (cb *CircuitBreaker) Call(fn func() error) error {
    cb.mu.Lock()
    defer cb.mu.Unlock()
    
    // Check state
    if cb.state == StateOpen {
        if time.Since(cb.lastFailure) > cb.timeout {
            cb.state = StateHalfOpen
        } else {
            return errors.New("circuit breaker open")
        }
    }
    
    // Execute
    err := fn()
    
    if err != nil {
        cb.failures++
        cb.lastFailure = time.Now()
        
        if cb.failures >= cb.maxFailures {
            cb.state = StateOpen
        }
        return err
    }
    
    // Success
    if cb.state == StateHalfOpen {
        cb.state = StateClosed
    }
    cb.failures = 0
    return nil
}
```

## Retry Pattern

**Retry with exponential backoff:**
```go
func RetryWithBackoff(
    ctx context.Context,
    maxRetries int,
    fn func() error,
) error {
    var err error
    
    for i := 0; i < maxRetries; i++ {
        if err = fn(); err == nil {
            return nil
        }
        
        // Exponential backoff
        backoff := time.Duration(1<<uint(i)) * time.Second
        
        select {
        case <-time.After(backoff):
            // Continue to next retry
        case <-ctx.Done():
            return ctx.Err()
        }
    }
    
    return fmt.Errorf("max retries exceeded: %w", err)
}
```

## Graceful Shutdown Pattern

**Clean service shutdown:**
```go
func main() {
    server := &http.Server{Addr: ":8080"}
    
    // Start server
    go func() {
        if err := server.ListenAndServe(); err != http.ErrServerClosed {
            log.Fatal(err)
        }
    }()
    
    // Wait for interrupt signal
    quit := make(chan os.Signal, 1)
    signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
    <-quit
    
    // Graceful shutdown
    ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
    defer cancel()
    
    if err := server.Shutdown(ctx); err != nil {
        log.Fatal("Server forced to shutdown:", err)
    }
    
    log.Println("Server exiting")
}
```

## Rate Limiting Pattern

**Control request rate:**
```go
import "golang.org/x/time/rate"

type RateLimiter struct {
    limiter *rate.Limiter
}

func NewRateLimiter(rps int) *RateLimiter {
    return &RateLimiter{
        limiter: rate.NewLimiter(rate.Limit(rps), rps),
    }
}

func (rl *RateLimiter) Allow() bool {
    return rl.limiter.Allow()
}

func (rl *RateLimiter) Wait(ctx context.Context) error {
    return rl.limiter.Wait(ctx)
}

// Usage in handler
limiter := NewRateLimiter(100)  // 100 requests per second

func handler(w http.ResponseWriter, r *http.Request) {
    if !limiter.Allow() {
        http.Error(w, "Rate limit exceeded", http.StatusTooManyRequests)
        return
    }
    // Handle request
}
```

## Semaphore Pattern

**Limit concurrent operations:**
```go
type Semaphore struct {
    sem chan struct{}
}

func NewSemaphore(max int) *Semaphore {
    return &Semaphore{
        sem: make(chan struct{}, max),
    }
}

func (s *Semaphore) Acquire() {
    s.sem <- struct{}{}
}

func (s *Semaphore) Release() {
    <-s.sem
}

// Usage
sem := NewSemaphore(3)  // max 3 concurrent

for i := 0; i < 10; i++ {
    sem.Acquire()
    go func(id int) {
        defer sem.Release()
        processTask(id)
    }(i)
}
```

## Object Pool Pattern (Extended)

**Advanced pool with metrics:**
```go
type ObjectPool struct {
    pool    sync.Pool
    new     func() interface{}
    reset   func(interface{})
    metrics struct {
        gets int64
        puts int64
    }
}

func NewObjectPool(new func() interface{}, reset func(interface{})) *ObjectPool {
    return &ObjectPool{
        new:   new,
        reset: reset,
        pool: sync.Pool{
            New: func() interface{} {
                return new()
            },
        },
    }
}

func (p *ObjectPool) Get() interface{} {
    atomic.AddInt64(&p.metrics.gets, 1)
    return p.pool.Get()
}

func (p *ObjectPool) Put(obj interface{}) {
    if p.reset != nil {
        p.reset(obj)
    }
    atomic.AddInt64(&p.metrics.puts, 1)
    p.pool.Put(obj)
}
```

## Learning Path

### Basic Level
- Functional options
- Context usage
- Basic pipeline
- Simple worker pool
- Graceful shutdown

### Intermediate Level
- Builder pattern
- Middleware/decorators
- Circuit breaker
- Retry with backoff
- Rate limiting

### Advanced Level
- Complex pipeline patterns
- Custom context usage
- Performance-critical pools
- Advanced concurrency patterns
- System design patterns

## Best Practices

1. **Accept interfaces, return structs**
2. **Make the zero value useful**
3. **Use context for cancellation**
4. **Functional options for flexibility**
5. **Defer for cleanup**
6. **Channel ownership clear**
7. **Prefer composition over inheritance**

## Common Pitfalls

1. **Context in structs** - Pass as parameter
2. **Premature optimization** - Profile first
3. **Over-engineering** - Keep it simple
4. **Ignoring context cancellation**
5. **Complex inheritance trees** - Use composition
6. **Not closing channels** - Sender's responsibility
7. **Circular dependencies** - Refactor

## Comparison to C++ Patterns

**C++:**
- RAII for resource management
- Template metaprogramming
- Multiple inheritance
- Virtual functions for polymorphism

**Go:**
- Defer for cleanup
- Interfaces for polymorphism
- Composition over inheritance
- Channels for communication
- Simpler, more explicit

## Practice Context

Focus on:
- Building production services
- Implementing common patterns
- Context propagation
- Graceful error handling
- Performance optimization
- Code organization
- Testing patterns
- Maintainable architecture
