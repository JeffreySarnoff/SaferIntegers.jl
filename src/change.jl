# work with ChangePrecision.jl

# changeprecision(T::Type, x::Float64) = x # do not change float literals

function changeprecision(T, x::I) where {I<:Union{Integer,SafeSigned,SafeUnsigned}}
    if T === :SafeInt
        return Int === Int64 ? SafeInt64(x) : SafeInt32(x)
    elseif T === :SafeInt64
        return SafeInt64(x)
    elseif T === :SafeInt32
        return SafeInt32(x)
    elseif T === :SafeInt128
        return SafeInt128(x)
    elseif T === :SafeInt16
        return SafeInt16(x)
    elseif T === :SafeInt8
        return SafeInt8(x)
    elseif T === :SafeUInt
        return Int === Int64 ? SafeUInt64(x) : SafeUInt32(x)
    elseif T === :SafeUInt64
        return SafeUInt64(x)
    elseif T === :SafeUInt32
        return SafeUInt32(x)
    elseif T === :SafeUInt128
        return SafeUInt128(x)
    elseif T === :SafeUInt16
        return SafeUInt16(x)
    elseif T === :SafeUInt8
        return SafeUInt8(x)
    else
        return x
    end
end

function changeprecision(T, ex::Expr)
    if Meta.isexpr(ex, :call, 3) && ex.args[1] == :^ && ex.args[3] isa Int
        # mimic Julia 0.6/0.7's lowering to literal_pow
        return Expr(:call, ChangePrecision.literal_pow, T, :^, changeprecision(T, ex.args[2]), Val{ex.args[3]}())
    elseif Meta.isexpr(ex, :call, 2) && ex.args[1] == :include
        return :($include($T, @__MODULE__, $(ex.args[2])))
    elseif Meta.isexpr(ex, :call) && ex.args[1] in changefuncs
        return Expr(:call, Core.eval(ChangePrecision, ex.args[1]), T, changeprecision.(T, ex.args[2:end])...)
    elseif Meta.isexpr(ex, :., 2) && ex.args[1] in changefuncs && Meta.isexpr(ex.args[2], :tuple)
        return Expr(:., Core.eval(ChangePrecision, ex.args[1]), Expr(:tuple, T, changeprecision.(T, ex.args[2].args)...))
    elseif Meta.isexpr(ex, :call, 3) && ex.args[1] == :^ && ex.args[3] isa Int
    else
        return Expr(ex.head, changeprecision.(T, ex.args)...)
    end
end
