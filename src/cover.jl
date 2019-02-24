for OP in (:checked_abs, :checked_neg)
    @eval begin
       @inline function $OP(x::T) where T<:SafeInteger
            ix = baseint(x)
            result = $OP(ix)
            return safeint(result)
        end
    end
end

for OP in (:checked_add, :checked_sub,
           :checked_mul, :checked_div, :checked_fld, :checked_cld,
           :checked_rem, :checked_mod)
    @eval begin
       @inline function $OP(x::T, y::T) where T<:SafeSigned
            ix = baseint(x)
            iy = baseint(y)
            result = $OP(ix, iy)
            return safeint(result)
        end

       @inline function $OP(x::T, y::T) where T<:SafeUnsigned
            ix = baseint(x)
            iy = baseint(y)
            result = $OP(ix, iy)
            return safeint(result)
        end

        @inline function $OP(x::T1, y::T2) where {T1<:SafeSigned, T2<:SafeSigned}
            xx, yy = promote(x, y)
            ix = baseint(xx)
            iy = baseint(yy)
            result = $OP(ix, iy)
            return safeint(result)
        end

        @inline function $OP(x::T1, y::T2) where {T1<:SafeUnsigned, T2<:SafeUnsigned}
            xx, yy = promote(x, y)
            ix = baseint(xx)
            iy = baseint(yy)
            result = $OP(ix, iy)
            return safeint(result)
        end
        
        @inline function $OP(x::T1, y::T2) where {T1<:SafeInteger, T2<:UnsafeInteger}
            xx, yy = promote(x, y)
            return $OP(xx, yy)
        end

        @inline function $OP(x::T1, y::T2) where {T1<:UnsafeInteger, T2<:SafeInteger}
            xx, yy = promote(x, y)
            return $OP(xx, yy)
        end
    end
end

for OP in (:add_with_overflow, :sub_with_overflow, :mul_with_overflow)
    @eval begin
       @inline function $OP(x::T, y::T) where T<:SafeSigned
            ix = baseint(x)
            iy = baseint(y)
            value, bool = $OP(ix, iy)
            return safeint(value), bool
        end
        
        @inline function $OP(x::T, y::T) where T<:SafeUnsigned
            ix = baseint(x)
            iy = baseint(y)
            value, bool = $OP(ix, iy)
            return safeint(value), bool
        end
        
        @inline function $OP(x::T1, y::T2) where {T1<:SafeSigned, T2<:SafeSigned}
            xx, yy = promote(x, y)
            ix = baseint(xx)
            iy = baseint(yy)
            value, bool = $OP(ix, iy)
            return safeint(value), bool
        end

        @inline function $OP(x::T1, y::T2) where {T1<:SafeUnsigned, T2<:SafeUnsigned}
            xx, yy = promote(x, y)
            ix = baseint(xx)
            iy = baseint(yy)
            value, bool = $OP(ix, iy)
            return safeint(value), bool
        end

    end
end
