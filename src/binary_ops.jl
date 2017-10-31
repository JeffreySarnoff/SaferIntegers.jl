import Base: (<), (<=), (==), (!=), (>=), (>), (&), (|), (⊻), isequal, isless,
             flipsign, copysign

for OP in (:(<), :(<=), :(>=), :(>), :(!=), :(==), :isless, :isequal)
    @eval begin

       @inline function $OP(x::T, y::T) where T<:SafeInteger
            I = itype(T)
            r1 = reinterpret(I, x)
            r2 = reinterpret(I, y)
            result = $OP(r1, r2)
            return result
        end

        @inline function $OP(x::T1, y::T2) where T1<:SafeInteger where T2<:SafeInteger
            xx, yy = promote(x, y)
            T = typeof(xx)
            I = itype(T)
            r1 = reinterpret(I, xx)
            r2 = reinterpret(I, yy)
            result = $OP(r1, r2)
            return result
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



for OP in (:(&), :(|), :(⊻), :flipsign, :copysign)
    @eval begin

       @inline function $OP(x::T, y::T) where T<:SafeInteger
            I = itype(T)
            r1 = reinterpret(I, x)
            r2 = reinterpret(I, y)
            result = $OP(r1, r2)
            return reinterpret(T, result)
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
