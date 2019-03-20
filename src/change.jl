# work with logic from ChangePrecision.jl

const HWInt = Union{Int8,Int16,Int32,Int64,Int128,UInt8,UInt16,UInt32,UInt64,UInt128}
const HWSInt = Union{Int8,Int16,Int32,Int64,Int128}
const HWUInt = Union{UInt8,UInt16,UInt32,UInt64,UInt128}

const SFInt = Union{SafeInt, SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128, SafeUInt, SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128}
const SFSInt = Union{SafeInt, SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128}
const SFUInt = Union{SafeUInt, SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128}

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

macro changetype(T, expr)
    esc(changetype(T, expr))
end

