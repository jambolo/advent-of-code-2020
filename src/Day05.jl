module Day05

using ..Utils

function day05(; part::Int=2, example::Bool=false)
    lines = read_lines(5; example)

    if part == 1
        day05_part1(lines)
    elseif part == 2
        day05_part2(lines)
    end
end

function day05_part1(lines)
    max_id = maximum(to_id(line) for line in lines)
    println("Answer: $max_id")
end

function day05_part2(lines)
    occupied_seats = fill(false, 1024)
    for line in lines
        seat_id = to_id(line)
        occupied_seats[seat_id + 1] = true
    end

    seat_index = 1
    while !occupied_seats[seat_index]
        seat_index += 1
    end
    while occupied_seats[seat_index]
        seat_index += 1
    end

    println("Answer: $(seat_index-1)")
end

function to_id(s::String)
    seat_id = 0
    for c in s
        seat_id = seat_id << 1
        if c == 'B' || c == 'R'
            seat_id += 1
        end
    end
    return seat_id
end

export day05

end
