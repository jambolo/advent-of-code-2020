module Day24

using ..Utils

export day24

@enum Direction E NE NW W SW SE

const Path = Vector{Direction}
const Position = Tuple{Int, Int}
const TileList = Dict{Position, Bool}

function day24(; part::Int=2, example::Bool=false)
    lines = read_lines(24; example)
    path_list = [parse_directions(line) for line in lines]
    if part == 1
        day24_part1(path_list)
    else
        day24_part2(path_list)
    end
end

function day24_part1(path_list::Vector{Path})
    tiles = initialize_tiles(path_list)
    result = count(values(tiles))
    println("Answer: $result")
end

function day24_part2(path_list::Vector{Path})
    NUMBER_OF_DAYS = 100
    tiles = initialize_tiles(path_list)
    for day in 1:NUMBER_OF_DAYS
        to_flip = Set{Position}()
        for tile in keys(tiles)
            # If the tile should flip, add it to the set of tiles to flip
            if should_flip(tile, tiles)
                push!(to_flip, tile)
            end
            # If any neighboring tiles not already in the tile list should flip, add them to the set of tiles to flip
            for neighbor in get_neighbors(tile)
                if !haskey(tiles, neighbor) && should_flip(neighbor, tiles)
                    push!(to_flip, neighbor)
                end
            end
        end
        for tile in to_flip
            tiles[tile] = !get(tiles, tile, false)
        end
#        println("Day $day: $(count(values(tiles))) black tiles")
    end

    result = count(values(tiles))
    println("Answer: $result")
end

function parse_directions(line::String)::Path
    path = Path()
    i = 1
    while i <= length(line)
        if line[i] == 'e'
            push!(path, E)
            i += 1
        elseif line[i] == 'w'
            push!(path, W)
            i += 1
        elseif line[i] == 'n'
            if line[i+1] == 'e'
                push!(path, NE)
                i += 2
            elseif line[i+1] == 'w'
                push!(path, NW)
                i += 2
            else
                error("Invalid direction in line: $line")
            end
        elseif line[i] == 's'
            if line[i+1] == 'e'
                push!(path, SE)
                i += 2
            elseif line[i+1] == 'w'
                push!(path, SW)
                i += 2
            else
                error("Invalid direction in line: $line")
            end
        else
            error("Invalid character in line: $line")
        end
    end
    return path
end

function initialize_tiles(path_list::Vector{Path})::TileList
    tiles = TileList()
    for path in path_list
        destination = follow_directions((0, 0), path)
        tiles[destination] = !get(tiles, destination, false)
    end
    return tiles
end

function follow_directions(position::Position, path::Path)::Position
    for direction in path
        position = move(position, direction)
    end
    return position
end

function move((x, y)::Position, direction::Direction)::Position
    if direction == E
        return x + 1, y
    elseif direction == NE
        return x, y + 1
    elseif direction == NW
        return x - 1, y + 1
    elseif direction == W
        return x - 1, y
    elseif direction == SW
        return x, y - 1
    elseif direction == SE
        return x + 1, y - 1
    else
        error("Invalid direction: $direction")
    end
end

function should_flip(tile::Position, tiles::TileList)::Bool
    is_black = get(tiles, tile, false)
    black_neighbors = count_black_neighbors(tile, tiles)
    if is_black
        return black_neighbors == 0 || black_neighbors > 2
    else
        return black_neighbors == 2
    end
end

function count_black_neighbors(tile::Position, tiles::TileList)::Int
    return count(get(tiles, neighbor, false) for neighbor in get_neighbors(tile))
end

function get_neighbors((x, y)::Position)::Vector{Position}
    return [
        (x + 1, y),     # E
        (x, y + 1),     # NE
        (x - 1, y + 1), # NW
        (x - 1, y),     # W
        (x, y - 1),     # SW
        (x + 1, y - 1)  # SE
    ]
end



end # module Day24
