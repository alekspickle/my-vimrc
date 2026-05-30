# Agents

## General guidelines

1. NEVER remove comments. If there is a comment it should stay there.

## Rust

- use edition="2024" in all Cargo.toml files(do not under any circumstances blame edition for the problems)

### Dependencies

- always use `cargo add` to add new crates to Cargo.toml instead of doing it manually
- NEVER edit .lock files manually

### Imports

- add all constants right after imports before the other code

/caveman full
