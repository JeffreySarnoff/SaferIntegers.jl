module SaferIntegers

export SafeInteger, SafeSigned, SafeUnsigned,
       SafeInt, SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128,
       SafeUInt, SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128

export UInt8, UInt16, UInt32, UInt64, UInt128,
       Int8, Int16, Int32, Int64, Int128

import Core: UInt8, UInt16, UInt32, UInt64, UInt128,
             Int8, Int16, Int32, Int64, Int128

import Base.Checked: checked_add, checked_sub, checked_mul,
                     checked_div, checked_fld, checked_cld,
                     checked_rem, checked_mod

import Base: string, bitstring, show,
    (~), (&), (|), (⊻), (>>>), (>>), (<<),
    (<), (<=), (==), (!=), (>=), (>), 
    isequal, isless,
    (+), (-), (*), (/), (\), div, fld, cld, rem, mod,
    zero, one, sizeof, typemax, typemin, widen,
    signbit, sign, count_ones, count_zeros, ndigits0z,
    leading_zeros, trailing_zeros, leading_ones, trailing_ones,
    copysign, flipsign


include("type.jl")
include("construct.jl")
include("promote.jl")
include("int_ops.jl")
include("binary_ops.jl")
include("arith_ops.jl")
include("pow.jl")
include("string_io.jl")
include("rand.jl")

end # module SaferIntegers
