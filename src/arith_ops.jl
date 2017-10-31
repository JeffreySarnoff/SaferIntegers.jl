import Base: (+), (-), (*), div, fld, cld, rem, mod
import Base.Checked: checked_add, checked_sub, checked_mul,
                     checked_div, checked_fld, checked_cld,
                     checked_rem, checked_mod

for (OP, CHK) in ((:(+), :checked_add), (:(-), :checked_sub),
                  (:(*), :checked_mul), (:div, :checked_div),
                  (:fld, :checked_fld), (:cld, :checked_cld),
                  (:rem, :checked_rem), (:mod, :checked_mod))
    @eval begin
       @inline function $OP(x::T, y::T) where T<:SafeInteger
            I = itype(T)
            r1 = reinterpret(I, x)
            r2 = reinterpret(I, y)
            result = $CHK(r1, r2)
            return reinterpret(T, result)
        end

        @inline function $OP(x::T1, y::T2) where T1<:SafeSigned where T2<:SafeSigned
            xx, yy = promote(x, y)
            T = typeof(xx)
            I = itype(T)
            r1 = reinterpret(I, xx)
            r2 = reinterpret(I, yy)
            result = $CHK(r1, r2)
            return reinterpret(T, result)
        end

        @inline function $OP(x::T1, y::T2) where T1<:SafeUnsigned where T2<:SafeUnsigned
            T = promote_type(T1, T2)
            I = itype(T)
            xx, yy = promote(x, y)
            r1 = reinterpret(I, xx)
            r2 = reinterpret(I, yy)
            result = $CHK(r1, r2)
            return reinterpret(T, result)
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
