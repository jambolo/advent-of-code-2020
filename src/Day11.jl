module Day11

using ..Utils

function day11(; part::Int=2, example::Bool=false)
    map = read_map(11; example)
    if part == 1
        day11_part1(map)
    elseif part == 2
        day11_part2(map)
    end
end

function day11_part1(map)
    while true
        new_map = copy(map)
        changed = false
        for row in axes(map, 1), col in axes(map, 2)
            occupied = adjacent_occupied(map, row, col)
            if map[row, col] == 'L' && occupied == 0
                new_map[row, col] = '#'
                changed = true
            elseif map[row, col] == '#' && occupied >= 4
                new_map[row, col] = 'L'
                changed = true
            end
        end
        changed || break
        map = new_map
    end
    println("Day 11, part 1: Occupied seats = ", count_occupied(map))
end

function day11_part2(map)
    while true
        new_map = copy(map)
        changed = false
        for row in axes(map, 1), col in axes(map, 2)
            occupied = visibly_occupied(map, row, col)
            if map[row, col] == 'L' && occupied == 0
                new_map[row, col] = '#'
                changed = true
            elseif map[row, col] == '#' && occupied >= 5
                new_map[row, col] = 'L'
                changed = true
            end
        end
        changed || break
        map = new_map
    end
    println("Day 11, part 2: Occupied seats = ", count_occupied(map))
end
function visibly_occupied(map, row, col)
    count(d -> begin
        if d == (0, 0)
            return false
        end
        dr, dc = d
        r, c = row + dr, col + dc
        while checkbounds(Bool, map, r, c)
            if map[r, c] == '#'
                return true
            elseif map[r, c] == 'L'
                return false
            end
            r += dr
            c += dc
        end
        false
    end,
    [(dr, dc) for dr in -1:1 for dc in -1:1])
end
function adjacent_occupied(map, row, col)
    count(d -> d != (0, 0) &&
               checkbounds(Bool, map, row + d[1], col + d[2]) &&
               map[row + d[1], col + d[2]] == '#',
          [(dr, dc) for dr in -1:1 for dc in -1:1])
end

count_occupied(map) = count(==('#'), map)

export day11

end
