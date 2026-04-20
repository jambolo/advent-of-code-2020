using Test
using AdventOfCode2020.Orientation

@testset "Orientation" begin
    @testset "constants" begin
        @test NUM_DIRECTIONS == 4
        @test FLIP_OFFSET == 4
        @test NUM_ORIENTATIONS == 8
    end

    @testset "direction constants" begin
        @test RIGHT == 1
        @test TOP == 2
        @test LEFT == 3
        @test BOTTOM == 4
    end

    @testset "is_flipped" begin
        for orientation in 1:FLIP_OFFSET
            @test is_flipped(orientation) == false
        end
        for orientation in (FLIP_OFFSET + 1):NUM_ORIENTATIONS
            @test is_flipped(orientation) == true
        end
    end

    @testset "identity orientation (1): each side faces itself" begin
        for side in 1:NUM_DIRECTIONS
            @test get_facing(side, 1) == side
            @test get_side(side, 1) == side
        end
    end

    @testset "get_facing for rotated orientations" begin
        # Orientation 2 = rot90 once (CCW): RIGHT→TOP, TOP→LEFT, LEFT→BOTTOM, BOTTOM→RIGHT
        @test get_facing(RIGHT, 2) == TOP
        @test get_facing(TOP, 2) == LEFT
        @test get_facing(LEFT, 2) == BOTTOM
        @test get_facing(BOTTOM, 2) == RIGHT

        # Orientation 3 = rot90 twice (180°): each side swaps with its opposite
        @test get_facing(RIGHT, 3) == LEFT
        @test get_facing(TOP, 3) == BOTTOM
        @test get_facing(LEFT, 3) == RIGHT
        @test get_facing(BOTTOM, 3) == TOP

        # Orientation 4 = rot90 three times: RIGHT→BOTTOM, TOP→RIGHT, LEFT→TOP, BOTTOM→LEFT
        @test get_facing(RIGHT, 4) == BOTTOM
        @test get_facing(TOP, 4) == RIGHT
        @test get_facing(LEFT, 4) == TOP
        @test get_facing(BOTTOM, 4) == LEFT
    end

    @testset "get_facing for flipped orientations" begin
        # Orientation 5 (flipped, no rotation): RIGHT→RIGHT, TOP→BOTTOM, LEFT→LEFT, BOTTOM→TOP
        @test get_facing(RIGHT, 5) == RIGHT
        @test get_facing(TOP, 5) == BOTTOM
        @test get_facing(LEFT, 5) == LEFT
        @test get_facing(BOTTOM, 5) == TOP

        # Orientation 6 (flipped, rot90): RIGHT→TOP, TOP→RIGHT, LEFT→BOTTOM, BOTTOM→LEFT
        @test get_facing(RIGHT, 6) == TOP
        @test get_facing(TOP, 6) == RIGHT
        @test get_facing(LEFT, 6) == BOTTOM
        @test get_facing(BOTTOM, 6) == LEFT
    end

    @testset "get_side is inverse of get_facing" begin
        for orientation in 1:NUM_ORIENTATIONS
            for side in 1:NUM_DIRECTIONS
                facing = get_facing(side, orientation)
                @test get_side(facing, orientation) == side
            end
            for facing in 1:NUM_DIRECTIONS
                side = get_side(facing, orientation)
                @test get_facing(side, orientation) == facing
            end
        end
    end

    @testset "get_orientation round-trip" begin
        # get_orientation(side, facing, flipped) should return an orientation such that
        # get_facing(side, orientation) == facing and is_flipped(orientation) == flipped
        for flipped in (false, true)
            for side in 1:NUM_DIRECTIONS
                for facing in 1:NUM_DIRECTIONS
                    orientation = get_orientation(side, facing, flipped)
                    @test 1 <= orientation <= NUM_ORIENTATIONS
                    @test is_flipped(orientation) == flipped
                    @test get_facing(side, orientation) == facing
                    @test get_side(facing, orientation) == side
                end
            end
        end
    end

    @testset "orientations are distinct per (side, facing)" begin
        # Every (side, facing, flipped) triple yields a unique orientation.
        seen = Set{Int}()
        for flipped in (false, true)
            for side in 1:NUM_DIRECTIONS
                for facing in 1:NUM_DIRECTIONS
                    push!(seen, get_orientation(side, facing, flipped))
                end
            end
        end
        # The total number of (side, facing, flipped) combinations is 4*4*2 = 32,
        # but they map onto the 8 distinct orientations.
        @test seen == Set(1:NUM_ORIENTATIONS)
    end

    @testset "opposite_direction" begin
        @test opposite_direction(RIGHT) == LEFT
        @test opposite_direction(TOP) == BOTTOM
        @test opposite_direction(LEFT) == RIGHT
        @test opposite_direction(BOTTOM) == TOP
    end
end
