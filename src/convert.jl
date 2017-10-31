import Base: convert

@inline convert(::Type{SafeInt8},    x::Int8)    = reinterpret(SafeInt8, x)
@inline convert(::Type{SafeInt16},   x::Int16)   = reinterpret(SafeInt16, x)
@inline convert(::Type{SafeInt32},   x::Int32)   = reinterpret(SafeInt32, x)
@inline convert(::Type{SafeInt64},   x::Int64)   = reinterpret(SafeInt64, x)
@inline convert(::Type{SafeInt128},  x::Int128)  = reinterpret(SafeInt128, x)
@inline convert(::Type{SafeUInt8},   x::UInt8)   = reinterpret(SafeUInt8, x)
@inline convert(::Type{SafeUInt16},  x::UInt16)  = reinterpret(SafeUInt16, x)
@inline convert(::Type{SafeUInt32},  x::UInt32)  = reinterpret(SafeUInt32, x)
@inline convert(::Type{SafeUInt64},  x::UInt64)  = reinterpret(SafeUInt64, x)
@inline convert(::Type{SafeUInt128}, x::UInt128) = reinterpret(SafeUInt128, x)

@inline convert(::Type{SafeInt8},    x::UInt8)    = reinterpret(SafeInt8, convert(Int8, x))
@inline convert(::Type{SafeInt16},   x::UInt16)   = reinterpret(SafeInt16, convert(Int16, x))
@inline convert(::Type{SafeInt32},   x::UInt32)   = reinterpret(SafeInt32, convert(Int32, x))
@inline convert(::Type{SafeInt64},   x::UInt64)   = reinterpret(SafeInt64, convert(Int64, x))
@inline convert(::Type{SafeInt128},  x::UInt128)  = reinterpret(SafeInt128, convert(Int128, x))
@inline convert(::Type{SafeUInt8},   x::Int8)   = reinterpret(SafeUInt8, convert(UInt8, x))
@inline convert(::Type{SafeUInt16},  x::Int16)  = reinterpret(SafeUInt16, convert(UInt16, x))
@inline convert(::Type{SafeUInt32},  x::Int32)  = reinterpret(SafeUInt32, convert(UInt32, x))
@inline convert(::Type{SafeUInt64},  x::Int64)  = reinterpret(SafeUInt64, convert(UInt64, x))
@inline convert(::Type{SafeUInt128}, x::Int128) = reinterpret(SafeUInt128, convert(UInt128, x))

@inline convert(::Type{Int8},    x::SafeInt8)    = reinterpret(Int8, x)
@inline convert(::Type{Int16},   x::SafeInt16)   = reinterpret(Int16, x)
@inline convert(::Type{Int32},   x::SafeInt32)   = reinterpret(Int32, x)
@inline convert(::Type{Int64},   x::SafeInt64)   = reinterpret(Int64, x)
@inline convert(::Type{Int128},  x::SafeInt128)  = reinterpret(Int128, x)
@inline convert(::Type{UInt8},   x::SafeUInt8)   = reinterpret(UInt8, x)
@inline convert(::Type{UInt16},  x::SafeUInt16)  = reinterpret(UInt16, x)
@inline convert(::Type{UInt32},  x::SafeUInt32)  = reinterpret(UInt32, x)
@inline convert(::Type{UInt64},  x::SafeUInt64)  = reinterpret(UInt64, x)
@inline convert(::Type{UInt128}, x::SafeUInt128) = reinterpret(UInt128, x)

