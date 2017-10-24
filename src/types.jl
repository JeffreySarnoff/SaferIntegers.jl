const SysUnsigned = Union{UInt8, UInt16, UInt32, UInt64, UInt128}
const SysSigned   = Union{Int8, Int16, Int32, Int64, Int128}
const SysInteger  = Union{SysSigned, SysUnsigned}

abstract type SafeUnsigned <: Unsigned end
abstract type SafeSigned   <: Signed   end

const SafeInteger = Union{SafeSigned, SafeUnsigned}

primitive type SafeInt8    <: SafeSigned     8 end
primitive type SafeInt16   <: SafeSigned    16 end
primitive type SafeInt32   <: SafeSigned    32 end
primitive type SafeInt64   <: SafeSigned    64 end
primitive type SafeInt128  <: SafeSigned   128 end

primitive type SafeUInt8   <: SafeUnsigned   8 end
primitive type SafeUInt16  <: SafeUnsigned  16 end
primitive type SafeUInt32  <: SafeUnsigned  32 end
primitive type SafeUInt64  <: SafeUnsigned  64 end
primitive type SafeUInt128 <: SafeUnsigned 128 end

if Sys.WORD_SIZE == 32
    const SafeInt  = SafeInt32
    const SafeUInt = SafeUInt32
else
    const SafeInt  = SafeInt64
    const SafeUInt = SafeUInt64
end

const SAFESIGNED   = Union{SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128}
const SAFEUNSIGNED = Union{SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128}
const SAFEINTEGERS = Union{SAFESIGNED, SAFEUNSIGNED}

itype(::Type{SafeSigned})   = Signed
itype(::Type{SafeUnsigned}) = Unsigned
itype(::Type{SafeInteger})  = Integer

itype(::Type{SafeInt8})     = Int8
itype(::Type{SafeInt16})    = Int16
itype(::Type{SafeInt32})    = Int32
itype(::Type{SafeInt64})    = Int64
itype(::Type{SafeInt128})   = Int128

itype(::Type{SafeUInt8})    = UInt8
itype(::Type{SafeUInt16})   = UInt16
itype(::Type{SafeUInt32})   = UInt32
itype(::Type{SafeUInt64})   = UInt64
itype(::Type{SafeUInt128})  = UInt128

itype(x::T) where T<:Signed   = T
itype(x::T) where T<:Unsigned = T
itype(x::T) where T<:SafeSigned   = itype(T)
itype(x::T) where T<:SafeUnsigned = itype(T)

stype(::Type{Signed})   = SafeSigned
stype(::Type{Unsigned}) = SafeUnsigned
stype(::Type{Integer})  = SafeSigned

stype(::Type{Int8})     = SafeInt8
stype(::Type{Int16})    = SafeInt16
stype(::Type{Int32})    = SafeInt32
stype(::Type{Int64})    = SafeInt64
stype(::Type{Int128})   = SafeInt128

stype(::Type{UInt8})    = SafeUInt8
stype(::Type{UInt16})   = SafeUInt16
stype(::Type{UInt32})   = SafeUInt32
stype(::Type{UInt64})   = SafeUInt64
stype(::Type{UInt128})  = SafeUInt128

stype(x::T) where T<:SafeSigned   = T
stype(x::T) where T<:SafeUnsigned = T
stype(x::T) where T<:Signed   = stype(T)
stype(x::T) where T<:Unsigned = stype(T)

# We want the *Safety* to be sticky with familiar integer-like numbers
# and to be soapy with non-integer-esque numbers (including BigInt).

Base.promote_rule(::Type{T}, ::Type{SI}) where {T<:Signed, SI<:SafeSigned} =
    promote_type(T, SI)
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

Base.signed(x::T) where T<:SafeSigned     = x
Base.unsigned(x::T) where T<:SafeUnsigned = x
Base.signed(x::T) where T<:SafeUnsigned   = SafeInteger(signed(Integer(x)))
Base.unsigned(x::T) where T<:SafeSigned   = SafeInteger(unsigned(Integer(x)))
