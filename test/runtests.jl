using Test
using AdventOfCode2020
using AdventOfCode2020.Expression
using AdventOfCode2020.Orientation
using AdventOfCode2020.Utils

@testset "AdventOfCode2020" begin
    include("test_expression.jl")
    include("test_orientation.jl")
    include("test_utils.jl")
end
