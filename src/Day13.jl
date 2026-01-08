module Day13

using ..Utils

function day13(; part::Int=2, example::Bool=false)
    lines = read_lines(13; example)

    start_time = parse(Int, lines[1])
    bus_ids = [id == "x" ? nothing : parse(Int, id) for id in split(lines[2], ',')]

    if part == 1
        filtered_bus_ids = filter(!isnothing, bus_ids)
        day13_part1(start_time, filtered_bus_ids)
    elseif part == 2
        day13_part2(bus_ids)
    end
end

function day13_part1(start_time, bus_ids)
    min_wait_time = Inf
    soonest_bus_id = -1
    for bus_id in bus_ids
        wait_time = bus_id - (start_time % bus_id)
        if wait_time < min_wait_time
            min_wait_time = wait_time
            soonest_bus_id = bus_id
        end
    end
    println("Day 13, part 1: product = ", min_wait_time * soonest_bus_id)
end

function day13_part2(bus_ids)

    # Each bus_id and its offset (i - 1 because of 1-based indexing)
    constraints = [(bus_id, i - 1) for (i, bus_id) in enumerate(bus_ids) if bus_id !== nothing]

    # n is the product of all bus IDs
    n = prod(bus_id for (bus_id, _) in constraints)

    # nn is the list of nn / bus_id for each bus_id
    nn = [n ÷ bus_id for (bus_id, _) in constraints]

    # yy is the list of modular inverses of n[i] mod bus_id
    yy = [invmod(nn[i], constraints[i][1]) for i in eachindex(constraints)]

    # aa is the list of (bus_id - offset) mod bus_id
    # "offset * (bus_id - 1)" is equivalent and avoids negative numbers
    aa = [(offset * (bus_id - 1)) % bus_id for (bus_id, offset) in constraints]

    # The answer is (sum of offsets[i] * nn[i] * yy[i]) mod n
    t = sum(aa[i] * nn[i] * yy[i] for i in eachindex(constraints)) % n

    println("Day 13, part 2: ", t)
end

export day13

end
