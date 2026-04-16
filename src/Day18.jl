module Day18

using ..Utils
using ..Expression

function day18(; part::Int=2, example::Bool=false)
    lines = read_lines(18; example)

    if part == 1
        day18_part1(lines)
    elseif part == 2
        day18_part2(lines, example)
    end
end

function day18_part1(lines)
    result = sum(evaluate(expression, precedence_p1) for expression in lines)
    println("Answer: $result")
end

function precedence_p1(op)
    if op == '+'
        return 1
    elseif op == '*'
        return 1
    else
        return 0
    end
end

function day18_part2(lines, example)
    result = sum(evaluate(expression, precedence_p2) for expression in lines)
    println("Answer: $result")
end

function precedence_p2(op)
    if op == '+'
        return 2
    elseif op == '*'
        return 1
    else
        return 0
    end
end

export day18

end