@inline convert(::Type{Int8},    x::SafeUInt8)    = reinterpret(Int8, convert(UInt8, x))
@inline convert(::Type{Int16},   x::SafeUInt16)   = reinterpret(Int16, convert(UInt16, x))
@inline convert(::Type{Int32},   x::SafeUInt32)   = reinterpret(Int32, convert(UInt32, x))
@inline convert(::Type{Int64},   x::SafeUInt64)   = reinterpret(Int64, convert(UInt64, x))
@inline convert(::Type{Int128},  x::SafeUInt128)  = reinterpret(Int128, convert(UInt128, x))
@inline convert(::Type{UInt8},   x::SafeInt8)   = reinterpret(UInt8, convert(Int8, x))
@inline convert(::Type{UInt16},  x::SafeInt16)  = reinterpret(UInt16, convert(Int16, x))
@inline convert(::Type{UInt32},  x::SafeInt32)  = reinterpret(UInt32, convert(Int32, x))
@inline convert(::Type{UInt64},  x::SafeInt64)  = reinterpret(UInt64, convert(Int64, x))
@inline convert(::Type{UInt128}, x::SafeInt128) = reinterpret(UInt128, convert(Int128, x))

@inline convert(::Type{SafeInt8}, x::I)   where I<:Union{SafeInt16, SafeInt32, SafeInt64, SafeInt128} = convert(SafeInt8, convert(Int8, x))
@inline convert(::Type{SafeInt16}, x::I)  where I<:Union{SafeInt8, SafeInt32, SafeInt64, SafeInt128}  = convert(SafeInt16, convert(Int16, x))
@inline convert(::Type{SafeInt32}, x::I)  where I<:Union{SafeInt8, SafeInt16, SafeInt64, SafeInt128}  = convert(SafeInt32, convert(Int32, x))
@inline convert(::Type{SafeInt64}, x::I)  where I<:Union{SafeInt8, SafeInt16, SafeInt32, SafeInt128}  = convert(SafeInt64, convert(Int64, x))
@inline convert(::Type{SafeInt128}, x::I) where I<:Union{SafeInt8, SafeInt16, SafeInt32, SafeInt64}   = convert(SafeInt128, convert(Int128, x))

@inline convert(::Type{SafeUInt8}, x::I)   where I<:Union{SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128} = convert(SafeUInt8, convert(UInt8, x))
@inline convert(::Type{SafeUInt16}, x::I)  where I<:Union{SafeUInt8, SafeUInt32, SafeUInt64, SafeUInt128}  = convert(SafeUInt16, convert(UInt16, x))
@inline convert(::Type{SafeUInt32}, x::I)  where I<:Union{SafeUInt8, SafeUInt16, SafeUInt64, SafeUInt128}  = convert(SafeUInt32, convert(UInt32, x))
@inline convert(::Type{SafeUInt64}, x::I)  where I<:Union{SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt128}  = convert(SafeUInt64, convert(UInt64, x))
@inline convert(::Type{SafeUInt128}, x::I) where I<:Union{SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64}   = convert(SafeUInt128, convert(UInt128, x))

@inline convert(::Type{SafeInt8}, x::I)   where I<:Union{Int16, Int32, Int64, Int128} = convert(SafeInt8, convert(Int8, x))
@inline convert(::Type{SafeInt16}, x::I)  where I<:Union{Int8, Int32, Int64, Int128}  = convert(SafeInt16, convert(Int16, x))
@inline convert(::Type{SafeInt32}, x::I)  where I<:Union{Int8, Int16, Int64, Int128}  = convert(SafeInt32, convert(Int32, x))
@inline convert(::Type{SafeInt64}, x::I)  where I<:Union{Int8, Int16, Int32, Int128}  = convert(SafeInt64, convert(Int64, x))
@inline convert(::Type{SafeInt128}, x::I) where I<:Union{Int8, Int16, Int32, Int64}   = convert(SafeInt128, convert(Int128, x))

