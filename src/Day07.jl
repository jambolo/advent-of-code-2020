module Day07

using ..Utils

mutable struct Group
    name::String
    count::Int64
end
copy(g::Group) = Group(g.name, g.count)

struct BagInfo
    contains::Vector{Group}
    sums::Dict{String, Int64}
end

function day07(; part::Int=2, example::Bool=false)
    lines = read_lines(7; example)

    bags = parse_bags(lines)
    compute_bag_totals!(bags)

    if part == 1
        day07_part1(bags)
    elseif part == 2
        day07_part2(bags)
    end
end

function parse_bags(lines)
    bags = Dict{String, BagInfo}()
    for line in lines
        substrings = split(line, ',')
        m = match(r"(\w+ \w+) bags contain (?:(?:no other)|(?:(\d+) (\w+ \w+))) bag", substrings[begin])
        name = m[1]
        bag = BagInfo(Vector{Group}(), Dict{String, Int64}())
        if m[2] !== nothing
            count = parse(Int64, m[2])
            other = m[3]
            push!(bag.contains, Group(other, count))
        end
        for s in substrings[2:end]
            m = match(r"(\d+) (\w+ \w+) bag", s)
            count = parse(Int64, m[1])
            other = m[2]
            push!(bag.contains, Group(other, count))
        end
        bags[name] = bag
    end
    return bags
end

compute_bag_totals!(bags::Dict{String, BagInfo}) = begin
    for bag in values(bags)
        for contained_bag in bag.contains
            groups = Vector{Group}()
            collect_contained_bags!(bags, groups, contained_bag)
            for g in groups
                if haskey(bag.sums, g.name)
                    bag.sums[g.name] += g.count
                else
                    bag.sums[g.name] = g.count
                end
            end
        end
    end
end

function collect_contained_bags!(bags::Dict{String, BagInfo}, groups0::Vector{Group}, g::Group)
    bag = bags[g.name]
    groups1 = Vector{Group}()
    for contained_bag in bag.contains
        collect_contained_bags!(bags, groups1, contained_bag)
    end
    push!(groups0, copy(g))
    for g1 in groups1
        g1.count *= g.count
    end
    append!(groups0, groups1)
end

function day07_part1(bags::Dict{String, BagInfo})
    total = count(bag -> "shiny gold" in keys(bag.sums), values(bags))
    println("Answer: $total")
end

function day07_part2(bags::Dict{String, BagInfo})
    shiny_gold_bag = bags["shiny gold"]
    total = sum(values(shiny_gold_bag.sums))
    println("Answer: $total")
end

export day07

end
