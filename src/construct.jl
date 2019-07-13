safeint(::Type{Bool}) = Bool
baseint(::Type{Bool}) = Bool
safeint(x::Bool) = x
baseint(x::Bool) = x


for (S,I) in (
    (:SafeInt8, :Int8), (:SafeInt16, :Int16), (:SafeInt32, :Int32), (:SafeInt64, :Int64), (:SafeInt128, :Int128),
    (:SafeUInt8, :UInt8), (:SafeUInt16, :UInt16), (:SafeUInt32, :UInt32), (:SafeUInt64, :UInt64), (:SafeUInt128, :UInt128) )
  @eval begin
    @inline safeint(::Type{$I}) = $S
    @inline safeint(::Type{$S}) = $S
    @inline baseint(::Type{$I}) = $I
    @inline baseint(::Type{$S}) = $I

    @inline safeint(x::$I) = reinterpret($S, x)
    @inline baseint(x::$S) = reinterpret($I, x)
    @inline safeint(x::$S) = x
    @inline baseint(x::$I) = x

    @inline $S(x::$I) = reinterpret($S, x)
    @inline $I(x::$S) = reinterpret($I, x)

    @inline $S(x::Bool) = ifelse(x, one($S), zero($S))

    @inline SafeInteger(::Type{$I}) = $S
    @inline SafeInteger(x::$I) = reinterpret($S, x)
  end
end

for (S,I) in (
    (:SafeInt8, :Int8), (:SafeInt16, :Int16), (:SafeInt32, :Int32), (:SafeInt64, :Int64), (:SafeInt128, :Int128) )
  @eval begin
    @inline SafeSigned(::Type{$I}) = $S
    @inline SafeSigned(x::$I) = reinterpret($S, x)
  end
end

for (S,I) in (
    (:SafeUInt8, :UInt8), (:SafeUInt16, :UInt16), (:SafeUInt32, :UInt32), (:SafeUInt64, :UInt64), (:SafeUInt128, :UInt128) )
  @eval begin
    @inline SafeUnsigned(::Type{$I}) = $S
    @inline SafeUnsigned(x::$I) = reinterpret($S, x)
  end
end

SafeInt128(x::T) where T<:Union{SafeInt8,SafeInt16,SafeInt32,SafeInt64} =
    safeint(Int128(baseint(x)))
SafeInt64(x::T) where T<:Union{SafeInt8,SafeInt16,SafeInt32} =
    safeint(Int64(baseint(x)))
SafeInt32(x::T) where T<:Union{SafeInt8,SafeInt16} =
    safeint(Int32(baseint(x)))
SafeInt16(x::T) where T<:SafeInt8 =
    safeint(Int16(baseint(x)))

SafeUInt128(x::T) where T<:Union{SafeUInt8,SafeUInt16,SafeUInt32,SafeUInt64} =
    safeint(UInt128(baseint(x)))
SafeUInt64(x::T) where T<:Union{SafeUInt8,SafeUInt16,SafeUInt32} =
    safeint(UInt64(baseint(x)))
SafeUInt32(x::T) where T<:Union{SafeUInt8,SafeUInt16} =
    safeint(UInt32(baseint(x)))
SafeUInt16(x::T) where T<:SafeUInt8 =
    safeint(UInt16(baseint(x)))


for (SS,SU, IS, IU) in (
    (:SafeInt8, :SafeUInt8, :Int8, :UInt8), 
    (:SafeInt16, :SafeUInt16, :Int16, :UInt16),
    (:SafeInt32, :SafeUInt32, :Int32, :UInt32), 
    (:SafeInt64, :SafeUInt64, :Int64, :UInt64),
    (:SafeInt128, :SafeUInt128, :Int128, :UInt128) )
   @eval begin
     $SS(x::T) where T<:Signed   = safeint(baseint($SS)(x))
     $SS(x::T) where T<:Unsigned = safeint(baseint($SS)(baseint($SU)(x)))
     $SU(x::T) where T<:Signed   = safeint(baseint($SU)(x))
     $SU(x::T) where T<:Unsigned = safeint(baseint($SU)(baseint($SS)(x)))
     $SS(x::T) where T<:SafeSigned   = safeint(baseint($SS)(x))
     $SS(x::T) where T<:SafeUnsigned = safeint(baseint($SS)(baseint($SU)(x)))
     $SU(x::T) where T<:SafeSigned   = safeint(baseint($SU)(x))
     $SU(x::T) where T<:SafeUnsigned = safeint(baseint($SU)(baseint($SS)(x)))

     $IS(x::T) where T<:SafeSigned   = $IS(baseint(x))
     $IS(x::T) where T<:SafeUnsigned = $IS(baseint(x))
     $IU(x::T) where T<:SafeUnsigned = $IU(baseint(x))
     $IU(x::T) where T<:SafeSigned   = $IU(baseint(x))
  end
end

safeint(x::UnitRange{I}) where {I<:Integer}     = safeint(x.start):safeint(x.stop)
baseint(x::UnitRange{S}) where {S<:SafeInteger} = baseint(x.start):baseint(x.stop)


function Rational{T}(num::I, den::I) where {I<:Integer, T<:SafeInteger}
    num == den == zero(T) && __throw_rational_argerror(T)
    num2, den2 = (sign(den) < 0) ? (den !== typemin(I) ? divgcd(-num, -den) : divgcd(num, den) ) : divgcd(num, den)
    Rational{T}(SaferIntegers.safeint(num2) , SaferIntegers.baseint(den2))
end


for (S,I) in (
    (:SafeInt8, :Int8), (:SafeInt16, :Int16), (:SafeInt32, :Int32), (:SafeInt64, :Int64), (:SafeInt128, :Int128),
    (:SafeUInt8, :UInt8), (:SafeUInt16, :UInt16), (:SafeUInt32, :UInt32), (:SafeUInt64, :UInt64), (:SafeUInt128, :UInt128) )
  @eval begin
    Base.Float64(x::$S) = Float64(reinterpret($I, x))
    Base.Float32(x::$S) = Float32(reinterpret($I, x))
    Base.Float16(x::$S) = Float16(reinterpret($I, x))
    Base.BigFloat(x::$S) = BigFloat(reinterpret($I, x))
    Base.BigInt(x::$S) = BigInt(reinterpret($I, x))        
  end
end    

for (S,I) in (
    (:SafeInt8, :Int8), (:SafeInt16, :Int16), (:SafeInt32, :Int32), (:SafeInt64, :Int64), (:SafeInt128, :Int128) )
    for F in (:Float64, :Float32, :Float16)
        @eval function $S(x::$F)
            !isinteger(x) && throw(DomainError("$x"))
            typemin($I) < x <typemax($I) ? $S($I(x)) : throw(OverflowError("$x"))
        end
    end    
end

for (S,I) in (
    (:SafeUInt8, :UInt8), (:SafeUInt16, :UInt16), (:SafeUInt32, :UInt32), (:SafeUInt64, :UInt64), (:SafeUInt128, :UInt128) )
    for F in (:Float64, :Float32, :Float16)
        @eval function $S(x::$F)
            !isinteger(x) && throw(DomainError("$x"))
            typemin($I) < x <typemax($I) ? $S($I(x)) : throw(OverflowError("$x"))
        end
    end    
end

for T in (:SafeInt8, :SafeInt16, :SafeInt32, :SafeInt64, :SafeInt128,
          :SafeUInt8, :SafeUInt16, :SafeUInt32, :SafeUInt64, :SafeUInt128)
    @eval $T(x::$T) = x
end
        
