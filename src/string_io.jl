import Base: string, show, hex, bitstring

function string(x::T) where T<:SafeSigned
    str = string(baseint(x))
    return str
end

function string(x::T) where T<:SafeUnsigned
    uint = baseint(x)
    str = string("0x", hex(uint, sizeof(uint)*2))
    return str
end

show(io::IO, x::T) where T<:SafeInteger = print(io, string(x))
show(x::T) where T<:SafeInteger = print(Base.stdout, string(x))

hex(n::T, pad::Int=1) where T<:SafeUnsigned = hex(baseint(n), pad)
hex(n::T, pad::Int=1) where T<:SafeSigned   = hex(signed(n), pad)

bitstring(n::T) where T<: SafeUnsigned = bitstring(baseint(n))
bitstring(n::T) where T<: SafeSigned   = bitstring(signed(n))
