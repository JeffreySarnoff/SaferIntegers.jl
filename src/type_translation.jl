itype(::Type{SafeSigned})   = Signed
itype(::Type{SafeUnsigned}) = Unsigned
itype(::Type{SafeInteger})  = Integer

itype(::Type{SafeInt8})     = Int8
itype(::Type{SafeInt16})    = Int16
itype(::Type{SafeInt32})    = Int32
itype(::Type{SafeInt64})    = Int64
itype(::Type{SafeInt128})   = Int128

itype(::Type{SafeUInt8})    = UInt8
itype(::Type{SafeUInt16})   = UInt16
itype(::Type{SafeUInt32})   = UInt32
itype(::Type{SafeUInt64})   = UInt64
itype(::Type{SafeUInt128})  = UInt128

itype(::Type{T}) where T<:Signed   = T
itype(::Type{T}) where T<:Unsigned = T

itype(x::T) where T<:Signed   = T
itype(x::T) where T<:Unsigned = T
itype(x::T) where T<:SafeSigned   = itype(T)
itype(x::T) where T<:SafeUnsigned = itype(T)

stype(::Type{Signed})   = SafeSigned
stype(::Type{Unsigned}) = SafeUnsigned
stype(::Type{Integer})  = SafeSigned

stype(::Type{Int8})     = SafeInt8
stype(::Type{Int16})    = SafeInt16
stype(::Type{Int32})    = SafeInt32
stype(::Type{Int64})    = SafeInt64
stype(::Type{Int128})   = SafeInt128

stype(::Type{UInt8})    = SafeUInt8
stype(::Type{UInt16})   = SafeUInt16
stype(::Type{UInt32})   = SafeUInt32
stype(::Type{UInt64})   = SafeUInt64
stype(::Type{UInt128})  = SafeUInt128

stype(::Type{T}) where T<:Signed   = stype(T)
stype(::Type{T}) where T<:Unsigned = stype(T)

stype(x::T) where T<:SafeSigned   = T
stype(x::T) where T<:SafeUnsigned = T
stype(x::T) where T<:Signed   = stype(T)
stype(x::T) where T<:Unsigned = stype(T)


for i in 1:length(SAFE_INTEGERS)
    S1 = SAFE_INTEGERS[i]
    @eval Base.promote_rule(::Type{$S1}, y::Type{$S1}) = $S1
    for k in i+1:length(SAFE_INTEGERS)
        S2 = SAFE_INTEGERS[k]
        @eval Base.promote_rule(::Type{$S1}, ::Type{$S2}) = promote_type(itype($S1), itype($S2))
    end
end

# we want SaferIntegers to dominate unsafe integers when promoted
for i in 1:length(SAFE_INTEGERS)
    SAFE = SAFE_INTEGERS[i]
    for k in 1:length(UNSAFE_INTEGERS)
        UNSAFE = UNSAFE_INTEGERS[k]
        @eval Base.promote_type(::Type{$SAFE}, ::Type{$UNSAFE}) = stype(promote_type(itype($SAFE), itype($UNSAFE)))
    end
end



# We want the *Safety* to be sticky with familiar integer-like numbers
# and to be soapy with non-integer-esque numbers (including BigInt).

const SS1 = SafeSigned; const SS2 = SafeSigned;
const SU1 = SafeUnsigned; const SU2 = SafeUnsigned;

#=
Base.promote_type(::Type{S1}, ::Type{S2}) where S1<:SS1 where S2<:SS1 = stype(promote_type(itype(S1), itype(S2)))
Base.promote_type(::Type{S1}, ::Type{S2}) where S1<:SU1 where S2<:SU1 = stype(promote_type(itype(S1), itype(S2)))
Base.promote_type(::Type{S1}, ::Type{S2}) where S1<:SS1 where S2<:SU1 = stype(promote_type(itype(S1), signed(S2)))
Base.promote_type(::Type{S1}, ::Type{S2}) where S1<:SU1 where S2<:SS1 = stype(promote_type(signed(S1), itype(S2)))
Base.promote_type(::Type{S1}, ::Type{S2}) where S1<:SS1 where S2<:Signed   = stype(promote_type(itype(S1), itype(S2)))
Base.promote_type(::Type{S1}, ::Type{S2}) where S1<:SU1 where S2<:Unsigned = stype(promote_type(itype(S1), itype(S2)))
Base.promote_type(::Type{S1}, ::Type{S2}) where S1<:SU1 where S2<:Signed   = stype(promote_type(itype(SafeSigned(S1), itype(S2))))
Base.promote_type(::Type{S1}, ::Type{S2}) where S1<:SS1 where S2<:Unsigned = stype(promote_type(itype(S1), itype(SafeSigned(S2))))

