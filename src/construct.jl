safeint(::Type{Bool}) = Bool
integer(::Type{Bool}) = Bool
safeint(x::Bool) = x
integer(x::Bool) = x


for (S,I) in (
    (:SafeInt8, :Int8), (:SafeInt16, :Int16), (:SafeInt32, :Int32), (:SafeInt64, :Int64), (:SafeInt128, :Int128),
    (:SafeUInt8, :UInt8), (:SafeUInt16, :UInt16), (:SafeUInt32, :UInt32), (:SafeUInt64, :UInt64), (:SafeUInt128, :UInt128) )
  @eval begin
    @inline safeint(::Type{$I}) = $S
    @inline safeint(::Type{$S}) = $S
    @inline integer(::Type{$I}) = $I
    @inline integer(::Type{$S}) = $I

    @inline $S(x::$I) = reinterpret($S, x)
    @inline $I(x::$S) = reinterpret($I, x)
    @inline safeint(x::$I) = reinterpret($S, x)
    @inline integer(x::$S) = reinterpret($I, x)
    @inline safeint(x::$S) = x
    @inline integer(x::$I) = x
  end
end

SafeInt128(x::T) where T<:Union{SafeInt8,SafeInt16,SafeInt32,SafeInt64} =
    safeint(Int128(integer(x)))
SafeInt64(x::T) where T<:Union{SafeInt8,SafeInt16,SafeInt32} =
    safeint(Int64(integer(x)))
SafeInt32(x::T) where T<:Union{SafeInt8,SafeInt16} =
    safeint(Int32(integer(x)))
SafeInt16(x::T) where T<:SafeInt8 =
    safeint(Int16(integer(x)))

SafeUInt128(x::T) where T<:Union{SafeUInt8,SafeUInt16,SafeUInt32,SafeUInt64} =
    safeint(UInt128(integer(x)))
SafeUInt64(x::T) where T<:Union{SafeUInt8,SafeUInt16,SafeUInt32} =
    safeint(UInt64(integer(x)))
SafeUInt32(x::T) where T<:Union{SafeUInt8,SafeUInt16} =
    safeint(UInt32(integer(x)))
SafeUInt16(x::T) where T<:SafeUInt8 =
    safeint(UInt16(integer(x)))


for (SS,SU, IS, IU) in (
    (:SafeInt8, :SafeUInt8, :Int8, :UInt8), 
    (:SafeInt16, :SafeUInt16, :Int16, :UInt16),
    (:SafeInt32, :SafeUInt32, :Int32, :UInt32), 
    (:SafeInt64, :SafeUInt64, :Int64, :UInt64),
    (:SafeInt128, :SafeUInt128, :Int128, :UInt128) )
   @eval begin
     $SS(x::T) where T<:Signed   = safeint(integer($SS)(x))
     $SS(x::T) where T<:Unsigned = safeint(integer($SS)(integer($SU)(x)))
     $SS(x::T) where T<:SafeSigned   = safeint(integer($SS)(x))
     $SS(x::T) where T<:SafeUnsigned = safeint(integer($SS)(integer($SU)(x)))
     $SU(x::T) where T<:Signed   = safeint(integer($SU)(x))
     $SU(x::T) where T<:Unsigned = safeint(integer($SU)(integer($SS)(x)))
     $SU(x::T) where T<:SafeSigned   = safeint(integer($SU)(x))
     $SU(x::T) where T<:SafeUnsigned = safeint(integer($SU)(integer($SS)(x)))

     $IS(x::T) where T<:Signed   = $IS(integer(x))
     $IS(x::T) where T<:Unsigned  = $IS(integer(x))
     $IS(x::T) where T<:SafeSigned   = $IS(integer(x))
     $IS(x::T) where T<:SafeUnsigned  = $IS(integer(x))
     $IU(x::T) where T<:Unsigned = $IU(integer(x))
     $IU(x::T) where T<:Signed = $IU(integer(x))
     $IU(x::T) where T<:SafeUnsigned = $IU(integer(x))
     $IU(x::T) where T<:SafeSigned = $IU(integer(x))
  end
end

for T in (:SafeInt8, :SafeInt16, :SafeInt32, :SafeInt64, :SafeInt128,
          :SafeUInt8, :SafeUInt16, :SafeUInt32, :SafeUInt64, :SafeUInt128)
    @eval $T(x::UnitRange{I}) where {I<:Integer} = UnitRange($T(x.start), $T(x.stop))
end
for T in (:Int8, :Int16, :Int32, :Int64, :Int128,
          :UInt8, :UInt16, :UInt32, :UInt64, :UInt128)
    @eval $T(x::UnitRange{I}) where {I<:SafeInteger} = UnitRange($T(x.start), $T(x.stop))
end

