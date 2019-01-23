module SaferIntegers

export SafeInteger, SafeSigned, SafeUnsigned,
       SafeInt, SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128,
       SafeUInt, SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128

export AkoInt, AkoInt8, AkoInt16, AkoInt32, AkoInt64, AkoInt128,
       AkoUInt, AkoUInt8, AkoUInt16, AkoUInt32, AkoUInt64, AkoUInt128
       
import Base.Checked: checked_add, checked_sub, checked_mul,
                     checked_div, checked_fld, checked_cld,
                     checked_rem, checked_mod

import Base: promote_rule, 
    string, bitstring, show,
    (~), (&), (|), (⊻), (>>>), (>>), (<<),
    (<), (<=), (==), (!=), (>=), (>), 
    isequal, isless,
    (+), (-), (*), (/), (\), div, fld, cld, rem, mod, divrem, fldmod,
    zero, one, sizeof, typemax, typemin, widen,
    signbit, sign, count_ones, count_zeros, ndigits0z,
    leading_zeros, trailing_zeros, leading_ones, trailing_ones,
    copysign, flipsign

using Random

include("type.jl")
include("construct.jl")
include("promote.jl")
include("int_ops.jl")
include("binary_ops.jl")
include("arith_ops.jl")
include("pow.jl")
include("string_io.jl")
include("rand.jl")

if haskey(ENV, "USE_SAFE_INTS") && ENV["USE_SAFE_INTS"] == "true"
    println("safe")
    const AkoInt = Int === Int64 ? SafeInt64 : SafeInt32
    const AkoInt8 = SafeInt8
    const AkoInt16 = SafeInt16
    const AkoInt32 = SafeInt32
    const AkoInt64 = SafeInt64
    const AkoInt128 = SafeInt128
    const AkoUInt = Int === Int64 ? SafeUInt64 : SafeUInt32
    const AkoUInt8 = SafeUInt8
    const AkoUInt16 = SafeUInt16
    const AkoUInt32 = SafeUInt32
    const AkoUInt64 = SafeUInt64
    const AkoUInt128 = SafeUInt128
else
    println("unsafe")
    const AkoInt = Int === Int64 ? Int64 : Int32
    const AkoInt8 = Int8
    const AkoInt16 = Int16
    const AkoInt32 = Int32
    const AkoInt64 = Int64
    const AkoInt128 = Int128
    const AkoUInt = Int === Int64 ? UInt64 : UInt32
    const AkoUIntI8 = UInt8
    const AkoUInt16 = UInt16
    const AkoUInt32 = UInt32
    const AkoUInt64 = UInt64
    const AkoUInt128 = UInt128
end

end # module SaferIntegers
