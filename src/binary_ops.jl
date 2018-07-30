import Base: (<), (<=), (==), (!=), (>=), (>), (&), (|), (⊻), isequal, isless,
             (>>>), (>>), (<<)

for OP in (:(<), :(<=), :(>=), :(>), :(!=), :(==), :isless, :isequal)
    @eval begin

       @inline function $OP(x::T, y::T) where T<:SafeInteger
           ix = integer(x)
           iy = integer(y)
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
           ix = integer(x)
           iy = integer(y)
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
            I = integer(T)
            r1 = reinterpret(I, x)
            r2 = reinterpret(I, y)
            result = $OP(r1, r2)
            return reinterpret(T, result)
        end

        @inline function $OP(x::T1, y::T2) where T1<:SafeInteger where T2<:SafeInteger
            I1 = integer(T1)
            I2 = integer(T2)
            xx = reinterpret(I1, x)
            yy = reinterpret(I2, y)
            return reinterpret(T1, $OP(xx, yy))
        end

        @inline function $OP(x::T1, y::T2) where T1<:SafeInteger where T2<:Integer
            I1 = integer(T1)
            xx = reinterpret(I1, x)
            return reinterpret(T1, $OP(xx, y))
        end

        @inline function $OP(x::T1, y::Int64) where T1<:SafeInteger
            I1 = integer(T1)
            xx = reinterpret(I1, x)
            return reinterpret(T1, $OP(xx, y))
        end

        @inline function $OP(x::T1, y::T2) where T1<:Integer where T2<:SafeInteger
            I2 = integer(T2)
            yy = reinterpret(I2, y)
            xx = $OP(x, yy)
            return reinterpret(stype(T1), xx)
        end

   end
end
