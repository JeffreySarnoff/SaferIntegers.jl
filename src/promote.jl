import Base: promote_rule

promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned where T<:SafeSigned =
    stype(promote_type(itype(S), itype(T)))
promote_rule(::Type{S}, ::Type{T}) where S<:SafeUnsigned where T<:SafeUnsigned =
    stype(promote_type(itype(S), itype(T)))
promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned where T<:SafeUnsigned =
    stype(promote_type(itype(S), itype(T)))

promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned where T<:Signed =
    stype(promote_type(itype(S), itype(T)))
promote_rule(::Type{S}, ::Type{T}) where S<:SafeUnsigned where T<:Unsigned =
    stype(promote_type(itype(S), itype(T)))
promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned where T<:Unsigned =
    stype(promote_type(itype(S), itype(T)))
promote_rule(::Type{S}, ::Type{T}) where S<:SafeUnsigned where T<:Signed =
    stype(promote_type(itype(S), itype(T)))
