string(x::T) where T<:SafeSigned = string(baseint(x))
string(x::T) where T<:SafeUnsigned = string(baseint(x))

bitstring(n::T) where T<:SafeInteger = bitstring(baseint(n))

repr(x::S) where {S<:SafeInteger} = string(typeof(x),"(",repr(baseint(x)),")")

show(io::IO, x::T) where T<:SafeSigned = show(io,  baseint(x))
show(x::T) where T<:SafeSigned = print(Base.stdout, baseint(x))

show(io::IO, x::T) where T<:SafeUnsigned = show(io,  baseint(x))
show(x::T) where T<:SafeUnsigned = show(Base.stdout, baseint(x))
