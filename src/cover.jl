for OP in (:checked_abs, :checked_neg, :checked_add, :checked_sub,
           :checked_mul, :checked_div, :checked_fld, checked_cld,
           :checked_rem, :checked_mod,
           add_with_overflow, sub_with_overflow, mul_with_overflow)
    @eval begin
       @inline function $OP(x::T, y::T) where T<:SafeInteger
            ix = baseint(x)
            iy = baseint(y)
            result = $OP(ix, iy)
            return safeint(result)
        end

        @inline function $OP(x::T1, y::T2) where T1<:SafeSigned where T2<:SafeSigned
            xx, yy = promote(x, y)
            ix = baseint(xx)
            iy = baseint(yy)
            result = $OP(ix, iy)
            return safeint(result)
        end

        @inline function $OP(x::T1, y::T2) where T1<:SafeUnsigned where T2<:SafeUnsigned
            xx, yy = promote(x, y)
            ix = baseint(xx)
            iy = baseint(yy)
            result = $OP(ix, iy)
            return safeint(result)
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
