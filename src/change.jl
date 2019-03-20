# work with ChangePrecision.jl

function changeprecision(T, x::I) where {T<:Union{SafeSigned, SafeUnsigned}, I<:Union{Integer,SafeSigned,SafeUnsigned}}
    if T === :SafeInt
        return Int === Int64 ? SafeInt64(x) : SafeInt32(x)
    elseif T === :SafeInt64
        return SafeInt64(x)
    elseif T === :SafeInt32
        return SafeInt32(x)
    elseif T === :SafeInt128
        return SafeInt128(x)
    elseif T === :SafeInt16
        return SafeInt16(x)
    elseif T === :SafeInt8
        return SafeInt8(x)
    elseif T === :SafeUInt
        return Int === Int64 ? SafeUInt64(x) : SafeUInt32(x)
    elseif T === :SafeUInt64
        return SafeUInt64(x)
    elseif T === :SafeUInt32
        return SafeUInt32(x)
    elseif T === :SafeUInt128
        return SafeUInt128(x)
    elseif T === :SafeUInt16
        return SafeUInt16(x)
    elseif T === :SafeUInt8
        return SafeUInt8(x)
    else
        return :(parse($T, $(string(x))))
    end
end
