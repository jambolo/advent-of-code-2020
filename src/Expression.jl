module Expression

export evaluate

function evaluate(expression, precedence)
    operator_stack = Char[]
    operand_stack = Int[]

    i = 1
    while i <= length(expression)
        token, i = next_token(expression, i)
        if token === '('
            push!(operator_stack, token)
        elseif token === ')'
            op = pop!(operator_stack)
            while op != '('
                right = pop!(operand_stack)
                left = pop!(operand_stack)
                push!(operand_stack, apply_operator(left, op, right))
                op = pop!(operator_stack)
            end
        elseif token == '+' || token == '*'
            while !isempty(operator_stack) && precedence(operator_stack[end]) >= precedence(token)
                op = pop!(operator_stack)
                right = pop!(operand_stack)
                left = pop!(operand_stack)
                push!(operand_stack, apply_operator(left, op, right))
            end
            push!(operator_stack, token)
        else
            push!(operand_stack, parse(Int, token))
        end
    end

    while !isempty(operator_stack)
        op = pop!(operator_stack)
        right = pop!(operand_stack)
        left = pop!(operand_stack)
        push!(operand_stack, apply_operator(left, op, right))
    end

    value = pop!(operand_stack)
    return value
end

function next_token(s, i)
    # skip whitespace
    while i <= length(s) && s[i] == ' '
        i += 1
    end
    # if the end is reached, return nothing
    if i > length(s)
        return nothing, i
    end

    # return the current character the a token and bump the index
    return s[i], i + 1
end

function apply_operator(left, op, right)
    if op == '+'
        return left + right
    elseif op == '*'
        return left * right
    else
        error("Unknown operator: $op")
    end
end

end # module Expression
