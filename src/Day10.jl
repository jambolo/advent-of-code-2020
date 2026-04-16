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
    n_joltages = length(joltages)
    for i = 2:n_joltages
        difference = joltages[i] - joltages[i-1]
        differences[difference] += 1
    end
    println("Answer: $(differences[1]*differences[3])")
end

function day10_part2(joltages)
    path_counts = Dict{Int64, Int64}()
    for j in joltages
        path_counts[j] = 0
    end

    accumulate_paths(path_counts, 0, 1)
    for j in joltages
        accumulate_paths(path_counts, j, path_counts[j])
    end

    println("Answer: $(path_counts[joltages[end]])")
end

function accumulate_paths(path_counts, j, k)
    for i = 1:3
        if haskey(path_counts, j+i)
            path_counts[j+i] += k
        end
    end
end

export day10

end
