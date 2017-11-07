import Base: convert

convert(::Type{S1}, x::S2) where S1<:SafeSigned where S2<:SafeSigned = stype(convert(itype(S1), ityped(x)))
convert(::Type{S1}, x::S2) where S1<:SafeUnsigned where S2<:SafeUnsigned = stype(convert(itype(S1), ityped(x)))
convert(::Type{S1}, x::S2) where S1<:SafeSigned where S2<:SafeUnsigned = stype(convert(itype(S1), ityped(x)))
convert(::Type{S1}, x::S2) where S1<:SafeUnsigned where S2<:SafeSigned = stype(convert(itype(S1), ityped(x)))

convert(::Type{Signed}, x::SafeSigned) = convert(itype(typeof(x)), x)
convert(::Type{SafeSigned}, x::Signed) = convert(stype(typeof(x)), x)

convert(::Type{Unsigned}, x::SafeUnsigned) = convert(itype(typeof(x)), x)
convert(::Type{SafeUnsigned}, x::Unsigned) = convert(stype(typeof(x)), x)

convert(::Type{Integer}, x::SafeInteger) = convert(itype(typeof(x)), x)
convert(::Type{SafeInteger}, x::Integer) = convert(stype(typeof(x)), x)

const IUSafeIU =
    [(:Int8, :UInt8, :SafeInt8, :SafeUInt8), (:Int16, :UInt16, :SafeInt16, :SafeUInt16),
     (:Int32, :UInt32, :SafeInt32, :SafeUInt32),(:Int64, :UInt64, :SafeInt64, :SafeUInt64),
     (:Int128, :UInt128, :SafeInt128, :SafeUInt128)]

for (I,U,SI,SU) in IUSafeIU
  @eval begin
     @inline convert(::Type{$SI}, x::$SI) = x
     @inline convert(::Type{$SU}, x::$SU) = x
     @inline $SI(x::$SI) = x
     @inline $SU(x::$SU) = x

     @inline convert(::Type{$I}, x::$SI) = reinterpret($I, x)
     @inline convert(::Type{$U}, x::$SU) = reinterpret($U, x)
     @inline convert(::Type{$SI}, x::$I) = reinterpret($SI, x)
     @inline convert(::Type{$SU}, x::$U) = reinterpret($SU, x)
     @inline convert(::Type{$I}, x::$SU) = convert($I, reinterpret($U, x))
     @inline convert(::Type{$U}, x::$SI) = convert($U, reinterpret($I, x))
     @inline convert(::Type{$SU}, x::$I) = reinterpret($SU, convert($U, x))
     @inline convert(::Type{$SI}, x::$U) = reinterpret($SI, convert($I, x))

     @inline $I(x::$SI) = convert($I, x)
     @inline $U(x::$SU) = convert($U, x)
     @inline $SI(x::$I) = convert($SI, x)
     @inline $SU(x::$U) = convert($SU, x)
     @inline $I(x::$SU) = convert($I, x)
     @inline $U(x::$SI) = convert($U, x)
     @inline $SU(x::$I) = convert($SU, x)
     @inline $SI(x::$U) = convert($SI, x)
  end
end

for (I,U,SI,SU) in IUSafeIU
  for (I2,U2,SI2,SU2) in IUSafeIU
   @eval begin
     if (sizeof($I) != sizeof($I2))
         @inline convert(::Type{$SI}, x::$SI2) = reinterpret($SI, convert($I, reinterpret($I2, x)))
         @inline convert(::Type{$SU}, x::$SU2) = reinterpret($SU, convert($I, reinterpret($I2, x)))
         @inline convert(::Type{$SI}, x::$SU2) = reinterpret($SI, convert($I, reinterpret($U2, x)))
         @inline convert(::Type{$SU}, x::$SI2) = reinterpret($SU, convert($U, reinterpret($I2, x)))
         @inline $SI(x::$SI2) = convert($SI, x)
         @inline $UI(x::$SU2) = convert($SU, x)
         @inline $SI(x::$SU2) = convert($SI, x)
         @inline $UI(x::$SI2) = convert($SU, x)

         @inline convert(::Type{$I},  x::$SI2) = convert($I, reinterpret($I2, x))
         @inline convert(::Type{$U},  x::$SU2) = convert($U, reinterpret($U2, x))
         @inline convert(::Type{$SI}, x::$I2)  = reinterpret($SI, convert($I, x))
         @inline convert(::Type{$SU}, x::$U2)  = reinterpret($SU, convert($U, x))
         @inline convert(::Type{$I},  x::$SU2) = convert($I, convert($I, reinterpret($U2, x)))
         @inline convert(::Type{$U},  x::$SI2) = convert($U, convert($U, reinterpret($I2, x)))
         @inline convert(::Type{$SU}, x::$I2)  = reinterpret($SU, convert($U, convert($U2, x)))
         @inline convert(::Type{$SI}, x::$U2)  = reinterpret($SI, convert($I, convert($I2, x)))

         @inline $I(x::$SI2) = convert($I, x)
         @inline $U(x::$SU2) = convert($U, x)
         @inline $SI(x::$I2) = convert($SI, x)
         @inline $SU(x::$U2) = convert($SU, x)
         @inline $I(x::$SU2) = convert($I, x)
         @inline $U(x::$SI2) = convert($U, x)
         @inline $SU(x::$I2) = convert($SU, x)
         @inline $SI(x::$U2) = convert($SI, x)
      end
    end 
  end
end

#=

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
=#
