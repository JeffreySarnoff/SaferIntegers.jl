for OP in (:(&), :(|), :(⊻))
    @eval begin

       @inline function $OP(x::T, y::T) where T<:SafeInteger
           ix = baseint(x)
           iy = baseint(y)
           result = $OP(ix, iy)
           return safeint(result)
       end

       @inline function $OP(x::T1, y::T2) where {T1<:SafeInteger, T2<:SafeInteger}
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end

       @inline function $OP(x::T1, y::T2) where {T1<:SafeInteger, T2<:Integer}
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end

       @inline function $OP(x::T2, y::T1) where {T1<:SafeInteger, T2<:Integer}
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end

   end
end


for OP in (:(<), :(<=), :(>=), :(>), :(!=), :(==), :isless, :isequal)
    for SI in (SafeSigned, SafeUnsigned, SafeInteger)
        @eval begin
            @inline function $OP(x::T, y::T) where T<: $SI
                ix = baseint(x)
                iy = baseint(y)
                result = $OP(ix, iy)
                return safeint(result)
            end

            @inline function $OP(x::T1, y::T2) where {T1<:$SI, T2<: $SI}
                xx, yy = promote(x, y)
                return $OP(xx, yy)
            end
        end
    end
    @eval begin
       @inline function $OP(x::T1, y::T2) where {T1<:SafeSigned, T2<:Signed}
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end
       @inline function $OP(x::T1, y::T2) where {T1<:Signed, T2<:SafeSigned}
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end
       @inline function $OP(x::T1, y::T2) where {T1<:SafeSigned, T2<:Unsigned}
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end
       @inline function $OP(x::T1, y::T2) where {T1<:Unsigned, T2<:SafeSigned}
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end

       @inline function $OP(x::T1, y::T2) where {T1<:SafeUnsigned, T2<:Signed}
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end
       @inline function $OP(x::T1, y::T2) where {T1<:Signed, T2<:SafeUnsigned}
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end
       @inline function $OP(x::T1, y::T2) where {T1<:SafeUnsigned, T2<:Unsigned}
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end
       @inline function $OP(x::T1, y::T2) where {T1<:Unsigned, T2<:SafeUnsigned}
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end
       @inline function $OP(x::T1, y::T2) where {T1<:SafeInteger, T2<:Integer}
           xx, yy = promote(x, y)
           return $OP(xx, yy)
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

        @inline function $OP(x::T1, y::T2) where {T1<:SafeInteger, T2<:Signed}
            xx = baseint(x)
            bitsof(T1) < abs(y) && throw(OverflowError("cannot shift $T1 by $y"))
            return reinterpret(T1, $OP(xx, y))
        end
        @inline function $OP(x::T1, y::T2) where {T1<:Signed, T2<:SafeInteger}
            yy = baseint(y)
            bitsof(T1) < abs(yy) && throw(OverflowError("cannot shift $T1 by $yy"))
            return reinterpret(T1, $OP(x, yy))
        end
        @inline function $OP(x::T1, y::T2) where {T1<:SafeInteger, T2<:Unsigned}
            xx = baseint(x)
            bitsof(T1) < abs(y) && throw(OverflowError("cannot shift $T1 by $y"))
            return reinterpret(T1, $OP(xx, y))
        end
        @inline function $OP(x::T1, y::T2) where {T1<:Unsigned, T2<:SafeInteger}
            yy = baseint(y)
            bitsof(T1) < abs(yy) && throw(OverflowError("cannot shift $T1 by $yy"))
            return reinterpret(T1, $OP(x, yy))
        end

   end
end
