# Advent of Code 2020

My solutions for Advent of Code 2020 implemented in Julia. The development environment is VS Code and Ubuntu via WSL.

## Usage

Run solutions using the CLI runner:

```bash
./aoc <day> [--part <1|2>] [--example]
```

**Options:**

- `--part <1|2>`: Select which part to run (default: 2)
- `--example`: Use example input instead of actual input (default: false)

**Examples:**

```bash
./aoc 3              # Run day 3, part 2, with actual input
./aoc 3 --part 1     # Run day 3, part 1, with actual input
./aoc 3 --example    # Run day 3, part 2, with example input
./aoc 3 --part 1 --example  # Run day 3, part 1, with example input
```

## Solutions

### Day 1

Julia provides no extra benefit.

**Answers:** Part 1: `889779` | Part 2: `76110336`

### Day 2

Again no special benefit of Julia, but I'm thankful that Julia has regex support, and I like the array
functions with predicates and the fact that comparisons can be chained.

**Answers:** Part 1: `643` | Part 2: `388`

### Day 3

Modular arithmetic is a pain when dealing with array indexes because of the 1-based indexing.

**Answers:** Part 1: `169` | Part 2: `7560370818`

### Day 4

Regex support is key.

**Answers:** Part 1: `233` | Part 2: `111`

### Day 5

Basic binary conversion.

**Answers:** Part 1: `953` | Part 2: `615`

### Day 6

Support of sets in Julia helped.

**Answers:** Part 1: `6457` | Part 2: `3260`

### Day 7

Had problems with mutability and recursion in julia. I had problems with a complicated regex and a clunky IDE.

**Answers:** Part 1: `265` | Part 2: `14177`

### Day 8

Probably could have optimized, but there is no need. Waiting to get to some meaty vector reduction puzzles that can show the power of julia.

**Answers:** Part 1: `1337` | Part 2: `1358`

### Day 9

One annoyance with julia is that there are **many** library names in the global namespace that sometimes (for reasons that are not clear to me) will collide with local names.

**Answers:** Part 1: `530627549` | Part 2: `77730285`

### Day 10

Finally, a puzzle with a little bit of a challenge. Is there a way to create a Dict element initialized to 0 simply by referencing it? I could avoid having to use haskey() to know if I need to create the entry first.

**Answers:** Part 1: `2368` | Part 2: `1727094849536`

### Day 11

Coming back after a year. I have forgotten everything about Julia. Thankfully, this day is simple and AI is very helpful.

**Answers:** Part 1: `2316` | Part 2: `2128`

### Day 12

Easy again. Nothing special at all.

**Answers:** Part 1: `2879` | Part 2: `178986`

### Day 13

Modular math... cool. I could brute force it, but I bet that wouldn't be practical. Luckily, Julia has modular inverse built in! This problem seems pretty basic (Chinese Remainder Theorem), so I wouldn't be suprised if there is a library somewhere that solves it, but I implemented the solution myself.

**Answers:** Part 1: `4207` | Part 2: `725850285300475`

### Day 14

I enjoy a good bit twiddling now and again ...

**Answers:** Part 1: `6631883285184` | Part 2: `3161838538691`

### Day 15

I tried to solve it the naive way because I was feeling lazy. After all 30,000,000 isn't that much these days. Then, I realized this is O(n²). The O(n log n) method was  slightly more complicated, but much faster.

**Answers:** Part 1: `319` | Part 2: `2424`
