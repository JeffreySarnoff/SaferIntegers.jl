import Base: convert

#=
convert(::Type{Signed}, x::SafeSigned) = convert(itype(typeof(x)), x)
convert(::Type{SafeSigned}, x::Signed) = convert(stype(typeof(x)), x)

convert(::Type{Unsigned}, x::SafeUnsigned) = convert(itype(typeof(x)), x)
convert(::Type{SafeUnsigned}, x::Unsigned) = convert(stype(typeof(x)), x)

convert(::Type{Integer}, x::SafeInteger) = convert(itype(typeof(x)), x)
convert(::Type{SafeInteger}, x::Integer) = convert(stype(typeof(x)), x)
=#

const IUSafeIU =
    [(:Int8, :UInt8, :SafeInt8, :SafeUInt8), (:Int16, :UInt16, :SafeInt16, :SafeUInt16),
     (:Int32, :UInt32, :SafeInt32, :SafeUInt32),(:Int64, :UInt64, :SafeInt64, :SafeUInt64),
     (:Int128, :UInt128, :SafeInt128, :SafeUInt128)]

for (I,U,SI,SU) in IUSafeIU
  @eval begin
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

