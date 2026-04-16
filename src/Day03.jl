module Day03

using ..Utils

function day03(; part::Int=2, example::Bool=false)
    grid = read_lines(3; example)

    if part == 1
        day03_part1(grid)
    elseif part == 2
        day03_part2(grid)
    end
end

function day03_part1(grid)
    tree_count = traverse(grid, (3, 1))
    println("Answer: $tree_count")
end

function day03_part2(grid)
    slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
    product = prod(slope -> traverse(grid, slope), slopes)
    println("Answer: $product")
end

function traverse(grid, (delta_col, delta_row))
    height = length(grid)
    width = length(grid[1])
    i = 1
    j = 1
    tree_count = 0
    while i <= height
        row = grid[i]
        if row[j] == '#'
            tree_count += 1
        end
        i = i + delta_row
        j = (j - 1 + delta_col) % width + 1
    end
    return tree_count
end

export day03

end
