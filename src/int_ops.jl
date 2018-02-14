import Base: zero, one, sizeof, typemax, typemin, widen,
             signbit, sign, (~), (-), count_ones, ndigits0z,
             leading_zeros, trailing_zeros, leading_ones, trailing_ones

zero(::Type{T}) where T<:SafeInteger = reinterpret(T, zero(integer(T)))
one(::Type{T})  where T<:SafeInteger = reinterpret(T, one(integer(T)))
sizeof(::Type{T}) where T<:SafeInteger  = safeint(sizeof(integer(T)))
bitsof(::Type{T}) where T<:SafeInteger  = safeint(sizeof(integer(T)) << 3)
@inline zero(x::T) where T<:SafeInteger = zero(T)
@inline one(x::T)  where T<:SafeInteger = one(T)
@inline sizeof(x::T) where T<:SafeInteger = sizeof(T)
@inline bitsof(x::T) where T<:SafeInteger = bitsof(T)

@inline signbit(x::T) where T<:SafeSigned = signbit(integer(x))
@inline signbit(x::T) where T<:SafeUnsigned = false
@inline sign(x::T) where T<:SafeInteger = safeint(sign(integer(x)))

ndigits0z(n::T) where T<:SafeInteger = ndigits0z(integer(x)) # do not reconvert
ndigits0z(n::T1, b::T2) where T1<:SafeInteger where T2<:SafeInteger = ndigits0z(integer(x), integer(b)) # do not reconvert
ndigits0z(n::T1, b::T2) where T1<:SafeInteger where T2<:Integer = ndigits0z(integer(x), b) # do not reconvert

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

@inline function -(x::T) where T<:SafeSigned
  x === typemin(x) && throw(OverflowError())
  return safeint(-(integer(x)))
end  
@inline (-)(x::T) where T<:SafeUnsigned = safeint(-integer(x))

@inline count_ones(x::T) where T<:SafeInteger = safeint(count_ones(integer(x)))
    
for OP in (:(~), :leading_zeros, :trailing_zeros, :leading_ones, :trailing_ones)
    @eval begin
        @inline $OP(x::T) where T<:SafeInteger = safeint($OP(integer(x)))
    end
end

# traits
typemin(::Type{T}) where {T<:SafeInteger} = safeint(typemin(integer(T)))
typemax(::Type{T}) where {T<:SafeInteger} = safeint(typemax(integer(T)))
widen(::Type{T}) where {T<:SafeInteger} = safeint(widen(integer(T)))
