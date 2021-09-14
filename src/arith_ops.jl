function checked_mod1(x::T, y::T) where T<:Base.BitInteger
    result = checked_mod(x, y)
    result = ifelse(result === zero(T), y, result)
    return result
end

function checked_fld1(x::T, y::T) where T<:Base.BitInteger
    d = checked_div(x, y)
    return d + (!signbit(x ⊻ y) & (d * y !== x))
end

for (OP, CHK) in ((:(+), :checked_add), (:(-), :checked_sub),
                  (:(*), :checked_mul), (:div, :checked_div),
                  (:fld, :checked_fld), (:cld, :checked_cld),
                  (:rem, :checked_rem), (:mod, :checked_mod),
                  (:mod1, :checked_mod1), (:fld1, :checked_fld1))
    @eval begin
        @inline function $OP(x::T, y::T) where T<:SafeSigned
            ix = baseint(x)
            iy = baseint(y)
            result = $CHK(ix, iy)
            return safeint(result)
        end

        @inline function $OP(x::T, y::T) where T<:SafeUnsigned
            ix = baseint(x)
            iy = baseint(y)
            result = $CHK(ix, iy)
            return safeint(result)
        end
    end
end

for (OP, CHK) in ((:(+), :checked_add), (:(-), :checked_sub),
    (:(*), :checked_mul), (:div, :checked_div),
    (:fld, :checked_fld), (:cld, :checked_cld),
    (:rem, :checked_rem), (:mod, :checked_mod),
    (:mod1, :checked_mod1), (:fld1, :checked_fld1))
    for (T1, T2) in PairedSafes
        @eval begin
            @inline function $OP(x::$T1, y::$T2)
                xx, yy = promote(x, y)
                ix = baseint(xx)
                iy = baseint(yy)
                result = $CHK(ix, iy)
                return safeint(result)
            end
        end
    end
end

for (OP, CHK) in ((:(+), :checked_add), (:(-), :checked_sub),
    (:(*), :checked_mul), (:div, :checked_div),
    (:fld, :checked_fld), (:cld, :checked_cld),
    (:rem, :checked_rem), (:mod, :checked_mod),
    (:mod1, :checked_mod1), (:fld1, :checked_fld1))
    for (T1, T2) in MixedInts
        @eval begin
            @inline function $OP(x::$T1, y::$T2)
                xx, yy = promote(x, y)
                return $OP(xx, yy)
            end
        end
    end
end

for (OP, CHK) in ((:(+), :checked_add), (:(-), :checked_sub),
    (:(*), :checked_mul), (:div, :checked_div),
    (:fld, :checked_fld), (:cld, :checked_cld),
    (:rem, :checked_rem), (:mod, :checked_mod),
    (:mod1, :checked_mod1), (:fld1, :checked_fld1))
    @eval begin
        @inline function $OP(x::T, y::Bool) where {T<:SafeInteger}
            xx, yy = promote(x, y)
            return $OP(xx, yy)
        end

        @inline function $OP(x::Bool, y::T) where {T<:SafeInteger}
            xx, yy = promote(x, y)
            return $OP(xx, yy)
        end
    end
end

function (/)(x::S, y::S) where S<:SafeInteger
    ix = baseint(x)
    iy = baseint(y)
    checked_div(ix, iy)
    result = ix / iy
    return result
end

function (\)(x::S, y::S) where S<:SafeInteger
    ix = baseint(y)
    iy = baseint(x)
    checked_div(iy, ix)
    result = ix / iy
    return result
end

function divrem(x::S, y::S) where S<:SafeInteger
    ix = baseint(x)
    iy = baseint(y)
    return safeint(div(ix, iy)), safeint(rem(ix, iy)) # div, rem already are checked
end

function fldmod(x::S, y::S) where S<:SafeInteger
    ix = baseint(x)
    iy = baseint(y)
    return safeint(fld(ix, iy)), safeint(mod(ix, iy)) # fld, mod already are checked
end

function fldmod1(x::S, y::S) where S<:SafeInteger
    ix = baseint(x)
    iy = baseint(y)
    return safeint(fld1(ix, iy)), safeint(mod1(ix, iy)) # fld1, mod1 already are checked
end

function gcd(x::S, y::S) where S<:SafeInteger
    ix = baseint(x)
    iy = baseint(y)
    return safeint(gcd(ix, iy))
end

function lcm(x::S, y::S) where S<:SafeInteger
    ix = baseint(x)
    iy = baseint(y)
    return safeint(lcm(ix, iy))
end

function divgcd(x::S, y::S) where {S<:SafeInteger}
    g = gcd(x,y)
    return div(x,g), div(y,g)
end

for OP in (:divrem, :fldmod, :fldmod1, :divgcd, :gcd, :lcm)
    for (T1, T2) in MixedPairs
        @eval begin
            @inline function $OP(x::$T1, y::$T2)
                xx, yy = promote(x, y)
                return $OP(xx, yy)
            end
        end
    end
end

for OP in (:divrem, :fldmod, :fldmod1, :divgcd, :gcd, :lcm)
    @eval begin
        @inline function $OP(x::T, y::Bool) where {T<:SafeInteger}
            xx, yy = promote(x, y)
            return $OP(xx, yy)
        end

        @inline function $OP(x::Bool, y::T) where {T<:SafeInteger}
            xx, yy = promote(x, y)
            return $OP(xx, yy)
        end
    end    
end

for (T1, T2) in MixedPairs
    @eval begin
        @inline function /(x::$T1, y::$T2)
            xx, yy = promote(x, y)
            return /(xx, yy)
        end
        @inline function \(x::$T1, y::$T2)
            xx, yy = promote(x, y)
            return \(xx, yy)
        end
    end
end

@inline function /(x::T, y::Bool) where {T<:SafeInteger}
    xx, yy = promote(x, y)
    return /(xx, yy)
end

@inline function \(x::Bool, y::T) where {T<:SafeInteger}
    xx, yy = promote(x, y)
    return \(xx, yy)
end

