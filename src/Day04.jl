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

function parse_passports(rows)
    passports = Vector{Dict{String, String}}()
    passport = Dict{String, String}()
    for row in rows
        if length(row) > 0
            for field_token in eachsplit(row)
                m = match(r"(\w+):(.+)", field_token)
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
    valid_count = count(is_valid_part1, passports)
    println("Answer: $valid_count")
end

function day04_part2(passports)
    valid_count = count(is_valid_part2, passports)
    println("Answer: $valid_count")
end

function is_valid_part1(passport::Dict{String, String})
    return "byr" in keys(passport) &&
           "iyr" in keys(passport) &&
           "eyr" in keys(passport) &&
           "hgt" in keys(passport) &&
           "hcl" in keys(passport) &&
           "ecl" in keys(passport) &&
           "pid" in keys(passport)
end

function is_valid_part2(passport::Dict{String, String})
    return "byr" in keys(passport) && is_valid_byr(passport["byr"]) &&
           "iyr" in keys(passport) && is_valid_iyr(passport["iyr"]) &&
           "eyr" in keys(passport) && is_valid_eyr(passport["eyr"]) &&
           "hgt" in keys(passport) && is_valid_hgt(passport["hgt"]) &&
           "hcl" in keys(passport) && is_valid_hcl(passport["hcl"]) &&
           "ecl" in keys(passport) && is_valid_ecl(passport["ecl"]) &&
           "pid" in keys(passport) && is_valid_pid(passport["pid"])
end

is_valid_byr(s::String) = match(r"^\d{4}$", s) !== nothing && 1920 <= parse(Int64, s) <= 2002
is_valid_iyr(s::String) = match(r"^\d{4}$", s) !== nothing && 2010 <= parse(Int64, s) <= 2020
is_valid_eyr(s::String) = match(r"^\d{4}$", s) !== nothing && 2020 <= parse(Int64, s) <= 2030

function is_valid_hgt(s::String)
    match_results = match(r"^(\d+)(in|cm)$", s)
    if match_results === nothing
        return false
    end
    height = parse(Int64, match_results[1])
    if match_results[2] == "in"
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

is_valid_hcl(s::String) = match(r"^#[0-9a-zA-Z]{6}$", s) !== nothing
is_valid_ecl(s::String) = match(r"^(amb)|(blu)|(brn)|(gry)|(grn)|(hzl)|(oth)$", s) !== nothing
is_valid_pid(s::String) = match(r"^\d{9}$", s) !== nothing

export day04

end
