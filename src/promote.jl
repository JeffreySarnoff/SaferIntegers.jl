promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned   where T<:SafeSigned =
    safeint(promote_type(baseint(S), baseint(T)))
promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned   where T<:SafeUnsigned =
    safeint(promote_type(baseint(S), baseint(T)))
promote_rule(::Type{S}, ::Type{T}) where S<:SafeUnsigned where T<:SafeUnsigned =
    safeint(promote_type(baseint(S), baseint(T)))

promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned   where T<:Signed   = S
promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned   where T<:Unsigned = S
promote_rule(::Type{S}, ::Type{T}) where S<:SafeUnsigned where T<:Signed   = S
promote_rule(::Type{S}, ::Type{T}) where S<:SafeUnsigned where T<:Unsigned = S

promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned   where T<:Base.IEEEFloat = T
promote_rule(::Type{S}, ::Type{T}) where S<:SafeUnsigned where T<:Base.IEEEFloat = T

promote_rule(::Type{S}, ::Type{BigFloat}) where S<:SafeSigned  = BigFloat
promote_rule(::Type{S}, ::Type{BigFloat}) where S<:SafeUnsigned = BigFloat
