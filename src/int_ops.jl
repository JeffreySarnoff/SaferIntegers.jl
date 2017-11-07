Base.zero(::Type{T}) where T<:SafeInteger = reinterpret(T, zero(itype(T)))
Base.one(::Type{T})  where T<:SafeInteger = reinterpret(T, one(itype(T)))
@inline Base.zero(x::T) where T<:SafeInteger = zero(T)
@inline Base.one(x::T)  where T<:SafeInteger = one(T)

Base.sizeof(x::T) where T<:SafeSigned   = SafeSigned(sizeof(itype(T)))
Base.sizeof(x::T) where T<:SafeUnsigned = SafeUnsigned(sizeof(itype(T)))

bitsof(x::T) where T<:SafeSigned   = SafeSigned(sizeof(itype(T)) << 3)
bitsof(x::T) where T<:SafeUnsigned = SafeUnsigned(sizeof(itype(T)) << 3)

Base.signbit(x::SafeSigned) = signbit(Integer(x))
Base.sign(x::SafeSigned)    = sign(Integer(x))
Base.abs(x::SafeSigned)     = abs(Integer(x))
Base.abs2(x::SafeSigned)    = abs2(Integer(x))

Base.signbit(x::SafeUnsigned) = false
Base.sign(x::T) where T<:SafeUnsigned = one(T)
Base.abs(x::SafeUnsigned)     = x
Base.abs2(x::SafeUnsigned)    = x*x

Base.count_ones(x::SafeInteger)     = count_ones(Integer(x))
Base.leading_zeros(x::SafeInteger)  = leading_zeros(Integer(x))
Base.trailing_zeros(x::SafeInteger) = trailing_zeros(Integer(x))
Base.leading_ones(x::SafeInteger)   = leading_ones(Integer(x))
Base.trailing_ones(x::SafeInteger)  = trailing_ones(Integer(x))
Base.ndigits0z(x::SafeInteger)      = Base.ndigits0z(Integer(x))

Base.:(~)(x::SafeInteger) = SafeInteger(~Integer(x))
Base.:(-)(x::SafeInteger) = SafeInteger(-Integer(x))
function Base.:(-)(x::T) where T<:SafeSigned
    x === typemin(T) && throw(OverflowError())
    return SafeInteger(-Integer(x))
end
function Base.:(-)(x::T) where T<:SafeUnsigned
    x === typemin(T) && throw(OverflowError())
    return SafeInteger(-Integer(x))
end

# traits
Base.typemin(::Type{T}) where {T<:SafeInteger} = SafeInteger(typemin(itype(T)))
Base.typemax(::Type{T}) where {T<:SafeInteger} = SafeInteger(typemax(itype(T)))
Base.widen(::Type{T}) where {T<:SafeInteger} = stype(widen(itype(T)))
