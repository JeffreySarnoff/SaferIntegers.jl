# work with logic from ChangePrecision.jl

const HWInt = Union{Int8,Int16,Int32,Int64,Int128,UInt8,UInt16,UInt32,UInt64,UInt128}
const HWSInt = Union{Int8,Int16,Int32,Int64,Int128}
const HWUInt = Union{UInt8,UInt16,UInt32,UInt64,UInt128}

const SFInt = Union{SafeInt, SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128, SafeUInt, SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128}
const SFSInt = Union{SafeInt, SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128}
const SFUInt = Union{SafeUInt, SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128}


const randfuncs = (:rand) # random-number generators
const matfuncs = (:ones, :zeros) # functions to construct arrays
# const complexfuncs = (:abs, :angle) # functions that give Ints for Float args
const binaryfuncs = (:*, :+, :-, :^) # binary arith functions (x::I, y::I) -> I


# functions to change to ChangeType.func(T, ...) calls:
const changefuncs = Set([rand, zeros, ones, +, -, *, ^, include])

############################################################################

changetype(T, x) = x

changetype(T, x::I) where {I<:HWInt} = parse(T, string(x)) # change int literals

changetype(::Type{T}, x::I) where {T<:SFInt, I<:HWInt} = parse(T, string(x)) # change int literals

changetype(T, x::Symbol) = x

function changetype(T::Symbol, x::I) where {I<:Union{Int32, Int64}}
    if T === :SafeInt
        return Int===Int64 ? SafeInt64(x) : SafeInt32(x)
    elseif T === :SafeInt128
        return SafeInt128(x)
    elseif T === :SafeInt64
        return SafeInt64(x)
    elseif T === :SafeInt32
        return SafeInt32(x)
    elseif T === :SafeInt16
        return SafeInt16(x)
    elseif T === :SafeInt8
        return SafeInt8(x)
    elseif T === :SafeUInt
        return Int===Int64 ? SafeUInt64(x) : SafeUInt32(x)
    elseif T === :SafeUInt128
        return SafeUInt128(x)
    elseif T === :SafeUInt64
        return SafeUInt64(x)
    elseif T === :SafeUInt32
        return SafeUInt32(x)
    elseif T === :SafeUInt16
        return SafeInt16(x)
    elseif T === :SafeUInt8
        return SafeInt8(x)
    else
        return :(parse($T, $(string(x))))
    end
end

function changetype(T, ex::Expr)
    if Meta.isexpr(ex, :call, 3) && ex.args[1] == :^ && ex.args[3] isa Int
        # mimic Julia 0.6/0.7's lowering to literal_pow
        return Expr(:call, ChangeType.literal_pow, T, :^, changetype(T, ex.args[2]), Val{ex.args[3]}())
    elseif Meta.isexpr(ex, :call, 2) && ex.args[1] == :include
        return :($include($T, @__MODULE__, $(ex.args[2])))
    elseif Meta.isexpr(ex, :call) && ex.args[1] in changefuncs
        return Expr(:call, Core.eval(ChangeType, ex.args[1]), T, changetype.(T, ex.args[2:end])...)
    elseif Meta.isexpr(ex, :., 2) && ex.args[1] in changefuncs && Meta.isexpr(ex.args[2], :tuple)
        return Expr(:., Core.eval(ChangeType, ex.args[1]), Expr(:tuple, T, changetype.(T, ex.args[2].args)...))
    elseif Meta.isexpr(ex, :call, 3) && ex.args[1] == :^ && ex.args[3] isa Int
    else
        return Expr(ex.head, changetype.(T, ex.args)...)
    end
end

# calls to include(f) are changed to include(T, mod, f) so that
# @changetype can apply recursively to included files.
function include(T, mod, filename::AbstractString)
    # use the undocumented parse_input_line function so that we preserve
    # the filename and line-number information.
    s = string("begin; ", read(filename, String), "\nend\n")
    expr = Base.parse_input_line(s, filename=filename)
    Core.eval(mod, changetype(T, expr))
end

"""
    @changetype T expression

Change the "default" precision in the given `expression` to the floating-point
type `T`.

This changes floating-point literals, integer expressions like `1/3`,
random-number functions like `rand`, and matrix constructors like `ones`
to default to the new type `T`.

For example,
```
@changetype Float32 begin
    x = 7.3
    y = 1/3
    z = rand() .+ ones(3,4)
end
```
uses `Float32` precision for all of the expressions in `begin ... end`.
"""
macro changetype(T, expr)
    esc(changetype(T, expr))
end

changetype(::Type{T}, x, f::AbstractFloat) where {T<:SFInt} = f
for f in binaryfuncs
    @eval $f(T, args...) = Base.$f(changetype.(T, args...)...,)
end

for F in randfuncs
    @eval Base.$F(::Type{S}, ::Type{I}, n) where {S<:SFInt, I<:HWInt} = $F(S, n)
end
for F in matfuncs
    @eval Base.$F(::Type{S}, ::Type{I}, n) where {S<:SFInt, I<:HWInt} = $F(S, n)
end

macro safetypes(expr)
    esc(safetypes(expr))
end
