module Day20

using ..Utils
using ..Orientation

const MONSTER_HEIGHT = 3
const MONSTER_WIDTH = 19
const TILE_SIZE = 10
const DST_TILE_SIZE = TILE_SIZE - 2

# Offsets to match the sea monster pattern in the image
#              1111111111
#    01234567890123456789
# 0 |                  #
# 1 |#    ##    ##    ###
# 2 | #  #  #  #  #  #
const MONSTER = [(0,18),(1,0),(1,5),(1,6),(1,11),(1,12),(1,17),(1,18),(1,19),(2,1),(2,4),(2,7),(2,10),(2,13),(2,16)]

# Map indicating how the sides of a tile are flipped based on the orientation
# Note: for efficiency, the row is the orientation and the column is the side index
const FLIPPED_SIDE_MAP::Matrix{Int} = [
    1 1 1 1;
    1 2 1 2;
    2 2 2 2;
    2 1 2 1;
    2 1 2 1;
    2 2 2 2;
    1 2 1 2;
    1 1 1 1
]

@enum TileType UNKNOWN_TILE_TYPE = 0 CORNER = 1 SIDE = 2 INNER = 3

mutable struct Tile
    id::Int
    pixels::Matrix{Char}
    # each side is represented as a tuple of two integers, the normal and flipped value
    sides::Vector{Tuple{Int,Int}}
    # for each side, a vector of tuples of matching tile indexes and their side indexes matching this side
    matches::Vector{Vector{Tuple{Int,Int}}}
    type::TileType
end

function day20(; part::Int=2, example::Bool=false)
    IMAGE_SIZE = example ? 3 : 12
    lines = read_lines(20; example)

    tiles = Vector{Tile}()

    for i in 1:IMAGE_SIZE^2
        # Each section is 12 lines: one line for the tile ID and 10 lines for the tile pixels plus one blank line
        start_index = (i - 1) * 12 + 1
        push!(tiles, parse_tile(lines, start_index))
    end

    # For each tile, find which other tiles it can match with on each side
    match_up_tiles!(tiles)

    if part == 1
        day20_part1(tiles, IMAGE_SIZE)
    elseif part == 2
        day20_part2(tiles, IMAGE_SIZE)
    end
end

function parse_tile(lines::Vector{String}, start_index::Int)
    id = parse(Int, split(lines[start_index], " ")[2][1:end-1])
    top = parse_side(lines[start_index + 1])
    bottom = parse_side(lines[start_index + TILE_SIZE])
    left = parse_side([lines[start_index + i][1] for i in 1:TILE_SIZE])
    right = parse_side([lines[start_index + i][end] for i in 1:TILE_SIZE])
    sides = [(right, reverse_bits(right)), (top, reverse_bits(top)), (left, reverse_bits(left)), (bottom, reverse_bits(bottom))]
    pixels = stack(collect.(lines[start_index + 1:start_index + TILE_SIZE]); dims=1)
    return Tile(id, pixels, sides, Vector{Tuple{Int,Int}}[], UNKNOWN_TILE_TYPE)
end

function parse_side(line::Union{String, Vector{Char}})
    return foldl((acc, c) -> (acc << 1) | (c == '#' ? 1 : 0), line, init=0)
end

function reverse_bits(value::Int)
    result = 0
    for _ in 1:TILE_SIZE
        result = (result << 1) | (value & 1)
        value >>= 1
    end
    return result
end

function match_up_tiles!(tiles::Vector{Tile})
    # For each tile, check each side against every other tile to see if it can match
    # either normally or flipped. Record the matches for each side and determine the
    # tile type based on how many sides do not match any other tile.

    for i in 1:length(tiles)
        tile = tiles[i]
        unmatched_sides = 0
        for side_index in 1:NUM_DIRECTIONS
            matches = Vector{Tuple{Int,Int}}()
            side_value, flipped_side_value = tile.sides[side_index]
            for j in 1:length(tiles)
                if i == j
                    continue
                end
                other_tile = tiles[j]
                for other_side_index in 1:NUM_DIRECTIONS
                    other_side_value, other_flipped_side_value = other_tile.sides[other_side_index]
                    if side_value == other_side_value ||
                       side_value == other_flipped_side_value ||
                       flipped_side_value == other_side_value ||
                       flipped_side_value == other_flipped_side_value
                        push!(matches, (j, other_side_index))
                    end
                end
            end
            push!(tiles[i].matches, matches)
            if isempty(matches)
                unmatched_sides += 1
            end
        end
        if unmatched_sides == 2
            tiles[i].type = CORNER
        elseif unmatched_sides == 1
            tiles[i].type = SIDE
        else
            tiles[i].type = INNER
        end
    end
