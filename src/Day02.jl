module Day02

using ..Utils

struct Password
    least::Int64
    most::Int64
    letter::Char
    password::String
end

function day02(; part::Int=2, example::Bool=false)
    lines = read_lines(2; example)
    attempts = parse_line.(lines)

    if part == 1
        day02_part1(attempts)
    elseif part == 2
        day02_part2(attempts)
    end
end

function day02_part1(attempts)
    valid_count = 0
    for a in attempts
        if a.least <= count(==(a.letter), a.password) <= a.most
            valid_count += 1
        end
    end
    println("Answer: $valid_count")
end

function day02_part2(attempts)
    valid_count = 0
    for attempt in attempts
        if (attempt.password[attempt.least] == attempt.letter) ⊻ (attempt.password[attempt.most] == attempt.letter)
            valid_count += 1
        end
    end
    println("Answer: $valid_count")
end

function parse_line(line::String)
    match_result = match(r"(\d+)-(\d+) (\w): (\w+)", line)
    return Password(parse(Int64, match_result[1]), parse(Int64, match_result[2]), match_result[3][1], match_result[4])
end

export day02

end