@inline convert(::Type{SafeUInt8}, x::I)   where I<:Union{Int16, Int32, Int64, Int128} = convert(SafeUInt8, convert(UInt8, x))
@inline convert(::Type{SafeUInt16}, x::I)  where I<:Union{Int8, Int32, Int64, Int128}  = convert(SafeUInt16, convert(UInt16, x))
@inline convert(::Type{SafeUInt32}, x::I)  where I<:Union{Int8, Int16, Int64, Int128}  = convert(SafeUInt32, convert(UInt32, x))
@inline convert(::Type{SafeUInt64}, x::I)  where I<:Union{Int8, Int16, Int32, Int128}  = convert(SafeUInt64, convert(UInt64, x))
@inline convert(::Type{SafeUInt128}, x::I) where I<:Union{Int8, Int16, Int32, Int64}   = convert(SafeUInt128, convert(UInt128, x))

@inline convert(::Type{SafeInt8}, x::U)   where U<:Union{UInt16, UInt32, UInt64, UInt128} = convert(SafeInt8, convert(Int8, x))
@inline convert(::Type{SafeInt16}, x::U)  where U<:Union{UInt8, UInt32, UInt64, UInt128}  = convert(SafeInt16, convert(Int16, x))
@inline convert(::Type{SafeInt32}, x::U)  where U<:Union{UInt8, UInt16, UInt64, UInt128}  = convert(SafeInt32, convert(Int32, x))
@inline convert(::Type{SafeInt64}, x::U)  where U<:Union{UInt8, UInt16, UInt32, UInt128}  = convert(SafeInt64, convert(Int64, x))
@inline convert(::Type{SafeInt128}, x::U) where U<:Union{UInt8, UInt16, UInt32, UInt64}   = convert(SafeInt128, convert(Int128, x))

@inline convert(::Type{SafeUInt8}, x::U)   where U<:Union{UInt16, UInt32, UInt64, UInt128} = convert(SafeUInt8, convert(UInt8, x))
@inline convert(::Type{SafeUInt16}, x::U)  where U<:Union{UInt8, UInt32, UInt64, UInt128}  = convert(SafeUInt16, convert(UInt16, x))
@inline convert(::Type{SafeUInt32}, x::U)  where U<:Union{UInt8, UInt16, UInt64, UInt128}  = convert(SafeUInt32, convert(UInt32, x))
@inline convert(::Type{SafeUInt64}, x::U)  where U<:Union{UInt8, UInt16, UInt32, UInt128}  = convert(SafeUInt64, convert(UInt64, x))
@inline convert(::Type{SafeUInt128}, x::U) where U<:Union{UInt8, UInt16, UInt32, UInt64}   = convert(SafeUInt128, convert(UInt128, x))

itype(::Type{SafeSigned})   = Signed
itype(::Type{SafeUnsigned}) = Unsigned
itype(::Type{SafeInteger})  = Integer
stype(::Type{Signed})   = SafeSigned
stype(::Type{Unsigned}) = SafeUnsigned
stype(::Type{Integer})  = SafeInteger

for (S,T) in zip(SAFE_SIGNEDS, UNSAFE_SIGNEDS)
    @eval begin
        @inline itype(::Type{$S}) = $T
        @inline stype(::Type{$T}) = $S
    end
end
for (S,T) in zip(SAFE_UNSIGNEDS, UNSAFE_UNSIGNEDS)
    @eval begin
        @inline itype(::Type{$S}) = $T
        @inline stype(::Type{$T}) = $S
    end
end

@inline convert(::Type{Int8}, x::I)   where I<:Union{SafeInt16, SafeInt32, SafeInt64, SafeInt128} = convert(Int8, convert(Int8, convert(itype(I), x)))
@inline convert(::Type{Int16}, x::I)  where I<:Union{SafeInt8, SafeInt32, SafeInt64, SafeInt128}  = convert(Int16, convert(Int16, convert(itype(I), x)))
@inline convert(::Type{Int32}, x::I)  where I<:Union{SafeInt8, SafeInt16, SafeInt64, SafeInt128}  = convert(Int32, convert(Int32, convert(itype(I), x)))
@inline convert(::Type{Int64}, x::I)  where I<:Union{SafeInt8, SafeInt16, SafeInt32, SafeInt128}  = convert(Int64, convert(Int64, convert(itype(I), x)))
@inline convert(::Type{Int128}, x::I) where I<:Union{SafeInt8, SafeInt16, SafeInt32, SafeInt64}   = convert(Int128, convert(Int128, convert(itype(I), x)))

