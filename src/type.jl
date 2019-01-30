abstract type SafeInteger  <: Integer     end
abstract type SafeUnsigned <: SafeInteger end
abstract type SafeSigned   <: SafeInteger end

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

# these are available for autoconversion to SaferIntegers

const SysInts = Union{Int8, Int16, Int32, Int64, Int128}
const SysUInts = Union{UInt8, UInt16, UInt32, UInt64, UInt128}
const SysIntegers = Union{SysInts, SysUInts}

const SafeInts = Union{SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128}
const SafeUInts = Union{SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128}
const SafeIntegers = Union{SafeInts, SafeUInts}
