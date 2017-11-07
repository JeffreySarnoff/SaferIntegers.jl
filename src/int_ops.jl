import Base: zero, one, sizeof, typemax, typemin, widen,
             signbit, sign, (~), (-), count_ones, ndigits0z,
             leading_zeros, trailing_zeros, leading_ones, trailing_ones

zero(::Type{T}) where T<:SafeInteger = reinterpret(T, zero(itype(T)))
one(::Type{T})  where T<:SafeInteger = reinterpret(T, one(itype(T)))
sizeof(::Type{T}) where T<:SafeInteger    = stype(sizeof(itype(T)))
bitsof(::Type{T}) where T<:SafeInteger   = stype(sizeof(itype(T)) << 3)
@inline zero(x::T) where T<:SafeInteger = zero(T)
@inline one(x::T)  where T<:SafeInteger = one(T)
@inline sizeof(x::T) where T<:SafeInteger = sizeof(T)
@inline bitsof(x::T) where T<:SafeInteger = bitsof(T)

@inline signbit(x::T) where T<:SafeSigned = signbit(ityped(x))
@inline signbit(x::T) where T<:SafeUnsigned = false
@inline sign(x::T) where T<:SafeInteger = styped(sign(ityped(x)))

ndigits0z(n::T) where T<:SafeInteger = ndigits0z(itype(x)) # do not reconvert
ndigits0z(n::T1, b::T2) where T1<:SafeInteger where T2<:SafeInteger = ndigits0z(itype(x), itype(b)) # do not reconvert
ndigits0z(n::T1, b::T2) where T1<:SafeInteger where T2<:Integer = ndigits0z(itype(x), b) # do not reconvert

function abs(x::T) where T<:SafeSigned
  x === typemin(x) && throw(OverflowError())
  return styped(abs(ityped(x))
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
  return styped(-(ityped(x))
end  
@inline (-)(x::T) where T<:SafeUnsigned = stype(-itype(x))

@inline count_ones(x::T) where T<:SafeInteger = styped(count_ones(ityped(x)))
    
for OP in (:(~), :leading_zeros, :trailing_zeros, :leading_ones, :trailing_ones)
    @eval begin
        @inline $OP(x::T) where T<:SafeInteger = stype($OP(itype(x)))
    end
end

# traits
typemin(::Type{T}) where {T<:SafeInteger} = SafeInteger(typemin(itype(T)))
typemax(::Type{T}) where {T<:SafeInteger} = SafeInteger(typemax(itype(T)))
widen(::Type{T}) where {T<:SafeInteger} = stype(widen(itype(T)))
