
# node
abstract type AbstractNode end

struct TerminalNode <: AbstractNode
    i_variable::Int  # which variable this node corresponds to
    outputs::Vector{Bool}  # the value of this variable in multiple data points
end

TerminalNode(i_variable::Int) = TerminalNode(i_variable, Bool[])


mutable struct FunctionNode <: AbstractNode
    func::Function
    input_nodes::Vector{AbstractNode}
    outputs::Vector{Bool}
    active::Bool
end

"""
    FunctionNode(func::Function)

Construct a function node. It is assigned [`CGPBool.MAX_ARITY`](@ref) input nodes of an undefined value. 
Outputs are an empty Bool array, and it is not activated.
"""
FunctionNode(func::Function) = FunctionNode(func, Vector{AbstractNode}(undef, MAX_ARITY), Bool[], false)


# individual
"""
    mutable struct Individual{T}

Represent an individual (i.e., a potential solution) in CGP. The type parameter `T` specifies the type
of fitness such that more sophisticated assessment of an individual is possible, e.g., a tuple of criteria.
"""
mutable struct Individual{T}
    function_nodes::Matrix{FunctionNode}   # only need to store the function nodes
    output_node::FunctionNode       # pick one of `f_nodes` as the output 
    fitness::T
    active_determined::Bool
end


"""
    Individual(f_nodes::AbstractMatrix{FunctionNode}, fitness::T=zero(T)) where {T}

Create an individual with function nodes `f_nodes` and the given `fitness`. Its activation status defaults to `false`.
The output node is chosen randomly among the function nodes.
"""
function Individual(f_nodes::AbstractMatrix{FunctionNode}, fitness::T=zero(T)) where {T}
    function_nodes = deepcopy(f_nodes)
    output_node = rand(function_nodes)
    return Individual(function_nodes, output_node, deepcopy(fitness), false)
end


# configuration
"""
    Base.@kwdef mutable struct Config

Global hyper-parameters and data for CGP.
"""
Base.@kwdef mutable struct Config
    num_rows::Int = 5
    num_cols::Int = 20
    level_back::Int = 5
    mutation_rate::Float64 = 0.1
    crossover_rate::Float64 = 0.1
    max_generations::Int = 100
    population_size::Int = 10
    function_set::Vector{Function} = [&, |, ~, identity]
    terminal_nodes::Vector{TerminalNode} = TerminalNode[]  # shared among all individuals
    max_arity::Int = MAX_ARITY
    terminal_prob::Float64 = 0.4 # when connecting an input of a function node, how likely it is to be a terminal node
end
