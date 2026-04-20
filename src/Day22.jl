module Day22

using ..Utils

export day22

const State = Tuple{Vector{Int}, Vector{Int}}
const History = Dict{State, Vector{State}}
struct CachedGameResult
    state::State
    winner::Int
end
const CachedGameResultList = Dict{State, Vector{CachedGameResult}}

cached_game_hits = 0
cached_game_misses = 0
cached_game_hash_collisions = 0
history_hash_collisions = 0

function day22(; part::Int=2, example::Bool=false)
    lines = read_lines(22, example=example)

    i = 1
    deck_1, i = parse_deck(lines, i)
    deck_2, i = parse_deck(lines, i)

    if part == 1
        day22_part1(deck_1, deck_2, example=example)
    else
        day22_part2(deck_1, deck_2, example=example)
    end
end

function day22_part1(deck_1::Vector{Int}, deck_2::Vector{Int}; example::Bool=false)
    _, winning_deck = play_combat(deck_1, deck_2)

    result = deck_value(winning_deck)
    println("Answer: $result")
end

function day22_part2(deck_1::Vector{Int}, deck_2::Vector{Int}; example::Bool=false)
    _, winning_deck = play_recursive_combat(deck_1, deck_2)

    result = deck_value(winning_deck)
    println("Answer: $result")

#    println("Cached game hits: $cached_game_hits")
#    println("Cached game misses: $cached_game_misses")
#    println("Cached game hash collisions: $cached_game_hash_collisions")
#    println("History hash collisions: $history_hash_collisions")
end

function parse_deck(lines::Vector{String}, i::Int)::Tuple{Vector{Int}, Int}
    deck = Int[]
    i += 1 # skip "Player X:" line
    while i <= length(lines) && !isempty(lines[i])
        push!(deck, parse(Int, lines[i]))
        i += 1
    end
    return deck, i + 1
end

function play_combat(deck_1::Vector{Int}, deck_2::Vector{Int})::Tuple{Int, Vector{Int}}
    while !isempty(deck_1) && !isempty(deck_2)
        card_1 = popfirst!(deck_1)
        card_2 = popfirst!(deck_2)

        if card_1 > card_2
            collect_cards!(deck_1, card_1, card_2)
        else
            collect_cards!(deck_2, card_2, card_1)
        end
    end

    return !isempty(deck_1) ? (1, deck_1) : (2, deck_2)
end

function play_recursive_combat(deck_1::Vector{Int}, deck_2::Vector{Int})::Tuple{Int, Vector{Int}}
    history = History()
    cached_games = CachedGameResultList()

    while !isempty(deck_1) && !isempty(deck_2)
        # Before either player deals a card, if there was a previous round in this game that had exactly the same cards in the
        # same order in the same players' decks, the game instantly ends in a win for player 1.
        if check_and_store_history!(history, deck_1, deck_2)
            return 1, deck_1
        end

        card_1 = popfirst!(deck_1)
        card_2 = popfirst!(deck_2)

        if length(deck_1) >= card_1 && length(deck_2) >= card_2
            # If both players have at least as many cards remaining in their deck as the value of the card they just drew, the
            # winner of the round is determined by playing a new game of Recursive Combat.
            round_winner = play_recursive_combat_recursive(deck_1[1:card_1], deck_2[1:card_2], cached_games)
        else
            # Otherwise,  the winner of the round is the player with the higher-value card.
            round_winner = card_1 > card_2 ? 1 : 2
        end
        if round_winner == 1
            collect_cards!(deck_1, card_1, card_2)
        else
            collect_cards!(deck_2, card_2, card_1)
        end
    end

    return !isempty(deck_1) ? (1, deck_1) : (2, deck_2)
end

function play_recursive_combat_recursive(deck_1::Vector{Int}, deck_2::Vector{Int}, cached_games::CachedGameResultList)::Int
    history = History()
    starting_deck_1 = copy(deck_1) # need copies for caching the result of this game
    starting_deck_2 = copy(deck_2) # need copies for caching the result of this game

    while !isempty(deck_1) && !isempty(deck_2)
        # Check for a previously cached game result
        winner = check_for_cached_result(cached_games, deck_1, deck_2)
        if winner !== nothing
            return winner
        end

        # Before either player deals a card, if there was a previous round in this game that had exactly the same cards in the
        # same order in the same players' decks, the game instantly ends in a win for player 1.
        if check_and_store_history!(history, deck_1, deck_2)
            return 1
        end

        card_1 = popfirst!(deck_1)
        card_2 = popfirst!(deck_2)

        if length(deck_1) >= card_1 && length(deck_2) >= card_2
            # If both players have at least as many cards remaining in their deck as the value of the card they just drew, the
            # winner of the round is determined by playing a new game of Recursive Combat.
            round_winner = play_recursive_combat_recursive(deck_1[1:card_1], deck_2[1:card_2], cached_games)
        else
            # Otherwise,  the winner of the round is the player with the higher-value card.
            round_winner = card_1 > card_2 ? 1 : 2
        end
        if round_winner == 1
            collect_cards!(deck_1, card_1, card_2)
        else
            collect_cards!(deck_2, card_2, card_1)
        end
    end

    winner = !isempty(deck_1) ? 1 : 2

    # Cache the result of this game
    cache_game_result!(cached_games, starting_deck_1, starting_deck_2, winner)

    return winner
end

function check_for_cached_result(cached_games::CachedGameResultList, deck_1::Vector{Int}, deck_2::Vector{Int})::Union{Int, Nothing}
    state = (deck_1, deck_2)
    if haskey(cached_games, state)
        possible_matches = cached_games[state]
        i = findfirst(g -> state_matches(g.state, deck_1, deck_2), possible_matches)
        if i !== nothing
            global cached_game_hits += 1
            return possible_matches[i].winner
        else
            global cached_game_misses += 1
            return nothing
        end
    end
    global cached_game_misses += 1
    return nothing
end

function cache_game_result!(cached_games::CachedGameResultList, deck_1::Vector{Int}, deck_2::Vector{Int}, winner::Int)
    state = (deck_1, deck_2)
    if haskey(cached_games, state)
        # if it is already cached, don't add it again
        if any(g -> state_matches(g.state, deck_1, deck_2), cached_games[state])
            return
        else
            global cached_game_hash_collisions += 1
        end
    else
        cached_games[state] = Vector{CachedGameResult}()
    end
    push!(cached_games[state], CachedGameResult(state, winner))
end

function check_and_store_history!(history::History, deck_1::Vector{Int}, deck_2::Vector{Int})::Bool
    state = (deck_1, deck_2)
    if haskey(history, state)
        if any(s -> state_matches(s, deck_1, deck_2), history[state])
            return true
        else
            global history_hash_collisions += 1
        end
    else
        history[state] = Vector{Tuple{Vector{Int}, Vector{Int}}}()
    end
    state_copy = (copy(deck_1), copy(deck_2))
    push!(history[state], state_copy)
    return false
end


function collect_cards!(winner_deck::Vector{Int}, winner_card::Int, loser_card::Int)
    push!(winner_deck, winner_card)
    push!(winner_deck, loser_card)
end

function deck_value(deck::Vector{Int})::Int
    total = 0
    n = length(deck)
    for card in deck
        total += card * n
        n -= 1
    end
    return total
end

function state_matches(state::State, deck_1::Vector{Int}, deck_2::Vector{Int})::Bool
    return state[1] == deck_1 && state[2] == deck_2
end

end # module Day22
