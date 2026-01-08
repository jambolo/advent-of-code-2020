module Day01

using ..Utils

function day01(; part::Int=2, example::Bool=false)
    expenses = read_ints(1; example)

    if part == 1
        day01_part1(expenses)
    elseif part == 2
        day01_part2(expenses)
    end
end

function day01_part1(expenses::Array{Int64, 1})

    expenseslength = length(expenses)
    for i = 2:expenseslength
        ei = expenses[i]
        for j = 1:i-1
            ej = expenses[j]
            if ei + ej == 2020
                println("Part 1: Product is $(ei * ej)")
                return
            end
        end
    end
end

function day01_part2(expenses::Array{Int64, 1})
    expenseslength = length(expenses)
    for i = 3:expenseslength
        ei = expenses[i]
        for j = 2:i-1
            ej = expenses[j]
            for k = 1:j-1
                ek = expenses[k]
                if ei + ej + ek == 2020
                    println("Part 2: Product is $(ei * ej * ek)")
                    return
                end
            end
        end
    end
end

export day01

end
