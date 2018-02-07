Base.string(x::T) where T<:SafeInteger = string(signed(x))
Base.show(io::IO, x::T) where T<:SafeInteger = print(io, string(x) )

Base.hex(n::T, pad::Int=1) where T<:SafeInteger = hex(signed(n), pad)
Base.bits(n::T) where T<: SafeInteger = bits(signed(n))
