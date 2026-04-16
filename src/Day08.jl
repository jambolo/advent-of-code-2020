module Day08

using ..Utils

struct Instruction
    op::String
    value::Int64
end

function day08(; part::Int=2, example::Bool=false)
    lines = read_lines(8; example)

    instructions = parse_line.(lines)
    if part == 1
        day08_part1(instructions)
    elseif part == 2
        day08_part2(instructions)
    end
end

function parse_line(line::String)
    op, value = split(line)
    return Instruction(op, parse(Int64, value))
end

function day08_part1(instructions::Array{Instruction, 1})
        _, accumulator, _ = execute(instructions)
        println("Answer: $accumulator")
end

function day08_part2(instructions::Array{Instruction, 1})
    _, _, corrupted = execute(instructions)

    for i in corrupted
        instruction = instructions[i]
        if instruction.op == "jmp"
            instructions[i] = Instruction("nop", instruction.value)
        elseif instruction.op == "nop"
            instructions[i] = Instruction("jmp", instruction.value)
        end
        finished, accumulator, _ = execute(instructions)
        if finished
            println("Answer: $accumulator")
            break;
        end
        instructions[i] = instruction
    end
end

function execute(instructions::Array{Instruction, 1})
    n_instructions = length(instructions)
    executed = fill(false, n_instructions)
    accumulator = 0
    corrupted_set = Set{Int64}()
    i = 1
    while i <= n_instructions && !executed[i]
        executed[i] = true
        instruction = instructions[i]
        if instruction.op == "jmp"
            push!(corrupted_set, i)
            i += instruction.value - 1
            if !(0 <= i <= n_instructions)
                return (false, nothing, nothing)
            end
        elseif instruction.op == "acc"
            accumulator += instruction.value
        else
            push!(corrupted_set, i)
        end
        i += 1
    end
    return (i > n_instructions, accumulator, corrupted_set)
end

export day08

end
