module Day06

using ..Utils

function day06(; part::Int=2, example::Bool=false)
    lines = read_lines(6; example)

    if part == 1
        day06_part1(lines)
    elseif part == 2
        day06_part2(lines)
    end
end

function day06_part1(lines)
    groups = Array{Set{Char}, 1}()
    group = Set{Char}()
    for line in lines
        if isempty(line)
            push!(groups, group)
            group = Set{Char}()
        else
            for c in line
                push!(group, c)
            end
        end
    end

    if !isempty(group)
        push!(groups, group)
    end

    total = sum(length, groups)
    println("Day 6, part 1: Sum is $total")
end

function day06_part2(lines)
    intersections = Array{Set{Char}, 1}()
    intersection = Set{Char}()
    initialized = false
    for line in lines
        if isempty(line)
            push!(intersections, intersection)
            group = Set{Char}()
            intersection = Set{Char}()
            initialized = false
        else
            person = Set{Char}()
            for c in line
                push!(person, c)
            end
            if initialized
                intersect!(intersection, person)
            else
                intersection = person
                initialized = true
            end
        end
    end

    if !isempty(intersection)
        push!(intersections, intersection)
    end

    total = sum(length, intersections)
    println("Day 6, part 2: Sum is $total")
end

export day06

end
