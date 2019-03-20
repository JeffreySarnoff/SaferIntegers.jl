# the better parts of this derive from ChangePrecision.jl

module SaferIntTypes

export @saferintegers

import Random
using Random: AbstractRNG

using MacroTools

using ..SaferIntegers

## Note: code in this module must be very careful with math functions,
#        because we've defined module-specific versions of very basic
#        functions like + and *.   Call Base.:+ etcetera if needed.



const HWInt = Union{Bool,Int8,Int16,Int32,Int64,Int128,UInt8,UInt16,UInt32,UInt64,UInt128}

const SFInt = Union{SafeInt, SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128, SafeUInt, SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128}

const randfuncs = (:rand,) # random-number generators
const matfuncs = (:ones, :zeros) # functions to construct arrays
const binaryfuncs = (:*, :+, :-, :^) # binary functions on irrationals that make Float64

const changefuncs = Set([randfuncs..., matfuncs...,
                         binaryfuncs..., :include])


changetype(x) = x

changetype(x::SafeInt128) = x
changetype(x::SafeInt64) = x
changetype(x::SafeInt32) = x
changetype(x::SafeInt16) = x
changetype(x::SafeInt8) = x

changetype(x::SafeUInt128) = x
changetype(x::SafeUInt64) = x
changetype(x::SafeUInt32) = x
changetype(x::SafeUInt16) = x
changetype(x::SafeUInt8) = x

changetype(x::Int128) = SafeInt128(x)
changetype(x::Int64) = SafeInt64(x)
changetype(x::Int32) = SafeInt32(x)
changetype(x::Int16) = SafeInt16(x)
changetype(x::Int8) = SafeInt8(x)

changetype(x::UInt128) = SafeUInt128(x)
changetype(x::UInt64) = SafeUInt64(x)
changetype(x::UInt32) = SafeUInt32(x)
changetype(x::UInt16) = SafeUInt16(x)
changetype(x::UInt8) = SafeUInt8(x)

changetype(x::String) = x

function changetype(ex::Expr)
    if isa(ex, String)
        return ex
    elseif isa(ex, Integer)
        return Int === Int64 ? SafeInt64(ex) : SafeInt32(ex)
    elseif (Meta.isexpr(ex, :call, 2) && isa(ex.args[2], Integer))
        return changetype_of_cast_int(ex)     
    elseif (Meta.isexpr(ex, :(=), 2) && isa(ex.args[2], Integer) && isa(ex.args[1], Symbol))
        ex.args[2] = Int === Int64 ? SafeInt64(ex.args[2]) : SafeInt32(ex.args[2])
        return ex
    elseif (Meta.isexpr(ex, :(=), 2) && isa(ex.args[2], Integer))
        return changetype_of_cast_int(ex)
   # elseif (Meta.isexpr(ex, :call, 2) && isa(ex.args[2].args[2], Integer))
    #    return changetype_of_assigned_cast_int(ex)
    #elseif (Meta.isexpr(ex, :(=), 2) && isa(ex.args[2].args[2], Integer))
     #   return changetype_of_assigned_cast_int(ex)
    else
        return changetypes(ex)
    end
end


function changetypes(ex::Expr)
    if Meta.isexpr(ex, :call, 3) && ex.args[1] == :^ && ex.args[3] isa Int
        # mimic Julia 0.6/0.7's lowering to literal_pow
        return Expr(:call, ChangeType.literal_pow, :^, changetype(ex.args[2]), Val{ex.args[3]}())
    elseif Meta.isexpr(ex, :call, 2) && ex.args[1] == :include
        return :($include(@__MODULE__, $(ex.args[2])))
    elseif Meta.isexpr(ex, :call) && ex.args[1] in changefuncs
        return Expr(:call, Core.eval(SaferIntTypes, ex.args[1]), changetype.(ex.args[2:end])...)
    elseif Meta.isexpr(ex, :., 2) && ex.args[1] in changefuncs && Meta.isexpr(ex.args[2], :tuple)
        return Expr(:., Core.eval(SaferIntTypes, ex.args[1]), Expr(:tuple, changetype.(ex.args[2].args)...))
    elseif Meta.isexpr(ex, :call, 3) && ex.args[1] == :^ && ex.args[3] isa Int
    else
        return Expr(ex.head, changetype.(ex.args)...)
    end
end

function changetype_of_cast_int(ex::Expr) 
   if @capture(ex, Int64(_))
      ex.args[1] = :SafeInt64
   elseif @capture(ex, Int32(_))
      ex.args[1] = :SafeInt32
   elseif @capture(ex, Int16(_))
      ex.args[1] = :SafeInt16
   elseif @capture(ex, Int8(_))
      ex.args[1] = :SafeInt8
   elseif @capture(ex, Int128(_))
      ex.args[1] = :SafeInt128
   elseif @capture(ex, UInt64(_))
      ex.args[1] = :SafeUInt64
   elseif @capture(ex, UInt32(_))
      ex.args[1] = :SafeUInt32
   elseif @capture(ex, UInt16(_))
      ex.args[1] = :SafeUInt16
   elseif @capture(ex, UInt8(_))
      ex.args[1] = :SafeUInt8
   elseif @capture(ex, UInt128(_))
      ex.args[1] = :SafeUInt128
   end
   return ex
end

function changetype_of_assigned_cast_int(ex::Expr) 
   if @capture(ex, _=Int64(_))
      ex.args[2].args[1] = :SafeInt64
   elseif @capture(ex, _=Int32(_))
      ex.args[2].args[1] = :SafeInt32
   elseif @capture(ex, _=Int16(_))
      ex.args[2].args[1] = :SafeInt16
   elseif @capture(ex, _=Int8(_))
      ex.args[2].args[1] = :SafeInt8
   elseif @capture(ex, _=Int128(_))
      ex.args[2].args[1] = :SafeInt128
   elseif @capture(ex, _=UInt64(_))
      ex.args[2].args[1] = :SafeUInt64
   elseif @capture(ex, _=UInt32(_))
      ex.args[2].args[1] = :SafeUInt32
   elseif @capture(ex, _=UInt16(_))
      ex.args[2].args[1] = :SafeUInt16
   elseif @capture(ex, _=UInt8(_))
      ex.args[2].args[1] = :SafeUInt8
   elseif @capture(ex, _=UInt128(_))
      ex.args[2].args[1] = :SafeUInt128
   end
   return ex
end


# calls to include(f) are changed to include(T, mod, f) so that
# @changetype can apply recursively to included files.
function include(mod, filename::AbstractString)
    # use the undocumented parse_input_line function so that we preserve
    # the filename and line-number information.
    s = string("begin; ", read(filename, String), "\nend\n")
    expr = Base.parse_input_line(s, filename=filename)
    Core.eval(mod, changetype(expr))
end



for F in binaryfuncs
#    @eval $F(T, args...) = Base.$F(changetype.(T, args...)...,)
    @eval Base.$F(::Type{S}, ::Type{I}, n) where {S<:SFInt, I<:HWInt} = $F(S, n)
end

for F in randfuncs
    @eval Base.$F(::Type{S}, ::Type{I}, n) where {S<:SFInt, I<:HWInt} = $F(S, n)
end

for F in matfuncs
    @eval Base.$F(::Type{S}, ::Type{I}, n) where {S<:SFInt, I<:HWInt} = $F(S, n)
end

macro saferintegers(x)
   esc(changetype(x))
end

end # SaferIntTypes
