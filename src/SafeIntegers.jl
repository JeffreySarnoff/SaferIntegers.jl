# SafeIntegers := reinterpret(SafeIntegers, RoundingIntegers⦃Tim Holy⦄)

module SafeIntegers

export SafeUnsigned, SafeSigned, SafeInteger,
       SafeUInt, SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128,
       SafeInt, SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128,
       safeint, notsafe

import Base: ==, <, <=, +, -, *, ~, &, |, ⊻, <<, >>, >>>
import Base.Checked: checked_abs, checked_neg, checked_add, checked_sub,
    checked_mul, checked_div, checked_fld, checked_cld, checked_rem, checked_mod

abstract type SafeUnsigned <: Unsigned end
abstract type SafeSigned   <: Signed   end

const SafeInteger = Union{SafeSigned, SafeUnsigned}

primitive type SafeInt8    <: SafeSigned     8 end
primitive type SafeUInt8   <: SafeUnsigned   8 end
primitive type SafeInt16   <: SafeSigned    16 end
primitive type SafeUInt16  <: SafeUnsigned  16 end
primitive type SafeInt32   <: SafeSigned    32 end
primitive type SafeUInt32  <: SafeUnsigned  32 end
primitive type SafeInt64   <: SafeSigned    64 end
primitive type SafeUInt64  <: SafeUnsigned  64 end
primitive type SafeInt128  <: SafeSigned   128 end
primitive type SafeUInt128 <: SafeUnsigned 128 end

if Sys.WORD_SIZE == 32
    const SafeInt  = SafeInt32
    const SafeUInt = SafeUInt32
else
    const SafeInt  = SafeInt64
    const SafeUInt = SafeUInt64
end

itype(::Type{SafeInteger})  = Integer
itype(::Type{SafeSigned})   = Signed
itype(::Type{SafeUnsigned}) = Unsigned
itype(::Type{SafeInt8})    = Int8
itype(::Type{SafeUInt8})   = UInt8
itype(::Type{SafeInt16})   = Int16
itype(::Type{SafeUInt16})  = UInt16
itype(::Type{SafeInt32})   = Int32
itype(::Type{SafeUInt32})  = UInt32
itype(::Type{SafeInt64})   = Int64
itype(::Type{SafeUInt64})  = UInt64
itype(::Type{SafeInt128})  = Int128
itype(::Type{SafeUInt128}) = UInt128
itype(x::SafeInteger) = itype(typeof(x))

stype(::Type{Signed})   = SafeSigned
stype(::Type{Unsigned}) = SafeUnsigned
stype(::Type{Int8})    = SafeInt8
stype(::Type{UInt8})   = SafeUInt8
stype(::Type{Int16})   = SafeInt16
stype(::Type{UInt16})  = SafeUInt16
stype(::Type{Int32})   = SafeInt32
stype(::Type{UInt32})  = SafeUInt32
stype(::Type{Int64})   = SafeInt64
stype(::Type{UInt64})  = SafeUInt64
stype(::Type{Int128})  = SafeInt128
stype(::Type{UInt128}) = SafeUInt128
stype(x::Union{Signed,Unsigned}) = stype(typeof(x))

# We want the *Safety* to be sticky with familiar integer-like numbers
# and to be soapy with non-integer-esque numbers (including BigInt).

Base.promote_rule(::Type{T}, ::Type{SI}) where {T<:Signed, SI<:SafeSigned} =
    promote_type(T, itype(SI))
Base.promote_rule(::Type{T}, ::Type{SU}) where {T<:Unsigned, SU<:SafeUnsigned} =
    promote_type(T, SU)

Base.promote_rule(::Type{T}, ::Type{SI}) where {T<:Real, SI<:SafeInteger} =
    promote_type(T, SI)
Base.promote_rule(::Type{T}, ::Type{SI}) where {T<:Number, SI<:SafeInteger} =
    promote_type(T, itype(SI))

Base.promote_rule(::Type{Rational{T}}, ::Type{SI}) where {T<:Integer, SI<:SafeInteger} =
    promote_type(T, SI)

# Resolve ambiguities
Base.promote_rule(::Type{Bool}, ::Type{SI}) where {SI<:SafeInteger} =
    promote_type(Bool, itype(SI))
Base.promote_rule(::Type{BigInt}, ::Type{SI}) where {SI<:SafeInteger} =
    promote_type(BigInt, itype(SI))
