import Base: (+), (-), (*), div, fld, cld, rem, mod
import Base.Checked: checked_add, checked_sub, checked_mul,
                     checked_div, checked_fld, checked_cld,
                     checked_rem, checked_mod

for (OP, CHK) in ((:(+), :checked_add), (:(-), :checked_sub),
                  (:(*), :checked_mul), (:div, :checked_div),
                  (:fld, :checked_fld), (:cld, :checked_cld),
                  (:rem, :checked_rem), (:mod, :checked_mod))
    @eval begin

       @inline function $OP(x::T, y::T) where T<:SAFEINTEGERS
            I = itype(T)
            r1 = reinterpret(I, x)
            r2 = reinterpret(I, y)
            result = $CHK(r1, r2)
            return reinterpret(T, result)
        end

        @inline function $OP(x::T1, y::T2) where T1<:SAFEINTEGERS where T2<:SAFEINTEGERS
            T = promote_type(T1, T2)
            I = itype(T)
            I1 = itype(T1)
            I2 = itype(T2)
            r1 = reinterpret(I1, x)%I
            r2 = reinterpret(I2, y)%I
            result = $CHK(r1, r2)
            return reinterpret(T, result)
        end

        @inline function $OP(x::T1, y::T2) where T1<:SAFEINTEGERS where T2<:UNSAFEINTEGERS
            T = promote_type(T1, T2)
            I = itype(T)
            I1 = itype(T1)
            I2 = itype(T2)
            r1 = reinterpret(I1, x)%I
            r2 = reinterpret(I2, y)%I
            result = $CHK(r1, r2)
            return reinterpret(T, result)
        end

        @inline function $OP(x::T2, y::T1) where T1<:SAFEINTEGERS where T2<:UNSAFEINTEGERS
            T = promote_type(T1, T2)
            I = itype(T)
            I2 = itype(T1)
            I1 = itype(T2)
            r1 = reinterpret(I1, x)%I
            r2 = reinterpret(I2, y)%I
            result = $CHK(r1, r2)
            return reinterpret(T, result)
        end

   end
end

#=
# rem, mod conversions
@inline Base.rem(x::T, ::Type{T}) where {T<:SafeInteger} = T
@inline Base.rem(x::Integer, ::Type{T}) where {T<:SafeInteger} = SafeInteger(rem(x, itype(T)))
@inline Base.rem(x::BigInt, ::Type{T}) where {T<:SafeInteger} = error("no rounding BigInt available")
@inline Base.mod(x::T, ::Type{T}) where {T<:SafeInteger} = T
@inline Base.mod(x::Integer, ::Type{T}) where {T<:SafeInteger} = SafeInteger(mod(x, itype(T)))
@inline Base.mod(x::BigInt, ::Type{T}) where {T<:SafeInteger} = error("no rounding mod BigInt available")
=#
