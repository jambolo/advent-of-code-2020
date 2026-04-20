module Day23

using ..Utils

export day23

const EXAMPLE_INPUT = "389125467"
const INPUT = "368195742"

function day23(; part::Int=2, example::Bool=false)
    cups = parse.(Int, collect(example ? EXAMPLE_INPUT : INPUT))
    if part == 1
        day23_part1(cups; example)
    else
        day23_part2(cups; example)
    end
end

function day23_part1(cups::Vector{Int}; example::Bool=false)
    NUMBER_OF_MOVES = 100
    current_cup = cups[1]
    cup_list = create_cup_list(cups)
    for move in 1:NUMBER_OF_MOVES
        current_cup = rearrange_cups!(cup_list, current_cup)
    end

    c = 1
    result = ""
    while true
        c = cup_list[c]
        if c == 1
            break
        end
        result *= string(c)
    end
    println("Answer: $result")
end

function day23_part2(cups::Vector{Int}; example::Bool=false)
    NUMBER_OF_MOVES = 10_000_000
    cups = vcat(cups, 10:1_000_000)
    cup_list = create_cup_list(cups)
    current_cup = cups[1]
    for _ in 1:NUMBER_OF_MOVES
        current_cup = rearrange_cups!(cup_list, current_cup)
    end

    c1 = cup_list[1]
    c2 = cup_list[c1]
    result = c1 * c2
    println("Answer: $result")
end

function create_cup_list(cups::Vector{Int})::Vector{Int}
    cup_list = Vector{Int}(undef, length(cups))
    for i in 1:length(cups)
        cup_list[cups[i]] = cups[mod1(i+1, length(cups))]
    end
    return cup_list
end

function rearrange_cups!(cup_list::Vector{Int}, current_cup::Int)::Int
    maximum_cup = length(cup_list)
    r1, r2, r3 = remove_cups!(cup_list, current_cup)

    destination_cup = get_destination_cup(current_cup, maximum_cup, r1, r2, r3)
    insert_cups!(cup_list, destination_cup, r1, r2, r3)
    return cup_list[current_cup]
end

function remove_cups!(cup_list::Vector{Int}, current_cup::Int)::Tuple{Int, Int, Int}
    r1 = cup_list[current_cup]
    r2 = cup_list[r1]
    r3 = cup_list[r2]
    cup_list[current_cup] = cup_list[r3]
    return r1, r2, r3
end

function insert_cups!(cup_list::Vector{Int}, destination_cup::Int, r1::Int, _r2::Int, r3::Int)
    cup_list[r3] = cup_list[destination_cup]
    cup_list[destination_cup] = r1
end

function get_destination_cup(current_cup::Int, maximum_cup::Int, r1::Int, r2::Int, r3::Int)
    destination_cup = current_cup - 1
    while true
        if destination_cup < 1
            destination_cup = maximum_cup
        end
        if destination_cup != r1 && destination_cup != r2 && destination_cup != r3
            break;
        end
        destination_cup -= 1
    end
    return destination_cup
end

end # module Day23
