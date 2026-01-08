module Utils

export parse_ints, readinput, readmap

function parse_ints(lines::Vector{String})
    parse.(Int64, lines)
end

function readinput(day::Int; example::Bool=false)
    suffix = example ? "example" : "input"
    filename = "day$(lpad(string(day), 2, '0'))-$suffix.txt"
    lines = open(joinpath(@__DIR__, "..", "inputs", filename)) do f
        readlines(f)
    end
    return lines
end

function readmap(day::Int; example::Bool=false)
    lines = readinput(day; example)
    return permutedims(stack(lines))
end

end