Base.promote_rule(::Type{T}, ::Type{SI}) where T<:SafeSigned where SI<:SafeSigned = promote_type(T, SI)
Base.promote_rule(::Type{T}, ::Type{SU}) where T<:SafeUnsigned where SU<:SafeUnsigned = promote_type(T, SU)
Base.promote_rule(::Type{T}, ::Type{SI}) where T<:SafeUnsigned where SI<:SafeSigned = promote_type(T, SI)
Base.promote_rule(::Type{T}, ::Type{SU}) where T<:SafeSigned where SU<:SafeUnsigned = promote_type(T, SU)
Base.promote_rule(::Type{T}, ::Type{SI}) where T<:Signed where SI<:SafeSigned = promote_type(T, SI)
Base.promote_rule(::Type{T}, ::Type{SU}) where T<:Unsigned where SU<:SafeUnsigned = promote_type(T, SU)
Base.promote_rule(::Type{T}, ::Type{SI}) where T<:Unsigned where SI<:SafeSigned = promote_type(T, SI)
Base.promote_rule(::Type{T}, ::Type{SU}) where T<:Signed where SU<:SafeUnsigned = promote_type(T, SU)

Base.promote_rule(::Type{T}, ::Type{SI}) where {T<:Real, SI<:SafeInteger} = promote_type(T, SI)
Base.promote_rule(::Type{T}, ::Type{SI}) where {T<:Number, SI<:SafeInteger} = promote_type(T, itype(SI))
=#

Base.promote_rule(::Type{Rational{T}}, ::Type{SI}) where {T<:Integer, SI<:SafeInteger} = promote_type(T, SI)

# Resolve ambiguities
Base.promote_rule(::Type{Bool}, ::Type{SI}) where {SI<:SafeInteger} = promote_type(Bool, itype(SI))
Base.promote_rule(::Type{BigInt}, ::Type{SI}) where {SI<:SafeInteger} = promote_type(BigInt, itype(SI))
Base.promote_rule(::Type{BigFloat}, ::Type{SI}) where {SI<:SafeInteger} = promote_type(BigFloat, itype(SI))
Base.promote_rule(::Type{Complex{T}}, ::Type{SI}) where {T<:Real,SI<:SafeInteger} = promote_type(Complex{T}, itype(SI))
Base.promote_rule(::Type{<:Irrational}, ::Type{SI}) where {SI<:SafeInteger} = promote_type(Float64, itype(SI))

(::Type{Signed})(x::SafeSigned)     = reinterpret(itype(x), x)
(::Type{Unsigned})(x::SafeUnsigned) = reinterpret(itype(x), x)
(::Type{SafeSigned})(x::Signed)     = reinterpret(stype(x), x)
(::Type{SafeUnsigned})(x::Unsigned) = reinterpret(stype(x), x)
(::Type{Integer})(x::SafeSigned)    = Signed(x)
(::Type{Integer})(x::SafeUnsigned)  = Unsigned(x)
(::Type{SafeInteger})(x::Signed)    = SafeSigned(x)
(::Type{SafeInteger})(x::Unsigned)  = SafeUnsigned(x)

Base.signed(x::T) where T<:SafeSigned     = x
Base.unsigned(x::T) where T<:SafeUnsigned = x
Base.signed(x::T) where T<:SafeUnsigned   = SafeInteger(signed(Integer(x)))
Base.unsigned(x::T) where T<:SafeSigned   = SafeInteger(unsigned(Integer(x)))



# We want SaferIntegers to promote as their unsafe analogues do
#    although promote_type(U::SafeUnsigned, S::SafeSigned) should be narrow
#    so we revise SafeSigned(u::SafeUnisigned) to be correctly narrow
#    so we revise SafeUnsigned(u::SafeSigned)  to be correctly narrow

SafeSigned(::Type{Int8})   = SafeInt8
SafeSigned(::Type{Int16})  = SafeInt16
SafeSigned(::Type{Int32})  = SafeInt32
SafeSigned(::Type{Int64})  = SafeInt64
SafeSigned(::Type{Int128}) = SafeInt128

SafeSigned(::Type{UInt8})   = SafeInt16
SafeSigned(::Type{UInt16})  = SafeInt32
SafeSigned(::Type{UInt32})  = SafeInt64
SafeSigned(::Type{UInt64})  = SafeInt128
SafeSigned(::Type{UInt128}) = SafeInt128

SafeSigned(::Type{SafeInt8})   = SafeInt8
SafeSigned(::Type{SafeInt16})  = SafeInt16
SafeSigned(::Type{SafeInt32})  = SafeInt32
SafeSigned(::Type{SafeInt64})  = SafeInt64
SafeSigned(::Type{SafeInt128}) = SafeInt128