end

function day20_part1(tiles::Vector{Tile}, image_size::Int)
    # Turns out there are four tiles with two sides that do not match any other tile. They must be the corner tiles
    # because they can't go anywhere else
    corners = [tile.id for tile in tiles if tile.type == CORNER]
    result = prod(corners)
    println("Answer: $result")
end

function day20_part2(tiles::Vector{Tile}, image_size::Int)
    # Assemble the tiles into the full image layout
    layout = build_layout(tiles, image_size)

    # Create an assembled image from the tile layout
    image = assemble_image_from_layout(tiles, layout, image_size)

    # There are 94 starting columns for the sea monster pattern in the image, 117 starting rows, and 8 orientations, for a total of
    # 94 * 117 * 8 = 87984 possible positions to check. Each position requires 15 accesses, so that's 87984 * 15 = 1,319,760
    # accesses — not bad.

    found = false

    # Check un-flipped orientations
    for _ in 1:NUM_DIRECTIONS
        if monsters_found(image)
            found = true
            break
        end
        image = rotl90(image)
    end

    if !found
        # Flip the image vertically (it's arbitrary since we don't track the orientation)
        reverse!(image, dims=1)

        # Check flipped orientations
        for _ in 1:NUM_DIRECTIONS
            if monsters_found(image)
                found = true
                break
            end
            image = rotl90(image)
        end
    end

    mark_monsters!(image)
    result = count(x -> x == '#', image)
    println("Answer: $result")
end

function build_layout(tiles::Vector{Tile}, image_size::Int)
    # Recursively place tiles in the layout starting from the top-left corner

    # 2D array of (tile index, orientation)
    tile_layout = Matrix{Tuple{Int,Int}}(undef, image_size, image_size)

    # Find a corner tile for the top-left position
    first_tile = findfirst(tile -> tile.type == CORNER, tiles)
    @assert first_tile !== nothing "No corner tile found"

    ok = try_placing!(tile_layout, tiles, first_tile, 1, 1, Set(1:image_size^2), image_size)
    @assert ok "Failed to build a valid tile layout"

    return tile_layout
end

function try_placing!(
    tile_layout::Matrix{Tuple{Int,Int}},
    tiles::Vector{Tile},
    tile_index::Int,
    row::Int,
    col::Int,
    unused_tiles::Set{Int},
    image_size::Int
)
    this_tile = tiles[tile_index]
    if (row == 1 || row == image_size) && (col == 1 || col == image_size)
        # If this position is a corner, the tile placed here must be a corner tile
        if this_tile.type != CORNER
            return false
        end
    elseif row == 1 || row == image_size || col == 1 || col == image_size
        # If this is a side position, the tile placed here must be a side tile
        if this_tile.type != SIDE
            return false
        end
    else
        # If this is an inner position, the tile placed here must be an inner tile
        if this_tile.type != INNER
            return false
        end
    end

    # Determine if the tile fits with its neighbors in the current position and determine the orientation
    if row > 1
        above_neighbor_index, above_neighbor_orientation = tile_layout[row-1, col]
        above_orientation = matching_orientation(this_tile, TOP, tiles[above_neighbor_index], above_neighbor_orientation)
        if above_orientation === nothing
            return false
        end
    else
        above_orientation = nothing # no tile above, so no top orientation to match
    end

    if col > 1
        left_neighbor_index, left_neighbor_orientation = tile_layout[row, col-1]
        left_orientation = matching_orientation(this_tile, LEFT, tiles[left_neighbor_index], left_neighbor_orientation)
        if left_orientation === nothing
            return false
        end
    else
        left_orientation = nothing # no tile to the left, so no left orientation to match
    end

    if above_orientation === nothing && left_orientation === nothing
        this_orientation = orient_first_tile(this_tile) # Orient the first tile so that unmatched sides are above and left
    elseif left_orientation === nothing
        this_orientation = above_orientation # if there is no left neighbor, the orientation is determined by the above neighbor
    elseif above_orientation === nothing
        this_orientation = left_orientation # if there is no top neighbor, the orientation is determined by the left neighbor
    elseif above_orientation == left_orientation
        this_orientation = above_orientation # if both top and left neighbors exist and their matching orientations agree, use that
    else
        return false # above and left orientations do not match. Can't place tile here
    end

    # Place the tile in the layout
    # Note: a copy is not necessary because only left and above neighbors are accessed and they are guaranteed to be placed before
    # a placement is attempted. Tiles left in the layout from failed attempts in other branches of the recursion will not
    # affect placement of a tile.
    tile_layout[row, col] = (tile_index, this_orientation)

    # If this is the last tile in the layout, we have successfully placed all tiles
    if row == image_size && col == image_size
        return true
    end

    # Make a copy of the unused tiles set so other branches of the recursion are not affected
    unused_tiles_copy = copy(unused_tiles)
    delete!(unused_tiles_copy, tile_index)

    # Decide the position of the next tile in the layout, a tile it must match, and which side of that tile it should match
    if col < image_size
        # If the next tile is in the same row, it must match the right side of the current tile
        next_row, next_col =  row, col + 1
        matching_tile_index = tile_index
        matching_side = get_side(RIGHT, this_orientation)
    else
        # The next tile starts the next row. It must match the bottom side of the tile above
        next_row, next_col = row + 1, 1
        matching_tile_index = tile_layout[row, 1][1]
        matching_tile_orientation = tile_layout[row, 1][2]
        matching_side = get_side(BOTTOM, matching_tile_orientation)
    end

    # Try to place each tile that matches the required side of the matching tile in the next position
    for (next_tile_index, _) in tiles[matching_tile_index].matches[matching_side]
        if try_placing!(tile_layout, tiles, next_tile_index, next_row, next_col, unused_tiles_copy, image_size)
            return true
        end
    end
    return false
