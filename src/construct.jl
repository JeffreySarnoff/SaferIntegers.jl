for (S,I) in (
    (:SafeInt8, :Int8), (:SafeInt16, :Int16), (:SafeInt32, :Int32), (:SafeInt64, :Int64), (:SafeInt128, :Int128),
    (:SafeUInt8, :UInt8), (:SafeUInt16, :UInt16), (:SafeUInt32, :UInt32), (:SafeUInt64, :UInt64), (:SafeUInt128, :UInt128) )
  @eval begin
    @inline $S(x::$I) = reinterpret($S, x)
    @inline $I(x::$S) = reinterpret($I, x)
    @inline safeint(x::$I) = reinterpret($S, x)
    @inline integer(x::$S) = reinterpret($I, x)
    @inline safeint(x::$S) = x
    @inline integer(x::$I) = x
  end
end
