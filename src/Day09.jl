module Day09

using ..Utils

function day09(; part::Int=2, example::Bool=false)
    lines = readinput(9; example)

    numbers = parse_ints(lines)
    preamblesize = example ? 5 : 25

    if part == 1
        day09_part1(numbers, preamblesize)
    elseif part == 2
        day09_part2(numbers, preamblesize)
    end
end

function day09_part1(numbers, preamblesize)
    n = firstinvalid(numbers, preamblesize)
    println("Day 9, part 1: First invalid number is $n")
end

function day09_part2(numbers, preamblesize)
    n = firstinvalid(numbers, preamblesize)
    first, last = findrange(numbers, n)
    lowest = minimum(numbers[first:last])
    highest = maximum(numbers[first:last])
    println("Day 9, part 2: Sum is $(lowest + highest)")
end

function firstinvalid(numbers, preamblesize)
    numberslength = length(numbers)
    for i = preamblesize + 1:numberslength
        n = numbers[i]
        if !pairfound(numbers, i - preamblesize, i - 1, n)
            return n
        end
    end
end


function pairfound(numbers, first, last, n)
    for i = first + 1:last
        ni = numbers[i]
        for j = first:i-1
            nj = numbers[j]
            if ni + nj == n
                return true
            end
        end
    end
    return false
end

function findrange(numbers, n)
    numberslength = length(numbers)
    for i = 1:numberslength-1
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
