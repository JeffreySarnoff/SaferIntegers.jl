module SaferIntegers

export SafeInteger, SafeSigned, SafeUnsigned,
       SafeInt, SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128,
       SafeUInt, SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128,
       @saferintegers,
       SafeRational

import Base.Checked: checked_neg, checked_abs, checked_add, checked_sub, checked_mul,
                     checked_div, checked_rem, checked_fld, checked_mod, checked_cld,
                     add_with_overflow, sub_with_overflow, mul_with_overflow

import Base: promote_rule,
    string, bitstring, show, repr, parse, tryparse,
    (~), (&), (|), (⊻), (>>>), (>>), (<<),
    (<), (<=), (==), (!=), (>=), (>),
    isequal, isless,
    abs, abs2,
    (+), (-), (*), (/), (\), (^), 
    div, fld, fld1, cld, rem, mod, mod1, divrem, fldmod, fldmod1,
    zero, one, sizeof, typemax, typemin, widen,
    signbit, sign, count_ones, count_zeros, ndigits0z,
    leading_zeros, trailing_zeros, leading_ones, trailing_ones,
    copysign, flipsign,
    gcd, lcm, divgcd

using Random

include("type.jl")
include("construct.jl")
include("promote.jl")
include("int_ops.jl")
include("binary_ops.jl")
include("arith_ops.jl")
include("pow.jl")
include("string_io.jl")
include("parse.jl")
include("rand.jl")
include("cover.jl")

include("SaferIntTypes.jl")
using .SaferIntTypes

include("SaferRationalTypes.jl")

end # module SaferIntegers