SafeSigned(::Type{SafeUInt8})   = SafeInt16
SafeSigned(::Type{SafeUInt16})  = SafeInt32
SafeSigned(::Type{SafeUInt32})  = SafeInt64
SafeSigned(::Type{SafeUInt64})  = SafeInt128
SafeSigned(::Type{SafeUInt128}) = SafeInt128

SafeUnsigned(::Type{UInt8})   = SafeUInt8
SafeUnsigned(::Type{UInt16})  = SafeUInt16
SafeUnsigned(::Type{UInt32})  = SafeUInt32
SafeUnsigned(::Type{UInt64})  = SafeUInt64
SafeUnsigned(::Type{UInt128}) = SafeUInt128

SafeUnsigned(::Type{Int8})   = SafeUInt16
SafeUnsigned(::Type{Int16})  = SafeUInt32
SafeUnsigned(::Type{Int32})  = SafeUInt64
SafeUnsigned(::Type{Int64})  = SafeUInt128
SafeUnsigned(::Type{Int128}) = SafeUInt128

SafeUnsigned(::Type{SafeUInt8})   = SafeUInt8
SafeUnsigned(::Type{SafeUInt16})  = SafeUInt16
SafeUnsigned(::Type{SafeUInt32})  = SafeUInt32
SafeUnsigned(::Type{SafeUInt64})  = SafeUInt64
SafeUnsigned(::Type{SafeUInt128}) = SafeUInt128

SafeUnisgned(::Type{SafeInt8})   = SafeUInt16
SafeUnsigned(::Type{SafeInt16})  = SafeUInt32
SafeUnsigned(::Type{SafeInt32})  = SafeUInt64
SafeUnsigned(::Type{SafeInt64})  = SafeUInt128
SafeUnsigned(::Type{SafeInt128}) = SafeUInt128

Base.promote_type(::Type{T}, ::Type{T}) where T<:SAFEINTEGERS = T
Base.promote_type(::Type{T1}, ::Type{T2}) where T1<:SAFESIGNED where T2<:SAFESIGNED = sizeof(T1) < sizeof(T2) ? T2 : T1
Base.promote_type(::Type{T1}, ::Type{T2}) where T1<:SAFEUNSIGNED where T2<:SAFEUNSIGNED = sizeof(T1) < sizeof(T2) ? T2 : T1

Base.promote_type(::Type{SafeInt8}, ::Type{SafeUInt8})   = SafeUInt16
Base.promote_type(::Type{SafeInt8}, ::Type{SafeUInt16})  = SafeUInt32
Base.promote_type(::Type{SafeInt8}, ::Type{SafeUInt32})  = SafeUInt64
Base.promote_type(::Type{SafeInt8}, ::Type{SafeUInt64})  = SafeUInt128
Base.promote_type(::Type{SafeInt8}, ::Type{SafeUInt128}) = SafeUInt128

Base.promote_type(::Type{SafeInt16}, ::Type{SafeUInt8})   = SafeInt16
Base.promote_type(::Type{SafeInt16}, ::Type{SafeUInt16})  = SafeUInt16
Base.promote_type(::Type{SafeInt16}, ::Type{SafeUInt32})  = SafeUInt32
Base.promote_type(::Type{SafeInt16}, ::Type{SafeUInt64})  = SafeUInt64
Base.promote_type(::Type{SafeInt16}, ::Type{SafeUInt128}) = SafeInt128

Base.promote_type(::Type{SafeInt32}, ::Type{SafeUInt8})   = SafeInt32
Base.promote_type(::Type{SafeInt32}, ::Type{SafeUInt16})  = SafeInt32
Base.promote_type(::Type{SafeInt32}, ::Type{SafeUInt32})  = SafeInt64
Base.promote_type(::Type{SafeInt32}, ::Type{SafeUInt64})  = SafeInt128
Base.promote_type(::Type{SafeInt32}, ::Type{SafeUInt128}) = SafeInt128

Base.promote_type(::Type{SafeInt64}, ::Type{SafeUInt8})   = SafeInt64
Base.promote_type(::Type{SafeInt64}, ::Type{SafeUInt16})  = SafeInt64
Base.promote_type(::Type{SafeInt64}, ::Type{SafeUInt32})  = SafeInt64
Base.promote_type(::Type{SafeInt64}, ::Type{SafeUInt64})  = SafeInt128
Base.promote_type(::Type{SafeInt64}, ::Type{SafeUInt128}) = SafeInt128