Base.promote_rule(::Type{BigFloat}, ::Type{SI}) where {SI<:SafeInteger} =
    promote_type(BigFloat, itype(SI))
Base.promote_rule(::Type{Complex{T}}, ::Type{SI}) where {T<:Real,SI<:SafeInteger} =
    promote_type(Complex{T}, itype(SI))
Base.promote_rule(::Type{<:Irrational}, ::Type{SI}) where {SI<:SafeInteger} =
    promote_type(Float64, itype(SI))

(::Type{Signed})(x::SafeSigned)     = reinterpret(itype(x), x)
(::Type{Unsigned})(x::SafeUnsigned) = reinterpret(itype(x), x)
(::Type{SafeSigned})(x::Signed)     = reinterpret(stype(x), x)
(::Type{SafeUnsigned})(x::Unsigned) = reinterpret(stype(x), x)
(::Type{Integer})(x::SafeSigned)    = Signed(x)
(::Type{Integer})(x::SafeUnsigned)  = Unsigned(x)
(::Type{SafeInteger})(x::Signed)    = SafeSigned(x)
(::Type{SafeInteger})(x::Unsigned)  = SafeUnsigned(x)

Base.unsigned(x::SafeSigned) = SafeInteger(unsigned(Integer(x)))
Base.signed(x::SafeSigned)   = SafeInteger(signed(Integer(x)))

# Basic conversions
# @inline Base.convert{T<:SafeSigned}(::Type{T}, x::T) = x
# @inline Base.convert{T<:SafeUnsigned}(::Type{T}, x::T) = x
@inline Base.convert(::Type{T}, x::T) where {T<:SafeInteger} = x
@inline Base.convert(::Type{T}, x::Integer) where {T<:SafeInteger} =
    SafeInteger(convert(itype(T), x))
@inline Base.convert(::Type{T}, x::AbstractFloat) where {T<:SafeInteger} =
    SafeInteger(round(itype(T), x))
@inline Base.convert(::Type{T}, x::Number) where {T<:SafeInteger} =
    convert(T, convert(itype(T), x))
@inline Base.convert(::Type{T}, x::SafeInteger) where {T<:SafeInteger} =
    SafeInteger(convert(itype(T), Integer(x)))
@inline Base.convert(::Type{T}, x::SafeInteger) where {T<:Number} =
    convert(T, Integer(x))

# Resolve ambiguities
Base.convert(::Type{Integer}, x::SafeInteger) = Integer(x)
Base.convert(::Type{BigInt}, x::SafeInteger) = convert(BigInt, Integer(x))
Base.convert(::Type{T}, x::BigInt) where {T<:SafeInteger} = SafeInteger(convert(itype(T), x))
Base.convert(::Type{BigFloat}, x::SafeInteger) = convert(BigFloat, Integer(x))
Base.convert(::Type{T}, x::BigFloat) where {T<:SafeInteger} = SafeInteger(convert(itype(T), x))
Base.convert(::Type{Complex{T}}, x::SafeInteger) where {T<:Real} = convert(Complex{T}, Integer(x))
Base.convert(::Type{T}, z::Complex) where {T<:SafeInteger} = SafeInteger(convert(itype(T), z))
Base.convert(::Type{Complex}, x::SafeInteger) = Complex(x)
Base.convert(::Type{T}, x::Rational) where {T<:SafeInteger} = SafeInteger(convert(itype(T)), x)
Base.convert(::Type{Rational{T}}, x::SafeInteger) where {T<:Integer} = convert(Rational{T}, Integer(x))
Base.convert(::Type{Rational}, x::SafeInteger) = convert(Rational{typeof(x)}, x)
Base.convert(::Type{Float16}, x::SafeInteger) = convert(Float16, Integer(x))
Base.convert(::Type{T}, x::Float16) where {T<:SafeInteger} = SafeInteger(convert(itype(T), x))
Base.convert(::Type{Bool}, x::SafeInteger) = convert(Bool, Integer(x))

# rem conversions
@inline Base.rem(x::T, ::Type{T}) where {T<:SafeInteger} = T
@inline Base.rem(x::Integer, ::Type{T}) where {T<:SafeInteger} = SafeInteger(rem(x, itype(T)))
# ambs
@inline Base.rem(x::BigInt, ::Type{T}) where {T<:SafeInteger} = error("no rounding BigInt available")

