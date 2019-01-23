Random.rand(::Type{T}) where {T<:SafeInteger} = T(rand(baseint(T)))
Random.rand(::Type{T}, n::I) where {T<:SafeInteger, I<:Integer} = T.(rand(baseint(T), n))
Random.rand(::Type{T}, n::I) where {T<:SafeInteger, I<:SafeInteger} = T.(rand(baseint(T), baseint(n)))
Random.rand(x::T) where {S<:SafeInteger, T<:UnitRange{S}} = S(rand(baseint(x)))
Random.rand(x::T, n::I) where {S<:SafeInteger, T<:UnitRange{S}, I<:Integer} = S.(rand(baseint(x), n))
Random.rand(x::T, n::I) where {S<:SafeInteger, T<:UnitRange{S}, I<:SafeInteger} = S.(rand(baseint(x), baseint(n)))
# allocates less
Random.rand(ur::UnitRange{SI}, n::Int) where {SI<:SafeInteger} = Random.rand(SI.(Int.(ur)),n)
