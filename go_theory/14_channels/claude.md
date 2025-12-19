# Task: Create Go Channels Theory

## Your Mission
Explain channels - Go's most unique feature for concurrent communication.

## What to Create
Comprehensive theory on:
- Channels as first-class type (no C++ equivalent)
- Built-in language support (vs library-based queues)
- Typed communication (type safety)
- Unbuffered channels (synchronous rendezvous)
- Buffered channels (vs bounded queues)
- Channel operations: send (<-), receive, close
- Blocking semantics (vs C++ condition variables)
- Select statement (vs epoll/select, unique to Go)
- Non-blocking operations with default case
- Range over channels (elegant consumption pattern)
- Channel directions in signatures (send-only, receive-only)
- Closing channels semantics and broadcast
- Common patterns: pipelines, fan-out, fan-in, worker pools

## Design Elegance Discussion
- How channels implement CSP model
- Simplicity vs C++ condition variables and mutexes
- When to use channels vs mutexes?
- Select statement power (multiplexing communication)
- Channel closing as broadcast mechanism
- Pipeline patterns impossible in C++

## Structure
Theory.md with rich channel pattern examples.
