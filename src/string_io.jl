function string(x::T) where T<:SafeSigned
    str = string(baseint(x))
    return str
end

function string(x::T) where T<:SafeUnsigned
    str = string(baseint(x))
    return str
end

bitstring(n::T) where T<:SafeInteger = bitstring(baseint(n))

show(io::IO, x::T) where T<:SafeSigned = print(io,  string(x))
show(x::T) where T<:SafeSigned = print(Base.stdout, string(x))

show(io::IO, x::T) where T<:SafeUnsigned = print(io,  baseint(x))
show(x::T) where T<:SafeUnsigned = print(Base.stdout, baseint(x))
