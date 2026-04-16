# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Language and Environment

- Solutions implemented in Julia 1.12
- Development environment: VS Code on Windows (Git Bash shell or WSL)
- Dependencies: OffsetArrays, Revise (see Project.toml)

## Running Solutions

```bash
./aoc <day> [--part <1|2>] [--example]
```

- `--part <1|2>`: Select which part to run (default: 2)
- `--example`: Use example input instead of actual input

```bash
./aoc 3              # Run day 3, part 2, actual input
./aoc 3 --part 1     # Run day 3, part 1, actual input
./aoc 3 --example    # Run day 3, part 2, example input
```

## Architecture

The `aoc` CLI script activates the Julia project, loads the `AdventOfCode2020` module, and dynamically dispatches to the appropriate day function.

Each day is a submodule (`module DayXX`) included from `src/AdventOfCode2020.jl`. The module exports a single entry function `dayXX(; part::Int=2, example::Bool=false)` which dispatches to `dayXX_part1(...)` / `dayXX_part2(...)`.

Shared input-reading utilities live in `src/Utils.jl`:

- `read_lines(day; example)` — returns `Vector{String}`
- `read_ints(day; example)` — parses each line as `Int64`
- `read_map(day; example)` — returns a 2D `Matrix{Char}` (rows x cols)
- `read_comma_separated_ints(day; example)` — parses CSV line
- `open_input_file(f, day; example)` — low-level file access with callback

Input files follow the naming convention `inputs/dayXX-input.txt` and `inputs/dayXX-example.txt`.

All solutions output results as `println("Answer: $result")`. Expected answers are documented in README.md.

## Adding a New Day

1. Create `src/DayXX.jl` with `module DayXX`, `using ..Utils`, entry function, and `export dayXX`. Only skeleton code. No complete solutions.
2. Add `include("DayXX.jl")`, `using .DayXX`, and `dayXX` to the export list in `src/AdventOfCode2020.jl`
3. Add input files: `inputs/dayXX-input.txt` and `inputs/dayXX-example.txt`

## Julia Quirks in This Codebase

- Array indexing is 1-based, which complicates modular arithmetic (use `mod1` or adjust offsets)
- `filter` does not accept lazy generators — use comprehensions `[... for ...]` not `(... for ...)`
- Watch for global namespace collisions with Julia stdlib names
- Use `haskey()` before accessing Dict elements that may not exist
