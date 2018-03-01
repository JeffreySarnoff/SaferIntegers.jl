import Base: string, show, hex, bits

function string(x::T) where T<:SafeSigned
    str = string( integer(x) )
    return str
end

function string(x::T) where T<:SafeUnsigned
    uint = integer(x)
    str = string("0x", hex(uint, sizeof(uint)*2))
    return str
end

show(io::IO, x::T) where T<:SafeInteger = print(io, string(x))
show(x::T) where T<:SafeInteger = print(Base.STDOUT, string(x))

hex(n::T, pad::Int=1) where T<:SafeUnsigned = hex(integer(n), pad)
hex(n::T, pad::Int=1) where T<:SafeSigned = hex(signed(n), pad)

bits(n::T) where T<: SafeUnsigned = bits(integer(n))
bits(n::T) where T<: SafeSigned = bits(signed(n))
