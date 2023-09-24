@testset "component" begin
    @testset "node" begin
        t = CGPBool.TerminalNode(1, [true, false])
        @test t.outputs == [true, false]
        @test t.i_variable == 1
        @test t isa CGPBool.AbstractNode
        f = FunctionNode(&, [t, t], [true, true], false)
        @test f.outputs == [true, true]
        @test f.func(true, false) == false
        f2 = FunctionNode(|, [t, f], [true, true], false)
        @test f2.input_nodes[1] === t
        @test f2.input_nodes[2] === f
        # test the default constructor
        f3 = FunctionNode(~)
        @test length(f3.input_nodes) == CGPBool.MAX_ARITY # default to MAX_ARITY
        @show f3.input_nodes
    end
end