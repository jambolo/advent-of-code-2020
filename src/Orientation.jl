module Orientation

const RIGHT = 1
const TOP = 2
const LEFT = 3
const BOTTOM = 4
const NUM_DIRECTIONS = 4
const FLIP_OFFSET = 4
const NUM_ORIENTATIONS = 8

function is_flipped(orientation::Int)
    return orientation > FLIP_OFFSET
end

function opposite_direction(direction::Int)
    return mod1(direction + 2, NUM_DIRECTIONS)
end

function get_orientation(side::Int, facing::Int, flipped::Bool)
    if flipped
        orientation = mod1(facing + side - 1, NUM_DIRECTIONS) + FLIP_OFFSET
    else
        orientation = mod1(facing - side + 1, NUM_DIRECTIONS)
    end

    return orientation
end

function get_facing(side::Int, orientation::Int)
    if is_flipped(orientation)
        facing = mod1(orientation - side + 1, NUM_DIRECTIONS)
    else
        facing = mod1(orientation + side - 1, NUM_DIRECTIONS)
    end

    return facing
end

function get_side(facing::Int, orientation::Int)
    if is_flipped(orientation)
        side = mod1(orientation - facing + 1, NUM_DIRECTIONS)
    else
        side = mod1(facing - orientation + 1, NUM_DIRECTIONS)
    end
    return side
end

export RIGHT, TOP, LEFT, BOTTOM, NUM_DIRECTIONS, FLIP_OFFSET, NUM_ORIENTATIONS
export get_orientation, get_facing, get_side, is_flipped, opposite_direction

end
