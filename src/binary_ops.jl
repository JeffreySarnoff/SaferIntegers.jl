for OP in (:(&), :(|), :(⊻))
    @eval begin
        @inline function $OP(x::T, y::T) where T<:SafeInteger
            ix = baseint(x)
            iy = baseint(y)
            result = $OP(ix, iy)
            return safeint(result)
        end
    end
end

for OP in (:(&), :(|), :(⊻))
    for (T1, T2) in MixedTypes
        @eval begin
            @inline function $OP(x::$T1, y::$T2)
                xx, yy = promote(x, y)
                return $OP(xx, yy)
            end
            @inline function $OP(x::$T2, y::$T1)
                xx, yy = promote(x, y)
                return $OP(xx, yy)
            end
        end
   end
end

for OP in (:(<), :(<=), :(>=), :(>), :(!=), :(==), :isless, :isequal)
    @eval begin
        @inline function $OP(x::T, y::T) where T<:SafeInteger
            ix = baseint(x)
            iy = baseint(y)
            result = $OP(ix, iy)
            return safeint(result)
        end
    end
end

for OP in (:(<), :(<=), :(>=), :(>), :(!=), :(==), :isless, :isequal)
    for (T1, T2) in MixedTypes
        @eval begin
            @inline function $OP(x::$T1, y::$T2)
                xx, yy = promote(x, y)
                return $OP(xx, yy)
            end
            @inline function $OP(x::$T2, y::$T1)
                xx, yy = promote(x, y)
                return $OP(xx, yy)
            end
        end
    end
end

for OP in (:(>>>), :(>>), :(<<))
    @eval begin
       @inline function $OP(x::T, y::T) where T<:SafeInteger
            r1 = baseint(x)
            r2 = baseint(y)
            bitsof(T) < abs(r2) && throw(OverflowError("cannot shift $T by $y"))
            result = $OP(r1, r2)
            return reinterpret(T, result)
        end

        @inline function $OP(x::T1, y::T2) where {T1<:SafeInteger, T2<:SafeInteger}
            xx = baseint(x)
            yy = baseint(y)
            bitsof(T1) < abs(yy) && throw(OverflowError("cannot shift $T1 by $yy"))
            return reinterpret(T1, $OP(xx, yy))
        end

        @inline function $OP(x::T1, y::Int) where {T1<:SafeInteger}
            xx = baseint(x)
            bitsof(T1) < abs(y) && throw(OverflowError("cannot shift $T1 by $y"))
            return reinterpret(T1, $OP(xx, y))
        end

        @inline function $OP(x::T1, y::T2) where {T1<:SafeInteger, T2<:Base.BitSigned}
            xx = baseint(x)
            bitsof(T1) < abs(y) && throw(OverflowError("cannot shift $T1 by $y"))
            return reinterpret(T1, $OP(xx, y))
        end
        @inline function $OP(x::T1, y::T2) where {T1<:Base.BitSigned, T2<:SafeInteger}
            yy = baseint(y)
            bitsof(T1) < abs(yy) && throw(OverflowError("cannot shift $T1 by $yy"))
            return reinterpret(T1, $OP(x, yy))
        end
        @inline function $OP(x::T1, y::T2) where {T1<:SafeInteger, T2<:Base.BitUnsigned}
            xx = baseint(x)
            bitsof(T1) < abs(y) && throw(OverflowError("cannot shift $T1 by $y"))
            return reinterpret(T1, $OP(xx, y))
        end
        @inline function $OP(x::T1, y::T2) where {T1<:Base.BitUnsigned, T2<:SafeInteger}
            yy = baseint(y)
            bitsof(T1) < abs(yy) && throw(OverflowError("cannot shift $T1 by $yy"))
            return reinterpret(T1, $OP(x, yy))
        end
   end
end

