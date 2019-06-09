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

promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned   where T<:AbstractFloat = T
promote_rule(::Type{S}, ::Type{T}) where S<:SafeUnsigned where T<:AbstractFloat = T

promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned   where T<:Real = T
promote_rule(::Type{S}, ::Type{T}) where S<:SafeUnsigned where T<:Real = T

promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned   where T<:Number = T
promote_rule(::Type{S}, ::Type{T}) where S<:SafeUnsigned where T<:Number = T
