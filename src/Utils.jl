module Utils

export open_input_file, read_ints, read_lines, read_map, read_comma_separated_ints

function open_input_file(f::Function, day::Int; example::Bool=false)
    suffix = example ? "example" : "input"
    filename = "day$(lpad(string(day), 2, '0'))-$suffix.txt"
    filepath = joinpath(@__DIR__, "..", "inputs", filename)
    return open(f, filepath)
end

function read_ints(day::Int; example::Bool=false)
    lines = read_lines(day; example)
    parse.(Int64, lines)
end

function read_lines(day::Int; example::Bool=false)
    lines = open_input_file(day; example) do f
        readlines(f)
    end
    return lines
end

function read_map(day::Int; example::Bool=false)
    lines = read_lines(day; example)
    return permutedims(stack(lines))
end

function read_comma_separated_ints(day::Int; example::Bool=false)
    line = open_input_file(day; example) do f
        readline(f)
    end
    ints = split(line, ",")
    return parse.(Int64, ints)
end

end
