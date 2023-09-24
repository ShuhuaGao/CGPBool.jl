"""
    create_terminal_nodes(data::AbstractMatrix{Bool}) -> Vector{TerminalNode}

Given data matrix `data`, return a vector of `TerminalNode` of length `size(data, 2)`.
Each column of `data` corresponds to a variable and demands a terminal.
Each row of `data` represents an observation, aka a data point.
The `i-th` terminal copies the `i-th` column of `data` in its `outputs`.
"""
function create_terminal_nodes(data::AbstractMatrix{Bool})
    num_variables = size(data, 2)
    return [TerminalNode(i, data[:, i]) for i in 1:num_variables]
end


"""
    create_random_individual(cfg::Config, fitness::T=zero(T)) -> Individual{T}

Create a random individual, whose fitness is of type `T`.
"""
function create_random_individual(cfg::Config, fitness::T=zero(T)) where {T}
    # first fill the grid with randomly chosen function nodes
    f_nodes = [FunctionNode(rand(cfg.function_set)) for i in 1:cfg.num_rows, j in 1:cfg.num_cols]
    ind = Individual(f_nodes, fitness)
    # second, connect these nodes and terminal nodes randomly
    for r = 1:cfg.num_rows, c = 1:cfg.num_cols
        fn = ind.function_nodes[r, c]
        for i = 1:arity(fn.func) # connect every possible input into `fn`
            # shall we connect a terminal or function node as the input?
            if c == 1 || rand() < cfg.terminal_prob
                fn.input_nodes[i] = rand(cfg.terminal_nodes)
            else
                # enforced by level back 
                fn.input_nodes[i] = rand(@view ind.function_nodes[:, max(c - cfg.level_back, 1):c-1])
            end
        end
    end
    return ind
end


