module Day16

using ..Utils

function day16(; part::Int=2, example::Bool=false)
    lines = read_lines(16; example)

    fields = Dict{String, Vector{UnitRange{Int}}}()
    your_ticket = Int[]
    nearby_tickets = Vector{Vector{Int}}()

    section = 0
    for line in lines
        if section == 0
            if isempty(line)
                section += 1
                continue
            end
            (name, ranges) = parse_field(line)
            fields[name] = ranges
        elseif section == 1
            if isempty(line)
                section += 1
                continue
            end
            # Skip your ticket line
            if !startswith(line, "your ticket:")
                your_ticket = parse.(Int, split(line, ","))
            end
        else
            if !startswith(line, "nearby tickets:")
                ticket = parse.(Int, split(line, ","))
                push!(nearby_tickets, ticket)
            end
        end
    end

    if part == 1
        day16_part1(fields, your_ticket, nearby_tickets)
    elseif part == 2
        day16_part2(fields, your_ticket, nearby_tickets)
    end
end

function day16_part1(fields, your_ticket, nearby_tickets)
    rate = sum(filter(!isnothing, (ticket_is_invalid(t, fields) for t in nearby_tickets)))
    println("Day 16, part 1: Rate = ", rate)
end

function day16_part2(fields, your_ticket, nearby_tickets)
    valid_tickets = filter(t -> isnothing(ticket_is_invalid(t, fields)), nearby_tickets)

    possible_fields = [Set(keys(fields)) for _ in 1:length(your_ticket)]

    for ticket in vcat(valid_tickets, [your_ticket])
        eliminate_impossible_fields!(possible_fields, ticket, fields)
    end

    ticket_fields = resolve_fields(possible_fields)

    product = prod(your_ticket[i] for (i, name) in enumerate(ticket_fields) if startswith(name, "departure"))
    println("Day 16, part 2: Product = ", product)
end

function resolve_fields(possible_fields)
    ticket_fields = Vector{String}(undef, length(possible_fields))
    while any(length(pf) > 0 for pf in possible_fields)
        for i in eachindex(possible_fields)
            if length(possible_fields[i]) == 1
                field_name = first(possible_fields[i])
                ticket_fields[i] = field_name
                for pf in possible_fields
                    delete!(pf, field_name)
                end
            end
        end
    end
    return ticket_fields
end

function parse_field(line::String)
    name, ranges_str = split(line, ": ")
    ranges = map(split(ranges_str, " or ")) do r
        lo, hi = parse.(Int, split(r, "-"))
        lo:hi
    end
    return (name, ranges)
end

function ticket_is_invalid(ticket, fields)
    for value in ticket
        if !any(any(value in range for range in ranges) for ranges in values(fields))
            return value
        end
    end
    return nothing
end

function eliminate_impossible_fields!(possible_fields, ticket, fields)
    for (i, value) in enumerate(ticket)
        filter!(possible_fields[i]) do field_name
            any(value in range for range in fields[field_name])
        end
    end
end

export day16

end
