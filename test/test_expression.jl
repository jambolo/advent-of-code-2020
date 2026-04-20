using Test
using AdventOfCode2020.Expression

# Equal precedence (left-to-right): matches Day 18 part 1.
precedence_equal(op) = (op == '+' || op == '*') ? 1 : 0

# Addition has higher precedence than multiplication: matches Day 18 part 2.
precedence_plus_higher(op) = op == '+' ? 2 : op == '*' ? 1 : 0

@testset "Expression" begin
    @testset "single operand" begin
        @test evaluate("7", precedence_equal) == 7
        @test evaluate("0", precedence_equal) == 0
        @test evaluate("9", precedence_plus_higher) == 9
    end

    @testset "basic arithmetic" begin
        @test evaluate("1 + 2", precedence_equal) == 3
        @test evaluate("3 * 4", precedence_equal) == 12
        @test evaluate("2 + 3 + 4", precedence_equal) == 9
        @test evaluate("2 * 3 * 4", precedence_equal) == 24
    end

    @testset "parentheses" begin
        @test evaluate("(5)", precedence_equal) == 5
        @test evaluate("(2 + 3)", precedence_equal) == 5
        @test evaluate("(2 + 3) * 4", precedence_equal) == 20
        @test evaluate("2 * (3 + 4)", precedence_equal) == 14
        @test evaluate("((1 + 2) * (3 + 4))", precedence_equal) == 21
    end

    @testset "whitespace handling" begin
        @test evaluate("1+2", precedence_equal) == 3
        @test evaluate("1  +  2", precedence_equal) == 3
        @test evaluate("1+2*3", precedence_equal) == 9
        @test evaluate("2*3+4", precedence_equal) == 10
    end

    @testset "deeply nested parentheses" begin
        @test evaluate("((((5))))", precedence_equal) == 5
        @test evaluate("((1 + 2) + (3 + 4))", precedence_equal) == 10
        @test evaluate("(((1 + 2) * 3) + 4)", precedence_equal) == 13
    end

    # Reference values from Advent of Code 2020 Day 18.
    @testset "equal precedence (Day 18 part 1)" begin
        @test evaluate("1 + 2 * 3 + 4 * 5 + 6", precedence_equal) == 71
        @test evaluate("1 + (2 * 3) + (4 * (5 + 6))", precedence_equal) == 51
        @test evaluate("2 * 3 + (4 * 5)", precedence_equal) == 26
        @test evaluate("5 + (8 * 3 + 9 + 3 * 4 * 3)", precedence_equal) == 437
        @test evaluate("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", precedence_equal) == 12240
        @test evaluate("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", precedence_equal) == 13632
    end

    # Reference values from Advent of Code 2020 Day 18.
    @testset "addition before multiplication (Day 18 part 2)" begin
        @test evaluate("1 + 2 * 3 + 4 * 5 + 6", precedence_plus_higher) == 231
        @test evaluate("1 + (2 * 3) + (4 * (5 + 6))", precedence_plus_higher) == 51
        @test evaluate("2 * 3 + (4 * 5)", precedence_plus_higher) == 46
        @test evaluate("5 + (8 * 3 + 9 + 3 * 4 * 3)", precedence_plus_higher) == 1445
        @test evaluate("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", precedence_plus_higher) == 669060
        @test evaluate("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", precedence_plus_higher) == 23340
    end
end
