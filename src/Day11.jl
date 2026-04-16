module Day11

using ..Utils

function day11(; part::Int=2, example::Bool=false)
    grid = read_map(11; example)
    if part == 1
        day11_part1(grid)
    elseif part == 2
        day11_part2(grid)
    end
end

function day11_part1(grid)
    while true
        new_grid = copy(grid)
        changed = false
        for row in axes(grid, 1), col in axes(grid, 2)
            occupied = adjacent_occupied(grid, row, col)
            if grid[row, col] == 'L' && occupied == 0
                new_grid[row, col] = '#'
                changed = true
            elseif grid[row, col] == '#' && occupied >= 4
                new_grid[row, col] = 'L'
                changed = true
            end
        end
        changed || break
        grid = new_grid
    end
    println("Answer: $(count_occupied(grid))")
end

function day11_part2(grid)
    while true
        new_grid = copy(grid)
        changed = false
        for row in axes(grid, 1), col in axes(grid, 2)
            occupied = visibly_occupied(grid, row, col)
            if grid[row, col] == 'L' && occupied == 0
                new_grid[row, col] = '#'
                changed = true
            elseif grid[row, col] == '#' && occupied >= 5
                new_grid[row, col] = 'L'
                changed = true
            end
        end
        changed || break
        grid = new_grid
    end
    println("Answer: $(count_occupied(grid))")
end
function visibly_occupied(grid, row, col)
    count(d -> begin
        if d == (0, 0)
            return false
        end
        dr, dc = d
        r, c = row + dr, col + dc
        while checkbounds(Bool, grid, r, c)
            if grid[r, c] == '#'
                return true
            elseif grid[r, c] == 'L'
                return false
            end
            r += dr
            c += dc
        end
        false
    end,
    [(dr, dc) for dr in -1:1 for dc in -1:1])
end
function adjacent_occupied(grid, row, col)
    count(d -> d != (0, 0) &&
               checkbounds(Bool, grid, row + d[1], col + d[2]) &&
               grid[row + d[1], col + d[2]] == '#',
          [(dr, dc) for dr in -1:1 for dc in -1:1])
end

count_occupied(grid) = count(==('#'), grid)

export day11

end
