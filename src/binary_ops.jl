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
            I1 = itype(T1)
            I2 = itype(T2)
            I = Base.promote_type(I1, I2)
            r1 = reinterpret(I1, x)%I
            r2 = reinterpret(I2, y)%I
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
            T = promote_type(T1, T2)
            I = itype(T)
            I1 = itype(T1)
            I2 = itype(T2)
            r1 = reinterpret(I1, x)%I
            r2 = reinterpret(I2, y)%I
            result = $OP(r1, r2)
            return reinterpret(T, result)
        end

        @inline function $OP(x::T1, y::T2) where T1<:SafeInteger where T2<:Integer
            T = promote_type(T1, T2)
            I = itype(T)
            I1 = itype(T1)
            I2 = itype(T2)
            r1 = reinterpret(I1, x)%I
            r2 = reinterpret(I2, y)%I
            result = $OP(r1, r2)
            return reinterpret(T, result)
        end

        @inline function $OP(x::T2, y::T1) where T1<:SafeInteger where T2<:Integer
            T = promote_type(T1, T2)
            I = itype(T)
            I2 = itype(T1)
            I1 = itype(T2)
            r1 = reinterpret(I1, x)%I
            r2 = reinterpret(I2, y)%I
            result = $OP(r1, r2)
            return reinterpret(T, result)
        end

   end
end
