for OP in (:(<), :(<=), :(>=), :(>), :(!=), :(==), :isless, :isequal)
    @eval begin

       @inline function $OP(x::T, y::T) where T<:SafeInteger
           ix = baseint(x)
           iy = baseint(y)
           result = $OP(ix, iy)
           return safeint(result)
       end

       @inline function $OP(x::T1, y::T2) where T1<:SafeInteger where T2<:SafeInteger
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end

       @inline function $OP(x::T1, y::T2) where T1<:SafeInteger where T2<:Integer
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end

       @inline function $OP(x::T1, y::T2) where T1<:Integer where T2<:SafeInteger
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end
   end
end

for OP in (:(&), :(|), :(⊻))
    @eval begin

       @inline function $OP(x::T, y::T) where T<:SafeInteger
           ix = baseint(x)
           iy = baseint(y)
           result = $OP(ix, iy)
           return safeint(result)
       end

       @inline function $OP(x::T1, y::T2) where T1<:SafeInteger where T2<:SafeInteger
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end

       @inline function $OP(x::T1, y::T2) where T1<:SafeInteger where T2<:Integer
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end

       @inline function $OP(x::T2, y::T1) where T1<:SafeInteger where T2<:Integer
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
            result = $OP(r1, r2)
            return reinterpret(T, result)
        end

        @inline function $OP(x::T1, y::T2) where T1<:SafeInteger where T2<:SafeInteger
            xx = baseint(x)
            yy = baseint(y)
            return reinterpret(T1, $OP(xx, yy))
        end

        @inline function $OP(x::T1, y::T2) where T1<:SafeInteger where T2<:Integer
            xx = baseint(x)
            return reinterpret(T1, $OP(xx, y))
        end

        @inline function $OP(x::T1, y::Int) where T1<:SafeInteger
            xx = baseint(x)
            return reinterpret(T1, $OP(xx, y))
        end

        @inline function $OP(x::T1, y::T2) where T1<:Integer where T2<:SafeInteger
            yy = baseint(y)
            xx = $OP(x, yy)
            return reinterpret(stype(T1), xx)
        end

   end
end
