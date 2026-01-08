module Day10

using ..Utils

function day10(; part::Int=2, example::Bool=false)
    joltages = read_ints(10; example) |> sort

    if part == 1
        day10_part1(joltages)
    elseif part == 2
        day10_part2(joltages)
    end
end

function day10_part1(joltages)
    differences = [0, 0, 1]
    differences[joltages[1] - 0] += 1
    joltageslength = length(joltages)
    for i = 2:joltageslength
        difference = joltages[i] - joltages[i-1]
        differences[difference] += 1
    end
    println("Day 10, part 1, Product is $(differences[1]*differences[3])")
end

function day10_part2(joltages)
    paths = Dict{Int64, Int64}()
    for j in joltages
        paths[j] = 0
    end

    accumulatepaths(paths, 0, 1)
    for j in joltages
        accumulatepaths(paths, j, paths[j])
    end

    println("Day 10, part 2: $(paths[joltages[end]]) possible configurations.")
end

function accumulatepaths(paths, j, k)
    for i = 1:3
        if haskey(paths, j+i)
            paths[j+i] += k
        end
    end
end

export day10

end
