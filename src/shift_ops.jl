import Base: (>>>), (>>), (<<)

bitsof(::Type{T}) where T<:UNSAFEINTEGERS = sizeof(T)<<3
bitsof(::Type{T}) where T<:SAFEINTEGERS = sizeof(itype(T))<<3

unsafe_logicalshift_right(x::T, y::T) where T<:UNSAFEINTEGERS = x>>y
unsafe_logicalshift_left(x::T, y::T) where T<:UNSAFEINTEGERS = x<<y
unsafe_arithshift_right(x::T, y::T) where T<:UNSAFEINTEGERS = x>>>y

unsafe_logicalshift_right(x::T, y::T) where T<:SAFEINTEGERS = reinterpret(T, Integer(x)>>Integer(y))
unsafe_logicalshift_left(x::T, y::T) where T<:SAFEINTEGERS = reinterpret(T, Integer(x)<<Integer(y))
unsafe_arithshift_right(x::T, y::T) where T<:SAFEINTEGERS = reinterpret(T, Integer(x)>>>Integer(y))


for OP in (:(>>>), :(>>), :(<<))
    @eval begin

       @inline function $OP(x::T, y::T) where T<:SAFEINTEGERS
            I = itype(T)
            r1 = reinterpret(I, x)
            r2 = reinterpret(I, y)
            abs(r2) > bitsof(I) && throw(OverflowError())
            result = $OP(r1, r2)

            return reinterpret(T, result)
        end

        @inline function $OP(x::T1, y::T2) where T1<:SAFEINTEGERS where T2<:SAFEINTEGERS
            T = promote_type(T1, T2)
            I = itype(T)
            I1 = itype(T1)
            I2 = itype(T2)
            r1 = reinterpret(I1, x)%I
            r2 = reinterpret(I2, y)%I
            abs(r2) > bitsof(I) && throw(OverflowError())
            result = $OP(r1, r2)
            return reinterpret(T, result)
        end

        @inline function $OP(x::T1, y::T2) where T1<:SAFEINTEGERS where T2<:UNSAFEINTEGERS
            T = promote_type(T1, T2)
            I = itype(T)
            I1 = itype(T1)
            I2 = itype(T2)
            r1 = reinterpret(I1, x)%I
            r2 = reinterpret(I2, y)%I
            abs(r2) > bitsof(I) && throw(OverflowError())
            result = $OP(r1, r2)
            return reinterpret(T, result)
        end

        @inline function $OP(x::T2, y::T1) where T1<:SAFEINTEGERS where T2<:UNSAFEINTEGERS
            T = promote_type(T1, T2)
            I = itype(T)
            I2 = itype(T1)
            I1 = itype(T2)
            r1 = reinterpret(I1, x)%I
            r2 = reinterpret(I2, y)%I
            abs(r2) > bitsof(I) && throw(OverflowError())
            result = $OP(r1, r2)
            return reinterpret(T, result)
        end

   end
end

# fix ambiguity
for OP in (:(>>>), :(>>), :(<<))
    @eval begin
        function $OP(x::SF, y::Int64) where SF<:SAFEINTEGERS
            T = SF
            I = itype(T)
            r1 = reinterpret(I, x)%Int64
            r2 = y
            abs(r2) > bitsof(I) && throw(OverflowError())
            result = $OP(r1, r2)
            return reinterpret(T, result)
         end
    end
end
