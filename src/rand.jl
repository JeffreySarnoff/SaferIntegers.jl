if VERSION > v"0.7-"
   import Random.rand
   const Rnd = Random.rand
else
   import Base.rand
   const Rnd = Base.rand
end


Rnd.rand(::Type{T}) where {T<:SafeInteger} = T(rand(integer(T)))
Rnd.rand(::Type{T}, n::I) where {T<:SafeInteger, I<:Integer} = T.(rand(integer(T), n))
Rnd.rand(::Type{T}, n::I) where {T<:SafeInteger, I<:SafeInteger} = T.(rand(integer(T), integer(n)))
Rnd.rand(x::T) where {S<:SafeInteger, T<:UnitRange{S}} = S(rand(integer(x)))
Rnd.rand(x::T, n::I) where {S<:SafeInteger, T<:UnitRange{S}, I<:Integer} = S.(rand(integer(x), n))
Rnd.rand(x::T, n::I) where {S<:SafeInteger, T<:UnitRange{S}, I<:SafeInteger} = S.(rand(integer(x), integer(n)))



