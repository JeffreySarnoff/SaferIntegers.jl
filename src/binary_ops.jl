import Base: (<), (<=), (==), (!=), (>=), (>), (&), (|), (⊻), isequal, isless,
             flipsign, copysign, (>>>), (>>), (<<)

for OP in (:(<), :(<=), :(>=), :(>), :(!=), :(==), :isless, :isequal)
    @eval begin

       @inline function $OP(x::T, y::T) where T<:SafeInteger
           ix = integer(x)
           iy = integer(y)
           result = $CHK(ix, iy)
           return safeint(result)
       end

       @inline function $OP(x::T1, y::T2) where T1<:SafeInteger where T2<:SafeInteger
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end

       @inline function $OP(x::T1, y::T2) where T1<:SafeInteger where T2<:Integer
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end

       @inline function $OP(x::T1, y::T2) where T1<:Integer where T2<:SafeInteger
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end
   end
end

for OP in (:(&), :(|), :(⊻), :flipsign, :copysign, :(>>>), :(>>), :(<<))
    @eval begin

       @inline function $OP(x::T, y::T) where T<:SafeInteger
           ix = integer(x)
           iy = integer(y)
           result = $CHK(ix, iy)
           return safeint(result)
       end

       @inline function $OP(x::T1, y::T2) where T1<:SafeInteger where T2<:SafeInteger
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end

       @inline function $OP(x::T1, y::T2) where T1<:SafeInteger where T2<:Integer
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end

       @inline function $OP(x::T2, y::T1) where T1<:SafeInteger where T2<:Integer
           xx, yy = promote(x, y)
           return $OP(xx, yy)
       end

   end
end
