module Day02

using ..Utils

struct Password
    least::Int64
    most::Int64
    letter::Char
    password::String
end

function day02(; part::Int=2, example::Bool=false)
    lines = readinput(2; example)
    attempts = parseline.(lines)

    if part == 1
        day02_part1(attempts)
    elseif part == 2
        day02_part2(attempts)
    end
end

function day02_part1(attempts)
    n = 0
    for a in attempts
        if a.least <= count(==(a.letter), a.password) <= a.most
            n += 1
        end
    end
    println("Day 2, part 1: $n valid passwords.")
end

function day02_part2(attempts)
    n = 0
    for a in attempts
        if (a.password[a.least] == a.letter) ⊻ (a.password[a.most] == a.letter)
            n += 1
        end
    end
    println("Day 2, part 2: $n valid passwords.")
end

function parseline(line::String)
    m = match(r"(\d+)-(\d+) (\w): (\w+)", line)
    return Password(parse(Int64, m[1]), parse(Int64, m[2]), m[3][1], m[4])
end

export day02

end
