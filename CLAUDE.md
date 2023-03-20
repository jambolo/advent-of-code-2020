# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Language and Environment

- Solutions implemented in Julia
- Development environment: VS Code and Ubuntu via WSL
- 1-based indexing (Julia convention)

## Project Structure

```
  advent-of-code-2020/
  ├── Project.toml             # Package manifest
  ├── aoc                      # CLI runner (executable)
  ├── src/
  │   ├── AdventOfCode2020.jl  # Main module
  │   ├── Utils.jl             # Shared utilities
  │   └── Day01.jl - Day10.jl  # Solution modules
  └── inputs/
      ├── dayXX-input.txt      # Actual puzzle input
      └── dayXX-example.txt    # Example/test data
```

## Running Solutions

```bash
./aoc <day> [--part <1|2>] [--example]
```

**Options:**

- `--part <1|2>`: Select which part to run (default: 2)
- `--example`: Use example input instead of actual input

**Examples:**

```bash
./aoc 3              # Run day 3, part 2, actual input
./aoc 3 --part 1     # Run day 3, part 1, actual input
./aoc 3 --example    # Run day 3, part 2, example input
```

## Code Patterns

- Each day is a module: `module DayXX`
- Entry function: `dayXX(; part::Int=2, example::Bool=false)`
- Input reading uses `joinpath(@__DIR__, "..", "inputs", filename)`
- Solutions print results to stdout
- Answers documented in README.md

## Julia Quirks in This Codebase

- Watch for global namespace collisions with Julia library names
- Use `haskey()` before accessing Dict elements to avoid errors
- Array indexing is 1-based, complicates modular arithmetic
- Type annotations used for clarity: `Array{Int64, 1}`, `Dict{Int64, Int64}`
