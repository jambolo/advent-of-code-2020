using Test
using AdventOfCode2020.Utils

@testset "Utils" begin
    @testset "read_lines" begin
        lines = read_lines(1; example=true)
        @test lines isa Vector{String}
        @test length(lines) == 6
        @test lines[1] == "1721"
        @test lines[end] == "1456"
    end

    @testset "read_ints" begin
        ints = read_ints(1; example=true)
        @test ints isa Vector{Int64}
        @test ints == [1721, 979, 366, 299, 675, 1456]
    end

    @testset "read_map" begin
        grid = read_map(3; example=true)
        @test grid isa AbstractMatrix{Char}
        @test size(grid) == (11, 11)
        @test grid[1, 1] == '.'
        @test grid[1, 3] == '#'
        @test grid[2, 1] == '#'
        @test grid[11, 11] == '#'
    end

    @testset "read_comma_separated_ints" begin
        ints = read_comma_separated_ints(15; example=true)
        @test ints isa Vector{Int64}
        @test ints == [0, 3, 6]
    end

    @testset "open_input_file callback" begin
        first_line = open_input_file(1; example=true) do f
            readline(f)
        end
        @test first_line == "1721"

        # Callback return value is propagated to the caller.
        count = open_input_file(1; example=true) do f
            length(readlines(f))
        end
        @test count == 6
    end

    @testset "print_map output format" begin
        grid = ['a' 'b' 'c'; 'd' 'e' 'f']
        output = mktemp() do path, io
            redirect_stdout(io) do
                print_map(grid)
            end
            flush(io)
            read(path, String)
        end
        lines = filter(!isempty, split(output, '\n'))
        # 2 rows + top border + bottom border = 4 lines
        @test length(lines) == 4
        @test startswith(lines[1], "+-")
        @test endswith(lines[1], "+")
        @test lines[1] == lines[end]
        @test startswith(lines[2], "| ")
        @test endswith(lines[2], "|")
        @test occursin("a", lines[2])
        @test occursin("b", lines[2])
        @test occursin("c", lines[2])
        @test occursin("d", lines[3])
    end
end
