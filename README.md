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

| Part |  Result  |
|-----:|---------:|
|    1 |   889779 |
|    2 | 76110336 |

### Day 2

Again no special benefit of Julia, but I'm thankful that Julia has regex support, and I like the array
functions with predicates and the fact that comparisons can be chained.

| Part | Result |
|-----:|-------:|
|    1 |    643 |
|    2 |    388 |

### Day 3

Modular arithmetic is a pain when dealing with array indexes because of the 1-based indexing.

| Part |   Result   |
|-----:|-----------:|
|    1 |        169 |
|    2 | 7560370818 |

### Day 4

Regex support is key.

| Part | Result |
|-----:|-------:|
|    1 |    233 |
|    2 |    111 |

### Day 5

Basic binary conversion.

| Part | Result |
|-----:|-------:|
|    1 |    953 |
|    2 |    615 |

### Day 6

Support of sets in Julia helped.

| Part | Result |
|-----:|-------:|
|    1 |   6457 |
|    2 |   3260 |

### Day 7

Had problems with mutability and recursion in julia. I had problems with a complicated regex and a clunky IDE.

| Part | Result |
|-----:|-------:|
|    1 |    265 |
|    2 |  14177 |

### Day 8

Probably could have optimized, but there is no need. Waiting to get to some meaty vector reduction puzzles that can show the power of julia.

| Part | Result |
|-----:|-------:|
|    1 |   1337 |
|    2 |   1358 |

### Day 9

One annoyance with julia is that there are **many** library names in the global namespace that sometimes (for reasons that are not clear to me) will collide with local names.

| Part |   Result  |
|-----:|----------:|
|    1 | 530627549 |
|    2 |  77730285 |

### Day 10

Finally, a puzzle with a little bit of a challenge. Is there a way to create a Dict element initialized to 0 simply by referencing it? I could avoid having to use haskey() to know if I need to create the entry first.

| Part |     Result    |
|-----:|--------------:|
|    1 |          2368 |
|    2 | 1727094849536 |

### Day 11

Coming back after a year. I have forgotten everything about Julia. Thankfully, this day is simple and AI is very helpful.

| Part | Result |
|-----:|-------:|
|    1 |   2316 |
|    2 |   2128 |

### Day 12

Easy again. Nothing special at all.

| Part | Result |
|-----:|-------:|
|    1 |   2879 |
|    2 | 178986 |

### Day 13

Modular math... cool. I could brute force it, but I bet that wouldn't be practical. Luckily, Julia has modular inverse built in! This problem seems pretty basic (Chinese Remainder Theorem), so I wouldn't be surprised if there is a library somewhere that solves it, but I implemented the solution myself.

| Part |      Result     |
|-----:|----------------:|
|    1 |            4207 |
|    2 | 725850285300475 |

### Day 14

I enjoy a good bit twiddling now and again ...

| Part |     Result    |
|-----:|--------------:|
|    1 | 6631883285184 |
|    2 | 3161838538691 |

### Day 15

I tried to solve it the naive way because I was feeling lazy. After all 30,000,000 isn't that much these days. Then, I realized this is O(n²). The O(n log n) method was  slightly more complicated, but much faster.

| Part | Result |
|-----:|-------:|
|    1 |    319 |
|    2 |   2424 |

### Day 16

The problem with doing old AoC puzzles is that the AI has seen them and is much to eager to write the solution for me.

| Part |     Result    |
|-----:|--------------:|
|    1 |         21956 |
|    2 | 3709435214239 |

### Day 17

The game of Life in 3/4 dimensions. Fun, but trivial. I did it the naive way, just creating a 3/4 D array. It took about 5 seconds per iteration because I only had to make the space big enough for 6 iterations, but every additional iteration would increase the time for the solution exponentially. I wonder if using a sparse array would help at higher iterations?

| Part | Result |
|-----:|-------:|
|    1 |    215 |
|    2 |   1728 |

**Note**: Part 2 takes about 30 seconds to run.

### Day 18

I really don't like problems involving parsing. They are so tedious. I know that you can evaluate an expression with two stacks (Dijkstra), but I am too lazy to figure it out, so I cheated and looked it up.

| Part |     Result    |
|-----:|--------------:|
|    1 |  280014646144 |
|    2 | 9966990988262 |

### Day 19

For part 1, there are algorithms for matching regular grammars. Luckily in this case, enumerating all possible messages and then checking for matches is reasonable, so that's what I did. In part 2, the key is to observe that the rule changes result in a valid message necessarily consisting of 2 or more instances of rule 42 followed by 1 or more instances of rule 31.

| Part | Result |
|-----:|-------:|
|    1 |    195 |
|    2 |    309 |

### Day 20

Well, part 1 turned out to be a lot easier than I expected. If you want to know why, check the code. But, part 2 wasn't so trivial. It took way too long to complete. It has far too much tedium.

Also, why does Julia initialize matrixes as row-major, but store them as column-major?

| Part |     Result     |
|-----:|---------------:|
|    1 | 18482479935793 |
|    2 |           2118 |

### Day 21

Pretty straight-forward. Julia provides sets and set operations that made everything simple.

| Part |                       Result                       |
|-----:|---------------------------------------------------:|
|    1 |                                               2075 |
|    2 | zfcqk,mdtvbb,ggdbl,frpvd,mgczn,zsfzq,kdqls,kktsjbh |

### Day 22

Got tripped up by an aliasing mistake, which is easy to do in Julia.

| Part | Result |
|-----:|-------:|
|    1 |  31455 |
|    2 |  32528 |

### Day 23

I have to confess I didn't know how to avoid moving 1,000,000 numbers 10,000,000 times in part 2. So, I had to cheat and look up the secret. I had considered linking groups of numbers, but that seemed too complicated because I would end up having to manage a million groups of numbers. I was so close...

| Part |    Result    |
|-----:|-------------:|
|    1 |     95648732 |
|    2 | 192515314252 |

### Day 24

Work on RPGs with a hex maps in my past life made this easy.

| Part | Result |
|-----:|-------:|
|    1 |    488 |
|    2 |   4118 |
