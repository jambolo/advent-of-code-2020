module Utils

export parse_ints, readinput

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

end
