module Day12

using ..Utils

function day12(; part::Int=2, example::Bool=false)
    lines = read_lines(12; example)
    # parse the movements. The first character is the direction and the rest is the amount.
    # L, R: are rotations. They change the heading of the ship. They do not move the ship.
    # N, S, E, W, F: are directions of movement.
    movements = [(line[1], parse(Int, line[2:end])) for line in lines]    
    
    if part == 1
        day12_part1(movements)
    elseif part == 2
        day12_part2(movements)
    end
end

function day12_part1(movements)
    heading = (1, 0)  # initially facing east
    position = (0, 0) # starting at origin
    for m in movements
        direction, amount = m
        if direction in ('L', 'R')
            heading = turn(heading, direction, amount)
        elseif direction == 'F'
            position = move(position, heading, amount)
        else
            directions = Dict(
                'N' => (0, 1),
                'S' => (0, -1),
                'E' => (1, 0),
                'W' => (-1, 0)
            )
            # Move the position in the given direction by the given amount
            position = move(position, directions[direction], amount)
        end
    end
    println("Day 12, part 1: distance = ", abs(position[1]) + abs(position[2]))
end

function day12_part2(movements)
    waypoint = (10, 1)  # initial waypoint
    position = (0, 0)   # starting at origin
    for m in movements
        direction, amount = m
        if direction in ('L', 'R')
            waypoint = turn(waypoint, direction, amount)
        elseif direction == 'F'
            position = move(position, waypoint, amount)
        else
            directions = Dict(
                'N' => (0, 1),
                'S' => (0, -1),
                'E' => (1, 0),
                'W' => (-1, 0)
            )
            # Move the position in the given direction by the given amount
            waypoint = move(waypoint, directions[direction], amount)
        end
    end
    println("Day 12, part 2: distance = ", abs(position[1]) + abs(position[2]))
end


function move(position, heading,  amount)
    new_x = position[1] + heading[1] * amount
    new_y = position[2] + heading[2] * amount
    return (new_x, new_y)
end

#   L: turn left
#       90: (x, y) -> (-y, x)
#       180: (x, y) -> (-x, -y)
#       270: (x, y) -> (y, -x)
#   R: turn right
#       90: (x, y) -> (y, -x)
#       180: (x, y) -> (-x, -y)
#       270: (x, y) -> (-y, x)
function turn(heading, direction, amount)
    x, y = heading
    if direction == 'L'
        if amount == 90
            return (-y, x)
        elseif amount == 180
            return (-x, -y)
        elseif amount == 270
            return (y, -x)
        end
    elseif direction == 'R'
        if amount == 90
            return (y, -x)
        elseif amount == 180
            return (-x, -y)
        elseif amount == 270
            return (-y, x)
        end
    end
    return heading
end

export day12

end
