import Base: string, show, hex, bits

function string(x::T) where T<:SafeInteger
    str = string( integer(x) )
    return str
end

show(io::IO, x::T) where T<:SafeInteger = print(io, string(x))
show(x::T) where T<:SafeInteger = print(Base.STDOUT, string(x))

hex(n::T, pad::Int=1) where T<:SafeInteger = hex(integer(n), pad)

bits(n::T) where T<: SafeInteger = bits(integer(n))
