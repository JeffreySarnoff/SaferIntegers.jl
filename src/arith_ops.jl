import Base: (+), (-), (*), (/), (\), div, fld, cld, rem, mod
import Base.Checked: checked_add, checked_sub, checked_mul,
                     checked_div, checked_fld, checked_cld,
                     checked_rem, checked_mod

for (OP, CHK) in ((:(+), :checked_add), (:(-), :checked_sub),
                  (:(*), :checked_mul), (:div, :checked_div),
                  (:fld, :checked_fld), (:cld, :checked_cld),
                  (:rem, :checked_rem), (:mod, :checked_mod))
    @eval begin
       @inline function $OP(x::T, y::T) where T<:SafeInteger
            ix = integer(x)
            iy = integer(y)
            result = $CHK(ix, iy)
            return safeint(result)
        end

        @inline function $OP(x::T1, y::T2) where T1<:SafeSigned where T2<:SafeSigned
            xx, yy = promote(x, y)
            ix = integer(xx)
            iy = integer(yy)
            result = $CHK(ix, iy)
            return safeint(result)
        end

        @inline function $OP(x::T1, y::T2) where T1<:SafeUnsigned where T2<:SafeUnsigned
            xx, yy = promote(x, y)
            ix = integer(xx)
            iy = integer(yy)
            result = $CHK(ix, iy)
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

function (/)(x::S, y::S) where S<:SafeInteger
    ix = integer(x)
    iy = integer(y)
    checked_div(ix, iy)
    result = ix / iy
    return result
end

function (\)(x::S, y::S) where S<:SafeInteger
    ix = integer(y)
    iy = integer(x)
    checked_div(iy, ix)
    result = ix / iy
    return result
end

function (/)(x::S1, y::S2) where S1<:SafeInteger where S2<:SafeInteger
   xx, yy = promote(x, y)
   return (/)(xx, yy)
end
function (/)(x::S1, y::S2) where S1<:SafeInteger where S2<:Integer
   xx, yy = promote(x, y)
   return (/)(xx, yy)
end
function (/)(x::S1, y::S2) where S2<:SafeInteger where S1<:Integer
   xx, yy = promote(x, y)
   return (/)(xx, yy)
end

function (\)(x::S1, y::S2) where S1<:SafeInteger where S2<:SafeInteger
   xx, yy = promote(x, y)
   return (\)(xx, yy)
end
function (\)(x::S1, y::S2) where S1<:SafeInteger where S2<:Integer
   xx, yy = promote(x, y)
   return (\)(xx, yy)
end
function (\)(x::S1, y::S2) where S2<:SafeInteger where S1<:Integer
   xx, yy = promote(x, y)
   return (\)(xx, yy)
end
