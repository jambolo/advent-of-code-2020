module Day03

using ..Utils

function day03(; part::Int=2, example::Bool=false)
    map = read_lines(3; example)

    if part == 1
        day03_part1(map)
    elseif part == 2
        day03_part2(map)
    end
end

function day03_part1(map)
    count = traverse(map, (3, 1))
    println("Day 3, part 1: $count trees.")
end

function day03_part2(map)
    slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
    product = prod(slope -> traverse(map, slope), slopes)
    println("Day 3, part 2: $product trees.")
end

function traverse(map, (dj, di))
    height = length(map)
    width = length(map[1])
    i = 1
    j = 1
    count = 0
    while i <= height
        line = map[i]
        if line[j] == '#'
            count += 1
        end
        i = i + di
        j = (j - 1 + dj) % width + 1
    end
    return count
end

export day03

end
