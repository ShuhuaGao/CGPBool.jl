@testset "genetic modification" begin
    @testset "create individual" begin
        data = rand(Bool, (4, 3))
        t_nodes = create_terminal_nodes(data)
        @test t_nodes[1].outputs == @view data[:, 1]
        @test t_nodes[2].outputs == @view data[:, 2]
        @test t_nodes[1].outputs !== @view data[:, 1]  # we have made a copy of the data 
        cfg = Config(terminal_nodes=t_nodes)
        ind = create_random_individual(cfg, 0.0)
        @test ind isa Individual{Float64}
        @test ind.output_node in ind.function_nodes
        for node in ind.function_nodes
            for i = 1:arity(node.func)
                ni = node.input_nodes[i]
                @test ni isa CGPBool.AbstractNode
                if ni isa TerminalNode
                    @test ni in cfg.terminal_nodes
                end
            end
        end
    end
end