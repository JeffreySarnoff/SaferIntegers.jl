import Base: zero, one, sizeof, typemax, typemin, widen,
             signbit, sign, (~), (-), count_ones, count_zeros, ndigits0z,
             leading_zeros, trailing_zeros, leading_ones, trailing_ones,
             copysign, flipsign

for S in (:SafeSigned, :SafeUnsigned)
  @eval begin
    zero(::Type{T}) where T<:$S = safeint(zero(integer(T)))
    one(::Type{T})  where T<:$S = safeint(one(integer(T)))
    sizeof(::Type{T}) where T<:$S  = safeint(sizeof(integer(T)))
    bitsof(::Type{T}) where T<:$S  = safeint(sizeof(integer(T)) << 3)
    @inline zero(x::T) where T<:$S = zero(T)
    @inline one(x::T)  where T<:$S = one(T)
    @inline sizeof(x::T) where T<:$S = sizeof(T)
    @inline bitsof(x::T) where T<:$S = bitsof(T)
    ndigits0z(n::T) where T<:$S = ndigits0z(integer(x)) # do not reconvert
    ndigits0z(n::T1, b::T2) where T1<:$S where T2<:SafeInteger = ndigits0z(integer(x), integer(b)) # do not reconvert
    ndigits0z(n::T1, b::T2) where T1<:$S where T2<:Integer = ndigits0z(integer(x), b) # do not reconvert
    @inline count_zeros(x::T) where T<:$S = safeint(count_zeros(integer(x)))
    @inline count_ones(x::T) where T<:$S = safeint(count_ones(integer(x)))
    @inline leading_zeros(x::T) where T<:$S = safeint(leading_zeros(integer(x)))
    @inline trailing_zeros(x::T) where T<:$S = safeint(trailing_zeros(integer(x)))
    @inline leading_ones(x::T) where T<:$S = safeint(leading_ones(integer(x)))
    @inline trailing_ones(x::T) where T<:$S = safeint(trailing_ones(integer(x)))
  end
end

@inline signbit(x::T) where T<:SafeSigned = signbit(integer(x))
@inline signbit(x::T) where T<:SafeUnsigned = false
@inline sign(x::T) where T<:SafeSigned = safeint(sign(integer(x)))
@inline sign(x::T) where T<:SafeUnsigned = one(T)

function abs(x::T) where T<:SafeSigned
  x === typemin(x) && throw(OverflowError())
  return safeint(abs(integer(x)))
end  
abs(x::T) where T<:SafeUnsigned = x

function abs2(x::T) where T<:SafeSigned
  x === typemin(x) && throw(OverflowError())
  y = Base.Checked.checked_mul(x, x)      
  return y
end
function abs2(x::T) where T<:SafeUnsigned
  y = Base.Checked.checked_mul(x, x)      
  return y
end

@inline function Base.:(-)(x::T) where T<:SafeSigned
  x === typemin(x) && throw(OverflowError())
  return safeint(-(integer(x)))
end  
@inline Base.:(-)(x::T) where T<:SafeUnsigned = safeint(-integer(x))

@inline function copysign(x::T, y::T) where T<:SafeSigned
  return safeint(integer( signbit(y) ? -abs(x) : x ))
end  
@inline copysign(x::T, y::T) where T<:SafeUnsigned = x

@inline function flipsign(x::T, y::T) where T<:SafeSigned
  return safeint(integer( signbit(y) ? -(x) : x ))
end  
@inline flipsign(x::T, y::T) where T<:SafeUnsigned = x

# traits
typemin(::Type{T}) where {T<:SafeInteger} = safeint(typemin(integer(T)))
typemax(::Type{T}) where {T<:SafeInteger} = safeint(typemax(integer(T)))
widen(::Type{T}) where {T<:SafeInteger} = safeint(widen(integer(T)))
