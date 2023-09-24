module CGPBool

include("bool_function.jl")
include("component.jl")
include("genetic_modification.jl")

export create_terminal_nodes, create_random_individual, Config, FunctionNode, TerminalNode, Individual


end # module CGPBool
