# traits
Base.typemin(::Type{T}) where {T<:SafeInteger} = SafeInteger(typemin(itype(T)))
Base.typemax(::Type{T}) where {T<:SafeInteger} = SafeInteger(typemax(itype(T)))
Base.widen(::Type{T}) where {T<:SafeInteger} = stype(widen(itype(T)))

# predicates
is_safeint(::Type{T}) where T<:SAFEINTEGERS = true
is_safeint(::Type{T}) where T = false
is_safeint(x::T) where T = is_safeint(T)
