module Day21

using ..Utils

export day21

function day21(; part::Int=2, example::Bool=false)
    lines = read_lines(21; example=example)

    foods = parse_foods(lines)

    if part == 1
        day21_part1(foods; example=example)
    else
        day21_part2(foods; example=example)
    end
end

function day21_part1(foods; example::Bool=false)
    _, allergen_free_ingredients = associate_ingredients(foods)

    # Count how many times allergen-free ingredients appear in the input
    result = sum(count(ing -> ing in allergen_free_ingredients, ingredients_list) for (ingredients_list, _) in foods)
    println("Answer: $result")
end

function day21_part2(foods; example::Bool=false)
    associations_by_allergen, _ = associate_ingredients(foods)
    # Sort the allergens alphabetically and join their associated ingredients in that order
    sorted_allergens = sort(collect(keys(associations_by_allergen)))
    result = join(collect(associations_by_allergen[allergen] for allergen in sorted_allergens), ",")
    println("Answer: $result")
end


function parse_foods(lines)
    foods = []
    for line in lines
        m = match(r"^(.*) \(contains (.*)\)$", line)
        if m === nothing
            error("Line does not match expected format: $line")
        end
        ingredients_list = split(m.captures[1])
        allergens_list = split(m.captures[2], ", ")
        push!(foods, (ingredients_list, allergens_list))
    end
    return foods

end

function associate_ingredients(foods)
    ingredients, allergen_in_one_of = extract_relationships(foods)
    # Reduce the possible ingredients containing each allergen by repeatedly eliminating ingredients that are uniquely associated
    # with a single allergen

    # Keep track of which ingredient is associated with which allergen
    associations_by_allergen = Dict{String,String}()

    while true
        associated_allergen = nothing
        for (allergen, possible_ingredients) in allergen_in_one_of
            # If this allergen can only be in one ingredient, then an association is found
            if length(possible_ingredients) == 1
                associated_allergen = allergen
                ingredient = first(possible_ingredients)
                associations_by_allergen[allergen] = ingredient

                # Remove this ingredient from the possible ingredients for all other allergens
                for (other_allergen, other_possible_ingredients) in allergen_in_one_of
                    if other_allergen != allergen && ingredient in other_possible_ingredients
                        delete!(other_possible_ingredients, ingredient)
                    end
                end
            end
        end
        if associated_allergen !== nothing
            # Remove the known allergen from the list of allergens to process
            delete!(allergen_in_one_of, associated_allergen)
        else
            break
        end
    end

    allergen_free_ingredients = setdiff(ingredients, values(associations_by_allergen))

    return associations_by_allergen, allergen_free_ingredients
end

function extract_relationships(foods)
    ingredients = Set{String}()
    allergen_in_one_of = Dict{String, Set{String}}()
    for (ingredients_list, allergens_list) in foods
        union!(ingredients, ingredients_list)
        for allergen in allergens_list
            if haskey(allergen_in_one_of, allergen)
                intersect!(allergen_in_one_of[allergen], Set(ingredients_list))
            else
                allergen_in_one_of[allergen] = Set(ingredients_list)
            end
        end
    end
    return ingredients, allergen_in_one_of

end

end # module Day21
