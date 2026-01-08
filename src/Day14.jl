module Day14

using ..Utils

function day14(; part::Int=2, example::Bool=false)
    lines = readinput(14; example)

    if part == 1
        day14_part1(lines)
    elseif part == 2
        day14_part2(lines)
    end
end

function day14_part1(lines)
    memory = Dict{Int,UInt64}()
    m = UInt64(0)
    x = UInt64(0)
    for line in lines
        # If the line starts with "mask = ", parse the mask
        if startswith(line, "mask = ")
            mask_str = split(line, " = ")[2]
            (m, x) = parse_mask(mask_str)
        else
            # Parse memory assignment
            parsed = match(r"mem\[(\d+)\] = (\d+)", line)
            addr = parse(Int, parsed.captures[1])
            value = parse(UInt64, parsed.captures[2])
            memory[addr] = mask(value, m, x)
        end
    end
    total = sum(values(memory))
    println("Day 14, part 1: Sum = ", total)
end

function day14_part2(lines)
    memory = Dict{Int,UInt64}()
    m = UInt64(0)
    x = UInt64(0)
    f = UInt64(0)
    for line in lines
        # If the line starts with "mask = ", parse the mask
        if startswith(line, "mask = ")
            mask_str = split(line, " = ")[2]
            (m, x) = parse_mask(mask_str)
            f = (~x) & 0xFFFFFFFFF
        else
            # Parse memory assignment
            parsed = match(r"mem\[(\d+)\] = (\d+)", line)
            addr = parse(Int, parsed.captures[1])
            value = parse(UInt64, parsed.captures[2])
            addr = (addr | m) & f
            i = UInt64(0)
            while i <= x
                float_addr = addr | i
                memory[float_addr] = value
                i = ((i | f) + 1) & ~f
            end
        end
    end
    total = sum(values(memory))
    println("Day 14, part 2: Sum = ", total)
end

function parse_mask(mask_str::AbstractString)
    m = UInt64(0)
    x = UInt64(0)
    for c in mask_str
        m = m << 1
        x = x << 1
        if c == '1'
            m |= 1
        elseif c == 'X'
            x |= 1
        end
    end
    return (m, x)
end

function mask(value::UInt64, m::UInt64, x::UInt64)
    return value & x | m & ~x
end

export day14

end
