
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
