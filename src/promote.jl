import Base: promote_rule, promote_type


promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned T<:SafeSigned =
    stype(promote_type(itype(S), itype(T)))
promote_rule(::Type{S}, ::Type{T}) where S<:SafeUnsigned T<:SafeUnsigned =
    stype(promote_type(itype(S), itype(T)))
promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned T<:SafeUnsigned =
    stype(promote_type(itype(S), itype(T)))

promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned T<:Signed =
    stype(promote_type(itype(S), itype(T)))
promote_rule(::Type{S}, ::Type{T}) where S<:SafeUnsigned T<:Unsigned =
    stype(promote_type(itype(S), itype(T)))
promote_rule(::Type{S}, ::Type{T}) where S<:SafeSigned T<:Unsigned =
    stype(promote_type(itype(S), itype(T)))
promote_rule(::Type{S}, ::Type{T}) where S<:SafeUnsigned T<:Signed =
    stype(promote_type(itype(S), itype(T)))

#=
promote_rule(::Type{SafeInt8}, ::Type{SafeInt16})   = SafeInt16
promote_rule(::Type{SafeInt8}, ::Type{SafeInt32})   = SafeInt32
promote_rule(::Type{SafeInt8}, ::Type{SafeInt64})   = SafeInt64
promote_rule(::Type{SafeInt8}, ::Type{SafeInt128})  = SafeInt128
promote_rule(::Type{SafeInt16}, ::Type{SafeInt32})  = SafeInt32
promote_rule(::Type{SafeInt16}, ::Type{SafeInt64})  = SafeInt64
promote_rule(::Type{SafeInt16}, ::Type{SafeInt128}) = SafeInt128
promote_rule(::Type{SafeInt32}, ::Type{SafeInt64})  = SafeInt64
promote_rule(::Type{SafeInt32}, ::Type{SafeInt128}) = SafeInt128
promote_rule(::Type{SafeInt64}, ::Type{SafeInt128}) = SafeInt128

promote_rule(::Type{SafeUInt8}, ::Type{SafeUInt16})   = SafeUInt16
promote_rule(::Type{SafeUInt8}, ::Type{SafeUInt32})   = SafeUInt32
promote_rule(::Type{SafeUInt8}, ::Type{SafeUInt64})   = SafeUInt64
promote_rule(::Type{SafeUInt8}, ::Type{SafeUInt128})  = SafeUInt128
promote_rule(::Type{SafeUInt16}, ::Type{SafeUInt32})  = SafeUInt32
promote_rule(::Type{SafeUInt16}, ::Type{SafeUInt64})  = SafeUInt64
promote_rule(::Type{SafeUInt16}, ::Type{SafeUInt128}) = SafeUInt128
promote_rule(::Type{SafeUInt32}, ::Type{SafeUInt64})  = SafeUInt64
promote_rule(::Type{SafeUInt32}, ::Type{SafeUInt128}) = SafeUInt128
promote_rule(::Type{SafeUInt64}, ::Type{SafeUInt128}) = SafeUInt128

