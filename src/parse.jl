for (S,T) in ((:SafeInt8, :Int8), (:SafeInt16, :Int16), (:SafeInt32, :Int32),  (:SafeInt64, :Int64), (:SafeInt128, :Int128))
  @eval begin    
    function parse(::Type{$S}, str::A) where {A<:AbstractString}
      x = parse($T, str)
      return $S(x)
    end
    
    function tryparse(::Type{$S}, str::A; base::Int=10) where {A<:AbstractString}
      x = tryparse($T, str, base=base)
      return $S(x)
    end
    
    function tryparse(::Type{$S}, str::A; base::SafeInt32=10) where {A<:AbstractString}
      x = tryparse($T, str, base=Int(base))
      return $S(x)
    end

    function tryparse(::Type{$S}, str::A; base::SafeInt64=10) where {A<:AbstractString}
      x = tryparse($T, str, base=Int(base))
      return $S(x)
    end
  end
end

for (S,T) in ((:SafeUInt8, :UInt8), (:SafeUInt16, :UInt16), (:SafeUInt32, :Int32),  (:SafeUInt64, :UInt64), (:SafeUInt128, :UInt128))
  @eval begin    
    function parse(::Type{$S}, str::A) where {A<:AbstractString}
      x = parse($T, str)
      return $S(x)
    end
    
    function tryparse(::Type{$S}, str::A; base::Int=10) where {A<:AbstractString}
      x = tryparse($T, str, base=base)
      return $S(x)
    end
    
    function tryparse(::Type{$S}, str::A; base::SafeInt32=10) where {A<:AbstractString}
      x = tryparse($T, str, base=Int(base))
      return $S(x)
    end

    function tryparse(::Type{$S}, str::A; base::SafeInt64=10) where {A<:AbstractString}
      x = tryparse($T, str, base=Int(base))
      return $S(x)
    end
  end
end

