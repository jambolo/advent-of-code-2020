module Day09

using ..Utils

function day09(; part::Int=2, example::Bool=false)
    numbers = read_ints(9; example)
    preamble_size = example ? 5 : 25

    if part == 1
        day09_part1(numbers, preamble_size)
    elseif part == 2
        day09_part2(numbers, preamble_size)
    end
end

function day09_part1(numbers, preamble_size)
    n = first_invalid(numbers, preamble_size)
    println("Answer: $n")
end

function day09_part2(numbers, preamble_size)
    n = first_invalid(numbers, preamble_size)
    first_i, last_i = find_range(numbers, n)
    lowest = minimum(numbers[first_i:last_i])
    highest = maximum(numbers[first_i:last_i])
    println("Answer: $(lowest + highest)")
end

function first_invalid(numbers, preamble_size)
    n_numbers = length(numbers)
    for i = preamble_size + 1:n_numbers
        n = numbers[i]
        if !pair_found(numbers, i - preamble_size, i - 1, n)
            return n
        end
    end
end


function pair_found(numbers, first_i, last_i, n)
    for i = first_i + 1:last_i
        ni = numbers[i]
        for j = first_i:i-1
            nj = numbers[j]
            if ni + nj == n
                return true
            end
        end
    end
    return false
end

function find_range(numbers, n)
    n_numbers = length(numbers)
    for i = 1:n_numbers-1
        k = numbers[i] + numbers[i + 1]
        j = i + 2
        while k < n
            k += numbers[j]
            j += 1
        end
        if k == n
            return (i, j - 1)
        end
    end
end

export day09

end
