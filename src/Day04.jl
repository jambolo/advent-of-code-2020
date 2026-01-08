module Day04

using ..Utils

function day04(; part::Int=2, example::Bool=false)
    lines = read_lines(4; example)
    passports = parse_passports(lines)

    if part == 1
        day04_part1(passports)
    else
        day04_part2(passports)
    end
end

function parse_passports(lines)
    passports = Vector{Dict{String, String}}()
    passport = Dict{String, String}()
    for line in lines
        if length(line) > 0
            for s in eachsplit(line)
                m = match(r"(\w+):(.+)", s)
                passport[m[1]] = m[2]
            end
        else
            if !isempty(passport)
                push!(passports, passport)
                passport = Dict{String, String}()
            end
        end
    end
    if !isempty(passport)
        push!(passports, passport)
    end
    return passports
end

function day04_part1(passports)
    count = Base.count(isvalid_part1, passports)
    println("Day 4, part 1: $count valid passports.")
end

function day04_part2(passports)
    count = Base.count(isvalid_part2, passports)
    println("Day 4, part 2: $count valid passports.")
end

function isvalid_part1(passport::Dict{String, String})
    return "byr" in keys(passport) &&
           "iyr" in keys(passport) &&
           "eyr" in keys(passport) &&
           "hgt" in keys(passport) &&
           "hcl" in keys(passport) &&
           "ecl" in keys(passport) &&
           "pid" in keys(passport)
end

function isvalid_part2(passport::Dict{String, String})
    return "byr" in keys(passport) && isvalidbyr(passport["byr"]) &&
           "iyr" in keys(passport) && isvalidiyr(passport["iyr"]) &&
           "eyr" in keys(passport) && isvalideyr(passport["eyr"]) &&
           "hgt" in keys(passport) && isvalidhgt(passport["hgt"]) &&
           "hcl" in keys(passport) && isvalidhcl(passport["hcl"]) &&
           "ecl" in keys(passport) && isvalidecl(passport["ecl"]) &&
           "pid" in keys(passport) && isvalidpid(passport["pid"])
end

isvalidbyr(s::String) = match(r"^\d{4}$", s) !== nothing && 1920 <= parse(Int64, s) <= 2002
isvalidiyr(s::String) = match(r"^\d{4}$", s) !== nothing && 2010 <= parse(Int64, s) <= 2020
isvalideyr(s::String) = match(r"^\d{4}$", s) !== nothing && 2020 <= parse(Int64, s) <= 2030

function isvalidhgt(s::String)
    m = match(r"^(\d+)(in|cm)$", s)
    if m === nothing
        return false
    end
    height = parse(Int64, m[1])
    if m[2] == "in"
        if 59 <= height <= 76
            return true
        end
    else
        if 150 <= height <= 193
            return true
        end
    end
    return false
end

isvalidhcl(s::String) = match(r"^#[0-9a-zA-Z]{6}$", s) !== nothing
isvalidecl(s::String) = match(r"^(amb)|(blu)|(brn)|(gry)|(grn)|(hzl)|(oth)$", s) !== nothing
isvalidpid(s::String) = match(r"^\d{9}$", s) !== nothing

export day04

end
