module Day25

using ..Utils

export day25

const EXAMPLE_DOOR_PUBLIC_KEY = 17807724
const EXAMPLE_CARD_PUBLIC_KEY = 5764801
const DOOR_PUBLIC_KEY = 1327981
const CARD_PUBLIC_KEY = 2822615
const G = 7

function day25(; part::Int=2, example::Bool=false)
    if part == 1
        day25_part1(example=example)
    else
        day25_part2(example=example)
    end
end

function day25_part1(; example::Bool=false)
    door_public = example ? EXAMPLE_DOOR_PUBLIC_KEY : DOOR_PUBLIC_KEY
    card_public = example ? EXAMPLE_CARD_PUBLIC_KEY : CARD_PUBLIC_KEY
    card_private = crack(card_public, G)
    shared_secret = transform(card_private, door_public)
    println("Answer: $shared_secret")
end

function day25_part2(; example::Bool=false)
    println("Answer: N/A")
end

function crack(public_key, generator)
    value = 1
    private_key = 0
    while value != public_key
        value = (value * generator) % 20201227
        private_key += 1
    end
    return private_key
end

function transform(private_key, generator)
    value = 1
    for _ in 1:private_key
        value = (value * generator) % 20201227
    end
    return value
end


end # module Day25
