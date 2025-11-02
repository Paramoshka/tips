# Rust Pattern Matching — Quick Guide

> This README is in English (per your docs preference).

Rust’s *patterns* let you unpack values (like `Result`, `Option`, tuples, and structs) concisely and safely. This guide shows when to use `match`, `if let`, `let-else`, `while let`, and the `?` operator—plus common pitfalls and recipes.

---

## 1) `match`: handle **all** cases
Use when you need to cover every variant explicitly (or add a catch‑all with `_`).

```rust
match r: Result<i32, E> {
    Ok(val) => {
        println!("{val}");
    }
    Err(err) => {
        eprintln!("{err}");
    }
}
```

- Exhaustive by default (great for correctness).
- Can add **guards** (conditions) per arm:
  ```rust
  match r {
      Ok(v) if v > 0 => println!("positive"),
      Ok(_)          => println!("zero or negative"),
      Err(e)         => eprintln!("{e}"),
  }
  ```

---

## 2) `if let`: care about **one** case
Use when you only act on one pattern and ignore the rest (optionally with `else`).

```rust
if let Ok(val) = r {
    println!("{val}");
} else {
    // runs when r is Err(...)
}
```

Also works with `Option`:
```rust
if let Some(x) = maybe {
    println!("{x}");
}
```

### Let-chains (multiple patterns in one `if`)
Stable in modern Rust; handy to require several matches at once:
```rust
if let Some(a) = a_opt && let Some(b) = b_opt {
    println!("{a} {b}");
}
```

> Alternative without let-chains:
> ```rust
> if let (Some(a), Some(b)) = (a_opt, b_opt) { /* ... */ }
> ```

---

## 3) `let PATTERN = expr else { ... };` (aka **let-else**)
“Unpack or bail”: if the pattern doesn’t match, the `else` block runs and the current control flow *exits* that path (e.g., `return`, `break`, `continue`, or panic).

```rust
let Ok(val) = r else {
    // r was Err(...)
    return;
};
println!("{val}");
```

With `Option`:
```rust
let Some(x) = maybe else {
    return Err("missing value".into());
};
use_it(x);
```

> Why not `let Ok(val) = r;`? Because it’s a **refutable** pattern (could fail). Use `if let`, `let-else`, or `match` instead.

---

## 4) `while let`: loop while pattern keeps matching
Great for streaming/iterators.

```rust
while let Some(item) = iter.next() {
    println!("{item}");
}
```

---

## 5) The `?` operator: “unpack or return the error”
Short-circuits on failure for `Result` (and on `None` for `Option` when the function returns `Option`).

```rust
fn run() -> Result<(), E> {
    let val = compute()?; // if Err(e), returns Err(e) immediately
    println!("{val}");
    Ok(())
}
```

Roughly equivalent to:
```rust
let val = match compute() {
    Ok(v) => v,
    Err(e) => return Err(e),
};
```

For `Option` in a function returning `Option<T>`:
```rust
let x = maybe_x?; // turns None into early return None
```

---

## 6) Patterns beyond `Result`/`Option`
Unpack tuples and structs directly:

```rust
let (a, b) = pair;
let Point { x, y } = p;
```

These are **irrefutable** (always match), so they’re allowed in plain `let` bindings.

---

## 7) Ownership & borrowing tips
- `match r` **moves** `r` by default. To just peek, match by reference:
  ```rust
  match &r {
      Ok(v)  => println!("borrowed: {v}"),
      Err(e) => eprintln!("{e}"),
  }
  ```
- In patterns, use `ref`/`ref mut` or `&` bindings to borrow fields without moving:
  ```rust
  match r {
      Ok(ref v) => println!("ref to v: {v}"),
      Err(e)    => eprintln!("{e}"),
  }
  ```

---

## 8) Common pitfalls
- **Refutable patterns in `let`**: `let Ok(v) = r;` won’t compile. Use `if let`, `let-else`, or `match`.
- **Forgetting `else`** with `if let` when you *must* handle the other branch.
- **Accidentally moving values** in `match`. Borrow with `&` if you need to reuse them.
- **Shadowing**: reusing variable names in different arms can hide previous bindings—do it intentionally.

---

## 9) Quick recipes (copy‑paste)
| Task | Tool | Snippet |
|---|---|---|
| Handle all variants | `match` | `match r { Ok(v) => ..., Err(e) => ... }` |
| Do something only on success | `if let` | `if let Ok(v) = r { ... }` |
| Early-exit if pattern fails | `let-else` | `let Ok(v) = r else { return; };` |
| Consume stream while items exist | `while let` | `while let Some(x) = it.next() { ... }` |
| Bubble up errors | `?` | `let v = f()?;` |

---

## 10) One example in 4 styles

Say we want to parse an env var `PORT: String -> u16` and log different messages.

### a) `match`
```rust
fn port_from_env_match(s: &str) -> Result<u16, std::num::ParseIntError> {
    match s.parse::<u16>() {
        Ok(p) => Ok(p),
        Err(e) => Err(e),
    }
}
```

### b) `if let`
```rust
fn port_from_env_iflet(s: &str) -> Result<u16, std::num::ParseIntError> {
    if let Ok(p) = s.parse::<u16>() {
        Ok(p)
    } else {
        Err("not a number".parse().unwrap_err()) // example only; prefer `?` form below
    }
}
```

### c) `let-else`
```rust
fn port_from_env_letelse(s: &str) -> Result<u16, std::num::ParseIntError> {
    let Ok(p) = s.parse::<u16>() else {
        // could log here, then:
        return "not a number".parse().map_err(|e| e);
    };
    Ok(p)
}
```

### d) Idiomatic with `?`
```rust
fn port_from_env(s: &str) -> Result<u16, std::num::ParseIntError> {
    let p: u16 = s.parse()?;
    Ok(p)
}
```

> In real code you’d likely do `std::env::var("PORT")?.parse::<u16>()?;` and handle domain-specific defaults separately.

---

## 11) TL;DR
- Use **`match`** for full, explicit handling (readability & safety).
- Use **`if let`** for a single interesting branch.
- Use **`let-else`** when you want to **bind** on success and **early‑exit** on failure.
- Use **`while let`** for streaming/iterators.
- Use **`?`** to bubble errors (or `None`) up ergonomically.

Happy matching! 🦀
