module Day17

using ..Utils
using OffsetArrays

adjacent_offsets_3 = [(dx, dy, dz) for dx in -1:1 for dy in -1:1 for dz in -1:1 if !(dx == 0 && dy == 0 && dz == 0)]
adjacent_offsets_4 = [(dx, dy, dz, dw) for dx in -1:1 for dy in -1:1 for dz in -1:1 for dw in -1:1 if !(dx == 0 && dy == 0 && dz == 0 && dw == 0)]

function active_count(space)
    return count(c -> c == '#', space)
end

function day17(; part::Int=2, example::Bool=false)
    grid = read_map(17; example)

    if part == 1
        day17_part1(grid)
    elseif part == 2
        day17_part2(grid)
    end
end

function day17_part1(grid)
#    print_map(grid)
    space = create_space_3(grid)
#    println("Initial active count: ", active_count(space))
    for i in 1:6
        space = next_3(space)
#        println("$i: Active count: ", active_count(space))
    end
    println("Answer: $(active_count(space))")
end

function day17_part2(grid)
#    print_map(grid)
    space = create_space_4(grid)
#    println("Initial active count: ", active_count(space))
    for i in 1:6
        space = next_4(space)
#        println("$i: Active count: ", active_count(space))
    end
    println("Answer: $(active_count(space))")
end

function create_space_3(grid)
    expansion = 8
    map_size = size(grid, 1)
    space_size = map_size + 2 * expansion
    half = map_size ÷ 2
    space_range = -half - expansion:-half + map_size + expansion - 1
    space = OffsetArray(fill('.', space_size, space_size, space_size), space_range, space_range, space_range)
    for row in axes(grid, 1)
        for col in axes(grid, 2)
            space[row - half, col - half, 0] = grid[row, col]
        end
    end

    return space
end

function count_neighbors_3(space, x, y, z)
    neighbor_count = 0
    for (dx, dy, dz) in adjacent_offsets_3
        if space[x + dx, y + dy, z + dz] == '#'
            neighbor_count += 1
        end
    end
    return neighbor_count
end

function next_3(space)
    new_space = deepcopy(space)
    for x in first(axes(space, 1))+1:last(axes(space, 1))-1
        for y in first(axes(space, 2))+1:last(axes(space, 2))-1
            for z in first(axes(space, 3))+1:last(axes(space, 3))-1
                active_neighbors = count_neighbors_3(space, x, y, z)

                if space[x, y, z] == '#'
                    if !(active_neighbors == 2 || active_neighbors == 3)
                        new_space[x, y, z] = '.'
                    end
                else
                    if active_neighbors == 3
                        new_space[x, y, z] = '#'
                    end
                end
            end
        end
    end
    return new_space
end

function create_space_4(grid)
    expansion = 8
    map_size = size(grid, 1)
    space_size = map_size + 2 * expansion
    half = map_size ÷ 2
    space_range = -half - expansion:-half + map_size + expansion - 1
    space = OffsetArray(fill('.', space_size, space_size, space_size, space_size), space_range, space_range, space_range, space_range)
    for row in axes(grid, 1)
        for col in axes(grid, 2)
            space[row - half, col - half, 0, 0] = grid[row, col]
        end
    end

    return space
end

function count_neighbors_4(space, x, y, z, w)
    neighbor_count = 0
    for (dx, dy, dz, dw) in adjacent_offsets_4
        if space[x + dx, y + dy, z + dz, w + dw] == '#'
            neighbor_count += 1
        end
    end
    return neighbor_count
end

function next_4(space)
    new_space = deepcopy(space)
    for x in first(axes(space, 1))+1:last(axes(space, 1))-1
        for y in first(axes(space, 2))+1:last(axes(space, 2))-1
            for z in first(axes(space, 3))+1:last(axes(space, 3))-1
                for w in first(axes(space, 4))+1:last(axes(space, 4))-1
                    active_neighbors = count_neighbors_4(space, x, y, z, w)
                    if space[x, y, z, w] == '#'
                        if !(active_neighbors == 2 || active_neighbors == 3)
                            new_space[x, y, z, w] = '.'
                        end
                    else
                        if active_neighbors == 3
                            new_space[x, y, z, w] = '#'
                        end
                    end
                end
            end
        end
    end
    return new_space
end


export day17

end
