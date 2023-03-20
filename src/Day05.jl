module Day05

using ..Utils

function day05(; part::Int=2, example::Bool=false)
    lines = readinput(5; example)

    if part == 1
        day05_part1(lines)
    elseif part == 2
        day05_part2(lines)
    end
end

function day05_part1(lines)
    max_id = maximum(to_id(line) for line in lines)
    println("Day 5, part 1: highest seat ID is $max_id.")
end

function day05_part2(lines)
    occupied = fill(false, 1024)
    for line in lines
        id = to_id(line)
        occupied[id + 1] = true
    end

    i = 1
    while !occupied[i]
        i += 1
    end
    while occupied[i]
        i += 1
    end

    println("Day 5, part 2: first unoccupied seat is $(i-1).")
end

function to_id(s::String)
    v = 0
    for c in s
        v = v << 1
        if c == 'B' || c == 'R'
            v += 1
        end
    end
    return v
end

export day05

end
