module Day01

using ..Utils

const TARGET_SUM = 2020

function day01(; part::Int=2, example::Bool=false)
    expenses = read_ints(1; example)

    if part == 1
        day01_part1(expenses)
    elseif part == 2
        day01_part2(expenses)
    end
end

function day01_part1(expenses::Vector{Int64})

    n_expenses = length(expenses)
    for i = 2:n_expenses
        expense_i = expenses[i]
        for j = 1:i-1
            expense_j = expenses[j]
            if expense_i + expense_j == TARGET_SUM
                println("Answer: $(expense_i * expense_j)")
                return
            end
        end
    end
end

function day01_part2(expenses::Vector{Int64})
    n_expenses = length(expenses)
    for i = 3:n_expenses
        expense_i = expenses[i]
        for j = 2:i-1
            expense_j = expenses[j]
            for k = 1:j-1
                expense_k = expenses[k]
                if expense_i + expense_j + expense_k == TARGET_SUM
                    println("Answer: $(expense_i * expense_j * expense_k)")
                    return
                end
            end
        end
    end
end

export day01

end
