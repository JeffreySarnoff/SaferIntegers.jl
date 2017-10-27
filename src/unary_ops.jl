Base.zero(::Type{T}) where T<:SAFEINTEGERS = reinterpret(T, zero(itype(T)))
Base.one(::Type{T})  where T<:SAFEINTEGERS = reinterpret(T, one(itype(T)))
@inline Base.zero(x::T) where T<:SAFEINTEGERS = zero(T)
@inline Base.one(x::T)  where T<:SAFEINTEGERS = one(T)

two(::Type{T}) where T<:UNSAFEINTEGERS = reinterpret(T, one(T)<<one(Int32))
@inline two(x::T) where T<:UNSAFEINTEGERS = two(T)
negone(::Type{T}) where T<:UNSAFESIGNED = -one(T)
@inline negone(x::T) where T<:UNSAFESIGNED = negone(T)

two(::Type{T}) where T<:SAFEINTEGERS = reinterpret(T, one(itype(T))<<one(Int32))
@inline two(x::T) where T<:SAFEINTEGERS = two(T)
negone(::Type{T}) where T<:SAFESIGNED = reinterpret(T, -one(itype(T)))
@inline negone(x::T) where T<:SAFESIGNED = negone(T)


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
Base.ndigits0z(x::SafeInteger)      = Base.ndigits0z(Integer(x))

Base.:(~)(x::SafeInteger) = SafeInteger(~Integer(x))
Base.:(-)(x::SafeInteger) = SafeInteger(-Integer(x))

