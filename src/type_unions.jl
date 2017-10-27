const SAFESIGNED   = Union{SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128}
const SAFEUNSIGNED = Union{SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128}
const SAFEINTEGERS = Union{SAFESIGNED, SAFEUNSIGNED}

const SAFE_SIGNED   = (:SafeInt8, :SafeInt16, :SafeInt32, :SafeInt64, :SafeInt128)
const SAFE_UNSIGNED = (:SafeUInt8, :SafeUInt16, :SafeUInt32, :SafeUInt64, :SafeUInt128)
const SAFE_INTEGERS = (:SafeInt8, :SafeInt16, :SafeInt32, :SafeInt64, :SafeInt128,
                       :SafeUInt8, :SafeUInt16, :SafeUInt32, :SafeUInt64, :SafeUInt128)

const UNSAFESIGNED   = Union{Int8, Int16, Int32, Int64, Int128}
const UNSAFEUNSIGNED = Union{UInt8, UInt16, UInt32, UInt64, UInt128}
const UNSAFEINTEGERS = Union{UNSAFESIGNED, UNSAFEUNSIGNED}

const UNSAFE_SIGNED   = (:Int8, :Int16, :Int32, :Int64, :Int128)
const UNSAFE_UNSIGNED = (:UInt8, :UInt16, :UInt32, :UInt64, :UInt128)
const UNSAFE_INTEGERS = (:Int8, :Int16, :Int32, :Int64, :Int128,
                         :UInt8, :UInt16, :UInt32, :UInt64, :UInt128)
