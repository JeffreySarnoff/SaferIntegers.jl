function string(x::T) where T<:SafeSigned
    str = string(baseint(x))
    return str
end

function string(x::T) where T<:SafeUnsigned
    str = string(baseint(x), base=16)
    return str
end

bitstring(n::T) where T<:SafeInteger = bitstring(baseint(n))

show(io::IO, x::T) where T<:SafeInteger = print(io,  string(x))
show(x::T) where T<:SafeInteger = print(Base.stdout, string(x))