Base.promote_type(::Type{SafeInt128}, ::Type{SafeUInt8})   = SafeInt128
Base.promote_type(::Type{SafeInt128}, ::Type{SafeUInt16})  = SafeInt128
Base.promote_type(::Type{SafeInt128}, ::Type{SafeUInt32})  = SafeInt128
Base.promote_type(::Type{SafeInt128}, ::Type{SafeUInt64})  = SafeInt128
Base.promote_type(::Type{SafeInt128}, ::Type{SafeUInt128}) = SafeInt128

Base.promote_type(::Type{U}, ::Type{S}) where U<:SAFEUNSIGNED where S<:SAFESIGNED = promote_type(S,U)
#Base.promote_type(::Type{Union{}}, ::Type{T}) where T<:SAFEINTEGERS = T

Base.promote_type(::Type{U}, ::Type{S}) where U<:UNSAFEINTEGERS where S<:SAFEINTEGERS = promote_type(S,U)

#=
Base.promote_type(::Type{SafeInt8}, ::Type{UInt8})   = SafeInt16
Base.promote_type(::Type{SafeInt8}, ::Type{UInt16})  = SafeInt32
Base.promote_type(::Type{SafeInt8}, ::Type{UInt32})  = SafeInt64
Base.promote_type(::Type{SafeInt8}, ::Type{UInt64})  = SafeInt128
Base.promote_type(::Type{SafeInt8}, ::Type{UInt128}) = SafeInt128

Base.promote_type(::Type{SafeInt16}, ::Type{UInt8})   = SafeInt16
Base.promote_type(::Type{SafeInt16}, ::Type{UInt16})  = SafeInt16
Base.promote_type(::Type{SafeInt16}, ::Type{UInt32})  = SafeInt32
Base.promote_type(::Type{SafeInt16}, ::Type{UInt64})  = SafeInt64
Base.promote_type(::Type{SafeInt16}, ::Type{UInt128}) = SafeInt128

Base.promote_type(::Type{SafeInt32}, ::Type{UInt8})   = SafeInt32
Base.promote_type(::Type{SafeInt32}, ::Type{UInt16})  = SafeInt32
Base.promote_type(::Type{SafeInt32}, ::Type{UInt32})  = SafeInt64
Base.promote_type(::Type{SafeInt32}, ::Type{UInt64})  = SafeInt128
Base.promote_type(::Type{SafeInt32}, ::Type{UInt128}) = SafeInt128

Base.promote_type(::Type{SafeInt64}, ::Type{UInt8})   = SafeInt64
Base.promote_type(::Type{SafeInt64}, ::Type{UInt16})  = SafeInt64
Base.promote_type(::Type{SafeInt64}, ::Type{UInt32})  = SafeInt64
Base.promote_type(::Type{SafeInt64}, ::Type{UInt64})  = SafeInt128
Base.promote_type(::Type{SafeInt64}, ::Type{UInt128}) = SafeInt128

Base.promote_type(::Type{SafeInt128}, ::Type{UInt8})   = SafeInt128
Base.promote_type(::Type{SafeInt128}, ::Type{UInt16})  = SafeInt128
Base.promote_type(::Type{SafeInt128}, ::Type{UInt32})  = SafeInt128
Base.promote_type(::Type{SafeInt128}, ::Type{UInt64})  = SafeInt128
Base.promote_type(::Type{SafeInt128}, ::Type{UInt128}) = SafeInt128

Base.promote_type(::Type{U}, ::Type{S}) where U<:UNSAFEUNSIGNED where S<:SAFESIGNED = promote_type(S,U)
=#

Base.promote_rule(::Type{S1}, ::Type{S2}) where S1<:SafeSigned where S2<:SafeSigned = SafeSigned(promote_type(itype(S1),itype(S2)))
Base.promote_rule(::Type{U1}, ::Type{U2}) where U1<:SafeUnsigned where U2<:SafeUnsigned = SafeUnsigned(promote_type(itype(U1),itype(U2)))
Base.promote_rule(::Type{S1}, ::Type{U1}) where S1<:SafeSigned where U1<:SafeUnsigned = SafeSigned(promote_type(itype(S1),itype(U1)))
Base.promote_rule(::Type{S1}, ::Type{S2}) where S1<:SafeSigned where S2<:Signed = SafeSigned(promote_type(itype(S1),itype(S2)))
Base.promote_rule(::Type{U1}, ::Type{U2}) where U1<:SafeUnsigned where U2<:Unsigned = SafeUnsigned(promote_type(itype(U1),itype(U2)))
Base.promote_rule(::Type{S1}, ::Type{U1}) where S1<:SafeSigned where U1<:Unsigned = SafeSigned(promote_type(itype(S1),itype(U1)))
Base.promote_rule(::Type{U1}, ::Type{S1}) where U1<:SafeUnsigned where S1<:Signed = SafeUnsigned(promote_type(itype(U1),itype(S1)))
