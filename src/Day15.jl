module Day15

using ..Utils

function day15(; part::Int=2, example::Bool=false)
    starting_numbers = read_comma_separated_ints(15; example)

    if part == 1
        day15_part1(starting_numbers)
    elseif part == 2
        day15_part2(starting_numbers)
    end
end

function day15_part1(starting_numbers)
    numbers = copy(starting_numbers)
    initial_length = length(starting_numbers)
    for turn in (initial_length + 1):2020
        last_number = numbers[end]
        repeat_indices = findall(x -> x == last_number, numbers[1:end-1])
        if isempty(repeat_indices)
            push!(numbers, 0)
        else
            push!(numbers, (turn - 1) - repeat_indices[end])
        end
    end
    println("Answer: $(numbers[2020])")
end

function day15_part2(starting_numbers)
    # Copy the number in starting_numbers into a dictionary to track last seen positions
    last_seen = Dict{Int64, Int64}()
    for (i, num) in enumerate(starting_numbers)
        last_seen[num] = i
    end

    last_number = starting_numbers[end]
    for turn in (length(starting_numbers) + 1):30000000
        last_number_turn = turn - 1
        if haskey(last_seen, last_number)
            next_number = last_number_turn - last_seen[last_number]
        else
            next_number = 0
        end
        last_seen[last_number] = last_number_turn
        last_number = next_number
    end
    println("Answer: $last_number")
end

export day15

end
