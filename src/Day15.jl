module Day15

using ..Utils

function day15(; part::Int=2, example::Bool=false)
    start = read_comma_separated_ints(15; example)

    if part == 1
        day15_part1(start)
    elseif part == 2
        day15_part2(start)
    end
end

function day15_part1(start)
    numbers = copy(start)
    initial_length = length(start)
    for turn in (initial_length + 1):2020
        last_number = numbers[end]
        repeat_indices = findall(x -> x == last_number, numbers[1:end-1])
        if isempty(repeat_indices)
            push!(numbers, 0)
        else
            push!(numbers, (turn - 1) - repeat_indices[end])
        end
    end
    println("Day 15, part 1: 2020th number is ", numbers[2020])
end

function day15_part2(start)
    # Copy the number in start into a dictionary to track last seen positions
    last_seen = Dict{Int64, Int64}()
    for (i, num) in enumerate(start)
        last_seen[num] = i
    end

    last_number = start[end]
    for turn in (length(start) + 1):30000000
        last_number_turn = turn - 1
        if haskey(last_seen, last_number)
            next_number = last_number_turn - last_seen[last_number]
        else
            next_number = 0
        end
        last_seen[last_number] = last_number_turn
        last_number = next_number
    end
    println("Day 15, part 2: 30,000,000th number is ", last_number)
end

export day15

end
