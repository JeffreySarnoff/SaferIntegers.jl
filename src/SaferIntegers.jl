module SaferIntegers

export SafeInteger, SafeSigned, SafeUnsigned,
       SafeInt, SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128,
       SafeUInt, SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128

export UI8, UI16, UI32, UI64, UI128,
       I8, I16, I32, I64, I128

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

if isdefined(Main, USE_SAFE_INTS) && USE_SAFE_INTS
    const UI8 = SafeUInt8
    const UI16 = SafeUInt16
    const UI32 = SafeUInt32
    const UI64 = SafeUInt64
    const UI128 = SafeUInt128
    const I8 = SafeInt8
    const I16 = SafeInt16
    const I32 = SafeInt32
    const I64 = SafeInt64
    const I128 = SafeInt128
else
    const UI8 = UInt8
    const UI16 = UInt16
    const UI32 = UInt32
    const UI64 = UInt64
    const UI128 = UInt128
    const I8 = Int8
    const I16 = Int16
    const I32 = Int32
    const I64 = Int64
    const I128 = Int128
end

end # module SaferIntegers