Base.signbit(x::SafeSigned) = signbit(Integer(x))
Base.sign(x::SafeSigned)    = sign(Integer(x))
Base.abs(x::SafeSigned)     = abs(Integer(x))
Base.abs2(x::SafeSigned)    = abs2(Integer(x))

(< )(x::SafeInteger, y::SafeInteger) = Integer(x) <  Integer(y)
(<=)(x::SafeInteger, y::SafeInteger) = Integer(x) <= Integer(y)

Base.count_ones(x::SafeInteger)     = count_ones(Integer(x))
Base.leading_zeros(x::SafeInteger)  = leading_zeros(Integer(x))
Base.trailing_zeros(x::SafeInteger) = trailing_zeros(Integer(x))
Base.ndigits0z(x::SafeInteger)      = Base.ndigits0z(Integer(x))

Base.flipsign(x::SafeSigned, y::SafeSigned) = SafeInteger(flipsign(Integer(x), Integer(y)))
Base.copysign(x::SafeSigned, y::SafeSigned) = SafeInteger(copysign(Integer(x), Integer(y)))

# A few operations preserve the type
(~)(x::SafeInteger) = SafeInteger(~Integer(x))

(&)(x::T, y::T) where {T<:SafeInteger} = SafeInteger(Integer(x) & Integer(y))
(|)(x::T, y::T) where {T<:SafeInteger} = SafeInteger(Integer(x) | Integer(y))
(⊻)(x::T, y::T) where {T<:SafeInteger} = SafeInteger(Integer(x) ⊻ Integer(y))

(>> )(x::SafeInteger, y::Signed)   = SafeInteger(Integer(x) >> y)
(>>>)(x::SafeInteger, y::Signed)   = SafeInteger(Integer(x) >>> y)
(<< )(x::SafeInteger, y::Signed)   = SafeInteger(Integer(x) << y)
(>> )(x::SafeInteger, y::Unsigned) = SafeInteger(Integer(x) >> y)
(>>>)(x::SafeInteger, y::Unsigned) = SafeInteger(Integer(x) >>> y)
(<< )(x::SafeInteger, y::Unsigned) = SafeInteger(Integer(x) << y)
# ambs
(>> )(x::SafeInteger, y::Int) = SafeInteger(Integer(x) >> y)
(>>>)(x::SafeInteger, y::Int) = SafeInteger(Integer(x) >>> y)
(<< )(x::SafeInteger, y::Int) = SafeInteger(Integer(x) << y)

(-)(x::T) where {T<:SafeInteger} = SafeInteger(checked_neg(Integer(x)))
(+)(x::T, y::T) where {T<:SafeInteger} = SafeInteger(checked_add(Integer(x), Integer(y)))
(-)(x::T, y::T) where {T<:SafeInteger} = SafeInteger(checked_sub(Integer(x), Integer(y)))
(*)(x::T, y::T) where {T<:SafeInteger} = SafeInteger(checked_mul(Integer(x), Integer(y)))

Base.div(x::T, y::T) where {T<:SafeInteger} = SafeInteger(checked_div(Integer(x), Integer(y)))
Base.fld(x::T, y::T) where {T<:SafeInteger} = SafeInteger(checked_fld(Integer(x), Integer(y)))
Base.cld(x::T, y::T) where {T<:SafeInteger} = SafeInteger(checked_cld(Integer(x), Integer(y)))
Base.rem(x::T, y::T) where {T<:SafeInteger} = SafeInteger(checked_rem(Integer(x), Integer(y)))
Base.mod(x::T, y::T) where {T<:SafeInteger} = SafeInteger(checked_mod(Integer(x), Integer(y)))

# traits
Base.typemin(::Type{T}) where {T<:SafeInteger} = SafeInteger(typemin(itype(T)))
Base.typemax(::Type{T}) where {T<:SafeInteger} = SafeInteger(typemax(itype(T)))
Base.widen(::Type{T}) where {T<:SafeInteger} = stype(widen(itype(T)))

# foldable toolkit
notsafe(x::T) where T<:SafeInteger = reinterpret(itype(T), x)
safeint(x::T) where T<:Integer = reinterpret(stype(T), x)

# showing

function Base.string(x::T) where T<:SafeInt
    y = notsafe(x)
    return string(y)
end

Base.show(io::IO, x::T) where T<:SafeInt = print(io, string(x))

end # module SafeIntegers