end

function matching_orientation(this_tile::Tile, this_facing::Int, other_tile::Tile, other_orientation::Int)
    # Returns the orientation of this tile that will match the other tile
    other_facing = opposite_direction(this_facing)
    other_side_value = get_side_value(other_tile, other_facing, other_orientation)
    for this_orientation in 1:NUM_ORIENTATIONS
        if get_side_value(this_tile, this_facing, this_orientation) == other_side_value
            return this_orientation
        end
    end
    return nothing
end

function get_side_value(tile::Tile, facing::Int, orientation::Int)
    side = get_side(facing, orientation)
    flipped_index = FLIPPED_SIDE_MAP[orientation, side]
    return tile.sides[side][flipped_index]
end


function assemble_image_from_layout(tiles::Vector{Tile}, layout::Matrix{Tuple{Int,Int}}, image_size::Int)
    image = Matrix{Char}(undef, image_size * DST_TILE_SIZE, image_size * DST_TILE_SIZE)
    for tile_row in 1:image_size
        for tile_col in 1:image_size
            tile_index, orientation = layout[tile_row, tile_col]
            tile = tiles[tile_index]
            oriented_image = oriented_tile_image(tile.pixels, orientation)
            for row in 2:TILE_SIZE-1
                for col in 2:TILE_SIZE-1
                    image[(tile_row-1)*(DST_TILE_SIZE) + row - 1, (tile_col-1)*(DST_TILE_SIZE) + col - 1] = oriented_image[row, col]
                end
            end
        end
    end
    return image
end

function oriented_tile_image(pixels::Matrix{Char}, orientation::Int)
    oriented = copy(pixels)
    if is_flipped(orientation)
        reverse!(oriented, dims=1)
        orientation -= FLIP_OFFSET
    end
    if orientation > 1
        # rotate the tile according to the orientation
        return rotl90(oriented, orientation-1)
    else
        return oriented
    end
end
function orient_first_tile(tile::Tile)
    unmatched_sides = findall(isempty, tile.matches)
    if length(unmatched_sides) != 2
        error("Tile does not have exactly two unmatched sides")
    end

    first_unmatched = unmatched_sides[1]
    second_unmatched = unmatched_sides[2]

    # Try orienting the tile so that the first unmatched side is on the top
    # Note: this works regardless of flipped or not
    orientation = get_orientation(first_unmatched, TOP, false)
    # If the second unmatched side is not on the left, then the first must go on the left instead
    if get_side(LEFT, orientation) != second_unmatched
        orientation = get_orientation(first_unmatched, LEFT, false)
    end
    return orientation
end

function monsters_found(image::Matrix{Char})
    image_size_row, image_size_col = size(image)
    for row in 1:image_size_row - MONSTER_HEIGHT + 1
        for col in 1:image_size_col - MONSTER_WIDTH + 1
            if monster_found_at(image, row, col)
                return true
            end
        end
    end
    return false
end

function mark_monsters!(image::Matrix{Char})
    image_size_row, image_size_col = size(image)
    for row in 1:image_size_row-2
        for col in 1:image_size_col-19
            if monster_found_at(image, row, col)
                for (dr, dc) in MONSTER
                    image[row + dr, col + dc] = 'O'
                end
            end
        end
    end
end

function monster_found_at(image::Matrix{Char}, row::Int, col::Int)
    for (dr, dc) in MONSTER
        if image[row + dr, col + dc] != '#'
            return false
        end
    end
    return true
end

export day20

end
