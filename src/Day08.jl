module Day08

using ..Utils

struct Instruction
    op::String
    value::Int64
end

function day08(; part::Int=2, example::Bool=false)
    lines = readinput(8; example)

    instructions = parseline.(lines)
    if part == 1
        day08_part1(instructions)
    elseif part == 2
        day08_part2(instructions)
    end
end

function parseline(line::String)
    op, value = split(line)
    return Instruction(op, parse(Int64, value))
end

function day08_part1(instructions::Array{Instruction, 1})
        _, accumulator, _ = execute(instructions)
        println("Day 8, part 1: Accumulator = $accumulator")
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
            println("Day 8, part 2: Accumulator = $accumulator")
            break;
        end
        instructions[i] = instruction
    end
end

function execute(instructions::Array{Instruction, 1})
    len = length(instructions)
    executed = fill(false, len)
    accumulator = 0
    corrupted = Set{Int64}()
    i = 1
    while i <= len && !executed[i]
        executed[i] = true
        instruction = instructions[i]
        if instruction.op == "jmp"
            push!(corrupted, i)
            i += instruction.value - 1
            if !(0 <= i <= len)
                return (false, nothing, nothing)
            end
        elseif instruction.op == "acc"
            accumulator += instruction.value
        else
            push!(corrupted, i)
        end
        i += 1
    end
    return (i > len, accumulator, corrupted)
end

export day08

end
