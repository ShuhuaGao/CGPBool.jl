# Use bitwise operators as common logical functions

# and 
arity(::typeof(&)) = 2

# or
arity(::typeof(|)) = 2

# not
arity(::typeof(~)) = 1

# noop: `identity` is a builtin function that does nothing
arity(::typeof(identity)) = 1

# give a short name to `identity` called "○" (\bigcirc symbol)
Base.string(::typeof(identity)) = "○"

const MAX_ARITY = 2