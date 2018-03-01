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

hex(n::T, pad::Int=1) where T<:SafeInteger = hex(integer(n), pad)

bits(n::T) where T<: SafeInteger = bits(integer(n))

Base.string(x::T) where T<:SafeInteger = string(signed(x))
Base.show(io::IO, x::T) where T<:SafeInteger = print(io, string(x) )

Base.hex(n::T, pad::Int=1) where T<:SafeInteger = hex(signed(n), pad)
Base.bits(n::T) where T<: SafeInteger = bits(signed(n))
