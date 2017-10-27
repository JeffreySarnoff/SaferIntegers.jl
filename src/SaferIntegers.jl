# SafeIntegers := reinterpret(SafeIntegers, RoundingIntegers⦃Tim Holy⦄)
__precompile__()

module SaferIntegers

export SafeUnsigned, SafeSigned, SafeInteger,
       SafeUInt, SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128,
       SafeInt, SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128,
       is_safeint, two, negone,
       unsafe_logicalshift_right, unsafe_logicalshift_left, unsafe_arithshift_right


include("primitive_types.jl")

include("type_unions.jl")
include("type_translation.jl")
include("type_conversion.jl")

include("unary_ops.jl")
include("binary_ops.jl")
include("shift_ops.jl")
include("arith_ops.jl")

include("string_show.jl")
include("traits_predicates.jl")


end # module SafeIntegers
