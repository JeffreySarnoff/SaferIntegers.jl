if VERSION > v"0.7-"
   import Random.rand
else
   import Base.rand
end
export rand

SafeInt32(x::UnitRange{I}) where {I<:Integer} = UnitRange(SafeInt32(x.start), SafeInt32(x.stop))

rand(::Type{T}) where {T<:SafeInteger} = T(rand(integer(T)))
rand(::Type{T}, n::I) where {T<:SafeInteger, I<:Integer} = T.(rand(integer(T), n))
rand(::Type{T}, n::I) where {T<:SafeInteger, I<:SafeInteger} = T.(rand(integer(T), integer(n)))
rand(x::T) where {S<:SafeInteger, T<:UnitRange{S}} = S(rand(integer(x)))
rand(x::T, n::I) where {S<:SafeInteger, T<:UnitRange{S}, I<:Integer} = S.(rand(integer(x), n))
rand(x::T, n::I) where {S<:SafeInteger, T<:UnitRange{S}, I<:SafeInteger} = S.(rand(integer(x), integer(n)))



