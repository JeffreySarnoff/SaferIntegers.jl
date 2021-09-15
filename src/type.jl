abstract type SafeUnsigned <: Unsigned end
abstract type SafeSigned <: Signed end

const SafeInteger = Union{SafeUnsigned, SafeSigned}

primitive type SafeInt8    <: SafeSigned     8 end
primitive type SafeInt16   <: SafeSigned    16 end
primitive type SafeInt32   <: SafeSigned    32 end
primitive type SafeInt64   <: SafeSigned    64 end
primitive type SafeInt128  <: SafeSigned   128 end

primitive type SafeUInt8   <: SafeUnsigned   8 end
primitive type SafeUInt16  <: SafeUnsigned  16 end
primitive type SafeUInt32  <: SafeUnsigned  32 end
primitive type SafeUInt64  <: SafeUnsigned  64 end
primitive type SafeUInt128 <: SafeUnsigned 128 end

if Sys.WORD_SIZE == 32
    const SafeInt  = SafeInt32
    const SafeUInt = SafeUInt32
else
    const SafeInt  = SafeInt64
    const SafeUInt = SafeUInt64
end

# use with @eval loops

const UnpairedSafes = (:SafeUnsigned, :SafeSigned)

const MixedSafes = ((SafeUnsigned, SafeSigned),)

const PairedSafes = ((SafeUnsigned, SafeUnsigned),
                     (SafeSigned, SafeSigned),
                     (SafeUnsigned, SafeSigned),
                     (SafeSigned, SafeUnsigned))

const MixedInts  = ((SafeUnsigned, Base.BitUnsigned),
                    (SafeUnsigned, Base.BitSigned),
                    (SafeSigned, Base.BitUnsigned),
                    (SafeSigned, Base.BitSigned))

const MixedTypes = ((SafeUnsigned, SafeSigned),
                    (SafeUnsigned, Base.BitUnsigned),
                    (SafeUnsigned, Base.BitSigned),
                    (SafeSigned, Base.BitUnsigned),
                    (SafeSigned, Base.BitSigned))

const MixedPairs = ((SafeUnsigned, SafeUnsigned),
                    (SafeSigned, SafeSigned),
                    (SafeUnsigned, SafeSigned),
                    (SafeSigned, SafeUnsigned),
                    (SafeUnsigned, Base.BitUnsigned),
                    (SafeUnsigned, Base.BitSigned),
                    (SafeSigned, Base.BitUnsigned),
                    (SafeSigned, Base.BitSigned))