promote_rule(::Type{Int8}, ::Type{SafeInt8})     = SafeInt8
promote_rule(::Type{Int8}, ::Type{SafeInt16})    = SafeInt16
promote_rule(::Type{Int8}, ::Type{SafeInt32})    = SafeInt32
promote_rule(::Type{Int8}, ::Type{SafeInt64})    = SafeInt64
promote_rule(::Type{Int8}, ::Type{SafeInt128})   = SafeInt128
promote_rule(::Type{Int16}, ::Type{SafeInt8})    = SafeInt16
promote_rule(::Type{Int16}, ::Type{SafeInt16})   = SafeInt16
promote_rule(::Type{Int16}, ::Type{SafeInt32})   = SafeInt32
promote_rule(::Type{Int16}, ::Type{SafeInt64})   = SafeInt64
promote_rule(::Type{Int16}, ::Type{SafeInt128})  = SafeInt128
promote_rule(::Type{Int32}, ::Type{SafeInt8})    = SafeInt32
promote_rule(::Type{Int32}, ::Type{SafeInt16})   = SafeInt32
promote_rule(::Type{Int32}, ::Type{SafeInt32})   = SafeInt32
promote_rule(::Type{Int32}, ::Type{SafeInt64})   = SafeInt64
promote_rule(::Type{Int32}, ::Type{SafeInt128})  = SafeInt128
promote_rule(::Type{Int64}, ::Type{SafeInt8})    = SafeInt64
promote_rule(::Type{Int64}, ::Type{SafeInt16})   = SafeInt64
promote_rule(::Type{Int64}, ::Type{SafeInt32})   = SafeInt64
promote_rule(::Type{Int64}, ::Type{SafeInt64})   = SafeInt64
promote_rule(::Type{Int64}, ::Type{SafeInt128})  = SafeInt128
promote_rule(::Type{Int128}, ::Type{SafeInt8})   = SafeInt128
promote_rule(::Type{Int128}, ::Type{SafeInt16})  = SafeInt128
promote_rule(::Type{Int128}, ::Type{SafeInt32})  = SafeInt128
promote_rule(::Type{Int128}, ::Type{SafeInt64})  = SafeInt128
promote_rule(::Type{Int128}, ::Type{SafeInt128}) = SafeInt128

promote_rule(::Type{UInt8}, ::Type{SafeUInt8})     = SafeUInt8
promote_rule(::Type{UInt8}, ::Type{SafeUInt16})    = SafeUInt16
promote_rule(::Type{UInt8}, ::Type{SafeUInt32})    = SafeUInt32
promote_rule(::Type{UInt8}, ::Type{SafeUInt64})    = SafeUInt64
promote_rule(::Type{UInt8}, ::Type{SafeUInt128})   = SafeUInt128
promote_rule(::Type{UInt16}, ::Type{SafeUInt8})    = SafeUInt16
promote_rule(::Type{UInt16}, ::Type{SafeUInt16})   = SafeUInt16
promote_rule(::Type{UInt16}, ::Type{SafeUInt32})   = SafeUInt32
promote_rule(::Type{UInt16}, ::Type{SafeUInt64})   = SafeUInt64
promote_rule(::Type{UInt16}, ::Type{SafeUInt128})  = SafeUInt128
promote_rule(::Type{UInt32}, ::Type{SafeUInt8})    = SafeUInt32
promote_rule(::Type{UInt32}, ::Type{SafeUInt16})   = SafeUInt32
promote_rule(::Type{UInt32}, ::Type{SafeUInt32})   = SafeUInt32
promote_rule(::Type{UInt32}, ::Type{SafeUInt64})   = SafeUInt64
promote_rule(::Type{UInt32}, ::Type{SafeUInt128})  = SafeUInt128
promote_rule(::Type{UInt64}, ::Type{SafeUInt8})    = SafeUInt64
promote_rule(::Type{UInt64}, ::Type{SafeUInt16})   = SafeUInt64
promote_rule(::Type{UInt64}, ::Type{SafeUInt32})   = SafeUInt64
promote_rule(::Type{UInt64}, ::Type{SafeUInt64})   = SafeUInt64
promote_rule(::Type{UInt64}, ::Type{SafeUInt128})  = SafeUInt128
promote_rule(::Type{UInt128}, ::Type{SafeUInt8})   = SafeUInt128
promote_rule(::Type{UInt128}, ::Type{SafeUInt16})  = SafeUInt128
promote_rule(::Type{UInt128}, ::Type{SafeUInt32})  = SafeUInt128
promote_rule(::Type{UInt128}, ::Type{SafeUInt64})  = SafeUInt128
promote_rule(::Type{UInt128}, ::Type{SafeUInt128}) = SafeUInt128