@inline convert(::Type{UInt8}, x::I)   where I<:Union{SafeInt16, SafeInt32, SafeInt64, SafeInt128} = convert(UInt8, convert(UInt8, convert(itype(I), x)))
@inline convert(::Type{UInt16}, x::I)  where I<:Union{SafeInt8, SafeInt32, SafeInt64, SafeInt128}  = convert(UInt16, convert(UInt16, convert(itype(I), x)))
@inline convert(::Type{UInt32}, x::I)  where I<:Union{SafeInt8, SafeInt16, SafeInt64, SafeInt128}  = convert(UInt32, convert(UInt32, convert(itype(I), x)))
@inline convert(::Type{UInt64}, x::I)  where I<:Union{SafeInt8, SafeInt16, SafeInt32, SafeInt128}  = convert(UInt64, convert(UInt64, convert(itype(I), x)))
@inline convert(::Type{UInt128}, x::I) where I<:Union{SafeInt8, SafeInt16, SafeInt32, SafeInt64}   = convert(UInt128, convert(UInt128, convert(itype(I), x)))

@inline convert(::Type{Int8}, x::U)   where U<:Union{SafeUInt16, UInt32, UInt64, UInt128} = convert(Int8, convert(Int8, convert(itype(I), x)))
@inline convert(::Type{Int16}, x::U)  where U<:Union{SafeUInt8, UInt32, UInt64, UInt128}  = convert(Int16, convert(Int16, convert(itype(I), x)))
@inline convert(::Type{Int32}, x::U)  where U<:Union{SafeUInt8, UInt16, UInt64, UInt128}  = convert(Int32, convert(Int32, convert(itype(I), x)))
@inline convert(::Type{Int64}, x::U)  where U<:Union{SafeUInt8, UInt16, UInt32, UInt128}  = convert(Int64, convert(Int64, convert(itype(I), x)))
@inline convert(::Type{Int128}, x::U) where U<:Union{SafeUInt8, UInt16, UInt32, UInt64}   = convert(Int128, convert(Int128, convert(itype(I), x)))

@inline convert(::Type{UInt8}, x::U)   where U<:Union{SafeUInt16, UInt32, UInt64, UInt128} = convert(UInt8, convert(UInt8, convert(itype(I), x)))
@inline convert(::Type{UInt16}, x::U)  where U<:Union{SafeUInt8, UInt32, UInt64, UInt128}  = convert(UInt16, convert(UInt16, convert(itype(I), x)))
@inline convert(::Type{UInt32}, x::U)  where U<:Union{SafeUInt8, UInt16, UInt64, UInt128}  = convert(UInt32, convert(UInt32, convert(itype(I), x)))
@inline convert(::Type{UInt64}, x::U)  where U<:Union{SafeUInt8, UInt16, UInt32, UInt128}  = convert(UInt64, convert(UInt64, convert(itype(I), x)))
@inline convert(::Type{UInt128}, x::U) where U<:Union{SafeUInt8, UInt16, UInt32, UInt64}   = convert(UInt128, convert(UInt128, convert(itype(I), x)))


convert(::Type{Signed}, x::SafeSigned) = convert(itype(typeof(x)), x)
convert(::Type{SafeSigned}, x::Signed) = convert(stype(typeof(x)), x)

convert(::Type{Unsigned}, x::SafeUnsigned) = convert(itype(typeof(x)), x)
convert(::Type{SafeUnsigned}, x::Unsigned) = convert(stype(typeof(x)), x)

convert(::Type{Integer}, x::SafeInteger) = convert(itype(typeof(x)), x)
convert(::Type{SafeInteger}, x::Integer) = convert(stype(typeof(x)), x)
