for (S,T) in ((:SafeInt8, :Int8), (:SafeInt16, :Int16), (:SafeInt32, :Int32),  (:SafeInt64, :Int64), (:SafeInt128, :Int128))
  @eval begin    
     function parse(::Type{$S}, str::A) where {A<:AbstractString}
       (occursin('.', str) || occursin('e', str) || occursin('f', str)) && return Meta.parse(str)
       x = parse($T, str)
       return $S(x)
     end
    
    function tryparse(::Type{$S}, str::A; base=10) where {A<:AbstractString}
      x = tryparse($T, str, base=Int(base))
      return ifelse(isnothing(x), nothing, $S(x))
    end
  end
end

for (S,T) in ((:SafeUInt8, :UInt8), (:SafeUInt16, :UInt16), (:SafeUInt32, :Int32),  (:SafeUInt64, :UInt64), (:SafeUInt128, :UInt128))
  @eval begin    
    function parse(::Type{$S}, str::A) where {A<:AbstractString}
      (occursin('.', str) || occursin('e', str) || occursin('f', str)) && return Meta.parse(str)
      x = parse($T, str)
      return $S(x)
    end
    
    function tryparse(::Type{$S}, str::A; base=10) where {A<:AbstractString}
      x = tryparse($T, str, base=Int(base))
      return ifelse(isnothing(x), nothing, $S(x))
    end
  end
end

