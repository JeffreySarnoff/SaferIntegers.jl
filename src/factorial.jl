const _fact_tab64 = SafeInt64.(Base._fact_table64)
const _fact_tab128 = SafeUInt128.(Base._fact_table128)

function factorial_lookup(n::S, table, lim) where {S<:Union{SafeSigned, SafeUnsigned}}
    n < 0 && throw(DomainError(n, "`n` must not be negative."))
    n > lim && throw(OverflowError(string(n, "! is too large to fit in a $S")))
    n == 0 && return one(n)
    @inbounds f = table[n]
    return oftype(n, f)
end

Base.factorial(n::SafeInt128) = factorial_lookup(n, _fact_tab128, 33)
Base.factorial(n::SafeUInt128) = factorial_lookup(n, _fact_tab128, 34)
Base.factorial(n::Union{SafeInt64,SafeUInt64}) = factorial_lookup(n, _fact_tab64, 20)


if Int === Int32
    Base.factorial(n::Union{SafeInt8,SafeUInt8,SafeInt16,SafeUInt16}) = factorial(SafeInt32(n))
    Base.factorial(n::Union{SafeInt32,SafeUInt32}) = factorial_lookup(n, _fact_tab64, 12)
else
    Base.factorial(n::Union{SafeInt8,SafeUInt8,SafeInt16,SafeUInt16,SafeInt32,SafeUInt32}) = factorial(SafeInt64(n))
end