promote_rule(::Type{Int8}, ::Type{SafeUInt8})     = SafeUInt8
promote_rule(::Type{Int8}, ::Type{SafeUInt16})    = SafeUInt16
promote_rule(::Type{Int8}, ::Type{SafeUInt32})    = SafeUInt32
promote_rule(::Type{Int8}, ::Type{SafeUInt64})    = SafeUInt64
promote_rule(::Type{Int8}, ::Type{SafeUInt128})   = SafeUInt128
promote_rule(::Type{Int16}, ::Type{SafeUInt8})    = SafeUInt16
promote_rule(::Type{Int16}, ::Type{SafeUInt16})   = SafeUInt16
promote_rule(::Type{Int16}, ::Type{SafeUInt32})   = SafeUInt32
promote_rule(::Type{Int16}, ::Type{SafeUInt64})   = SafeUInt64
promote_rule(::Type{Int16}, ::Type{SafeUInt128})  = SafeUInt128
promote_rule(::Type{Int32}, ::Type{SafeUInt8})    = SafeUInt32
promote_rule(::Type{Int32}, ::Type{SafeUInt16})   = SafeUInt32
promote_rule(::Type{Int32}, ::Type{SafeUInt32})   = SafeUInt32
promote_rule(::Type{Int32}, ::Type{SafeUInt64})   = SafeUInt64
promote_rule(::Type{Int32}, ::Type{SafeUInt128})  = SafeUInt128
promote_rule(::Type{Int64}, ::Type{SafeUInt8})    = SafeUInt64
promote_rule(::Type{Int64}, ::Type{SafeUInt16})   = SafeUInt64
promote_rule(::Type{Int64}, ::Type{SafeUInt32})   = SafeUInt64
promote_rule(::Type{Int64}, ::Type{SafeUInt64})   = SafeUInt64
promote_rule(::Type{Int64}, ::Type{SafeUInt128})  = SafeUInt128
promote_rule(::Type{Int128}, ::Type{SafeUInt8})   = SafeUInt128
promote_rule(::Type{Int128}, ::Type{SafeUInt16})  = SafeUInt128
promote_rule(::Type{Int128}, ::Type{SafeUInt32})  = SafeUInt128
promote_rule(::Type{Int128}, ::Type{SafeUInt64})  = SafeUInt128
promote_rule(::Type{Int128}, ::Type{SafeUInt128}) = SafeUInt128

promote_rule(::Type{UInt8}, ::Type{SafeInt8})     = SafeInt8
promote_rule(::Type{UInt8}, ::Type{SafeInt16})    = SafeInt16
promote_rule(::Type{UInt8}, ::Type{SafeInt32})    = SafeInt32
promote_rule(::Type{UInt8}, ::Type{SafeInt64})    = SafeInt64
promote_rule(::Type{UInt8}, ::Type{SafeInt128})   = SafeInt128
promote_rule(::Type{UInt16}, ::Type{SafeInt8})    = SafeInt16
promote_rule(::Type{UInt16}, ::Type{SafeInt16})   = SafeInt16
promote_rule(::Type{UInt16}, ::Type{SafeInt32})   = SafeInt32
promote_rule(::Type{UInt16}, ::Type{SafeInt64})   = SafeInt64
promote_rule(::Type{UInt16}, ::Type{SafeInt128})  = SafeInt128
promote_rule(::Type{UInt32}, ::Type{SafeInt8})    = SafeInt32
promote_rule(::Type{UInt32}, ::Type{SafeInt16})   = SafeInt32
promote_rule(::Type{UInt32}, ::Type{SafeInt32})   = SafeInt32
promote_rule(::Type{UInt32}, ::Type{SafeInt64})   = SafeInt64
promote_rule(::Type{UInt32}, ::Type{SafeInt128})  = SafeInt128
promote_rule(::Type{UInt64}, ::Type{SafeInt8})    = SafeInt64
promote_rule(::Type{UInt64}, ::Type{SafeInt16})   = SafeInt64
promote_rule(::Type{UInt64}, ::Type{SafeInt32})   = SafeInt64
promote_rule(::Type{UInt64}, ::Type{SafeInt64})   = SafeInt64
promote_rule(::Type{UInt64}, ::Type{SafeInt128})  = SafeInt128
promote_rule(::Type{UInt128}, ::Type{SafeInt8})   = SafeInt128
promote_rule(::Type{UInt128}, ::Type{SafeInt16})  = SafeInt128
promote_rule(::Type{UInt128}, ::Type{SafeInt32})  = SafeInt128
promote_rule(::Type{UInt128}, ::Type{SafeInt64})  = SafeInt128
promote_rule(::Type{UInt128}, ::Type{SafeInt128}) = SafeInt128

=#
