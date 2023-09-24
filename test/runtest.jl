using CGPBool
using CGPBool: arity, TerminalNode, FunctionNode
using Test

@testset "CGPBool.jl" begin
    @test CGPBool.arity(&) == 2
    @test CGPBool.arity(|) == 2
    @test arity(~) == 1
    @test string(identity) == "○"

    include("component.jl")
    include("genetic_modification.jl")
end