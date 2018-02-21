# https://github.com/stevengj/safeints.jl

# _precompile__()

"""
The `safeints` module exports a macro `@safeints T expression`
that changes the "default" floating-point precision in a given `expression`
to a new floating-point type `T`.
"""
# module safeints

## Note: code in this module must be very careful with math functions,
#        because we've defined module-specific versions of very basic
#        functions like + and *.   Call Base.:+ etcetera if needed.

using Compat

export @safeints

############################################################################
# The @safeints(T, expr) macro, below, takes calls to
# functions f that default to producing Float64 (e.g. from integer args)
# and converts them to calls to safeints.f(T, args...).  Then
# we implement our f(T, args...) to default to T instead.  The following
# are a list of function calls to transform in this way.

const randfuncs = (:rand, :randn, :randexp) # random-number generators
const matfuncs = (:ones, :zeros, :eye) # functions to construct arrays
const rangefuncs = (:linspace, :logspace) # range-like constructors
const complexfuncs = (:abs, :angle) # functions that give Float64 for Complex{Int}
const binaryfuncs = (:*, :+, :-, :^) # binary functions on irrationals that make Float64

# math functions that convert integer-like arguments to floating-point results
# (from https://docs.julialang.org/en/release-0.6/manual/mathematical-operations/, up to date as of 0.6)
const intfuncs = (:/, :\, :inv, :float,
                  # powers logs and roots
                  :√,:∛,:sqrt,:cbrt,:hypot,:exp,:exp2,:exp10,:expm1,:log,:log2,:log10,:log1p,:cis,
                  # trig
                  :sin,    :cos,    :tan,    :cot,    :sec,    :csc,
                  :sinh,   :cosh,   :tanh,   :coth,   :sech,   :csch,
                  :asin,   :acos,   :atan,   :acot,   :asec,   :acsc,
                  :asinh,  :acosh,  :atanh,  :acoth,  :asech,  :acsch,
                  :sinc,   :cosc,   :atan2,
                  :cospi,  :sinpi,
                  # trig in degrees
                  :deg2rad,:rad2deg,
                  :sind,   :cosd,   :tand,   :cotd,   :secd,   :cscd,
                  :asind,  :acosd,  :atand,  :acotd,  :asecd,  :acscd,
                  # special functions
                  :gamma,:lgamma,:lfact,:beta,:lbeta)


# functions that convert integer arrays to floating-point results
const arrayfuncs = (:mean, :std, :stdm, :var, :varm, :median, :cov, :cor, :xcorr,
                    :norm, :vecnorm, :normalize,
                    :factorize, :cholfact, :bkfact, :ldltfact, :lufact, :qrfact,
                    :lu, :chol, :qr, :lqfact, :lq,
                    :eig, :eigvals, :eigfact, :eigmax, :eigmin, :eigvecs,
                    :hessfact, :schurfact, :schur, :ordschur,
                    :svdfact, :svd, :svdvals,
                    :cond, :condskeel,
                    :det, :logdet, :logabsdet,
                    :pinv, :nullspace, :linreg,
                    :expm, :sqrtm, :logm, :lyap, :sylvester, :eigs)

# functions to change to safeints.func(T, ...) calls:
const changefuncs = Set([randfuncs..., matfuncs..., rangefuncs...,
                         intfuncs..., complexfuncs..., arrayfuncs...,
                         binaryfuncs..., :include])

############################################################################

safeints(T, x) = x
safeints(T::Type, x::Float64) = parse(T, string(x)) # change float literals
function safeints(T, x::Symbol)
    if x ∈ (:Inf, :NaN)
        return :(convert($T, $x))
    else
        return x
    end
end
function safeints(T, x::I) where {I<:Union{Int8,Int16,Int32,Int64,Int128}}
    if T === :SafeInt8
        return SafeInt8(x)
    elseif T === :SafeInt16
        return SafeInt16(x)
    elseif T === :SafeInt32
        return SafeInt32(x)
    elseif T === :SafeInt64
        return SafeInt64(x)
    elseif T === :SafeInt128
        return SafeInt128(x)
    else
        return :(parse($T, $(string(x))))
    end
end
function safeints(T, x::I) where {I<:Union{UInt8,UInt16,UInt32,UInt64,UInt128}}
    if T === :SafeUInt8
        return SafeUInt8(x)
    elseif T === :SafeUInt16
        return SafeUInt16(x)
    elseif T === :SafeUInt32
        return SafeUInt32(x)
    elseif T === :SafeUInt64
        return SafeUInt64(x)
    elseif T === :SafeUInt128
        return SafeUInt128(x)
    else
        return :(parse($T, $(string(x))))
    end
end
function safeints(T, ex::Expr)
    if Meta.isexpr(ex, :call, 3) && ex.args[1] == :^ && ex.args[3] isa Int
        # mimic Julia 0.6/0.7's lowering to literal_pow
        return Expr(:call, safeints.literal_pow, T, :^, safeints(T, ex.args[2]), Val{ex.args[3]}())
    elseif Meta.isexpr(ex, :call) && ex.args[1] in changefuncs
        return Expr(:call, eval(safeints, ex.args[1]), T, safeints.(T, ex.args[2:end])...)
    elseif Meta.isexpr(ex, :., 2) && ex.args[1] in changefuncs && Meta.isexpr(ex.args[2], :tuple)
        return Expr(:., eval(safeints, ex.args[1]), Expr(:tuple, T, safeints.(T, ex.args[2].args)...))
    else
        return Expr(ex.head, safeints.(T, ex.args)...)
    end
end

# calls to include(f) are changed to include(T, f) so that
# @safeints can apply recursively to included files.
function include(T, filename::AbstractString)
    # use the undocumented parse_input_line function so that we preserve
    # the filename and line-number information.
    s = string("begin; ", read(filename, String), "\nend\n")
    expr = Base.parse_input_line(s, filename=filename)
    eval(current_module(), safeints(T, expr))
end

"""
    @safeints T expression

Change the "default" precision in the given `expression` to the floating-point
type `T`.

This changes floating-point literals, integer expressions like `1/3`,
random-number functions like `rand`, and matrix constructors like `ones`
to default to the new type `T`.

For example,
```
@safeints Float32 begin
    x = 7.3
    y = 1/3
    z = rand() .+ ones(3,4)
end
```
uses `Float32` precision for all of the expressions in `begin ... end`.
"""
macro safeints(T, expr)
    esc(safeints(T, expr))
end

############################################################################

# integer-like types that get converted to Float64 by various functions
const HWInt = Union{Bool,Int8,Int16,Int32,Int64,Int128,UInt8,UInt16,UInt32,UInt64,UInt128}
const RatLike = Union{Rational{<:HWInt}, Complex{<:Rational{<:HWInt}}}
const IntLike = Union{HWInt, Complex{<:HWInt}}
const IntRatLike = Union{IntLike,RatLike}
const Promotable = Union{IntLike, RatLike, Irrational}
const PromotableNoRat = Union{IntLike, Irrational}

@inline tofloat(T, x) = T(x)
@inline tofloat(::Type{T}, x::Complex) where {T<:Real} = Complex{T}(x)
@inline tofloat(T, x::AbstractArray) = copy!(similar(x, T), x)
@inline tofloat(::Type{T}, x::AbstractArray{<:Complex}) where {T<:Real} = copy!(similar(x, Complex{T}), x)

###########################################################################
# safeints.f(T, args...) versions of Base.f(args...) functions.

# define our own versions of rand etc. that override the default type,
# which which still respect a type argument if it is explicitly provided
for f in randfuncs
    @eval begin
        $f(T) = Base.$f(T)
        $f(T, dims::Integer...) = Base.$f(T, dims...)
        $f(T, dims::Tuple{<:Integer}) = Base.$f(T, dims)
        $f(T, rng::AbstractRNG, dims::Integer...) = Base.$f(rng, T, dims...)
        $f(T, rng::AbstractRNG, dims::Tuple{<:Integer}) = Base.$f(rng, T, dims)
        $f(T, args...) = Base.$f(args...)
    end
end

# similarly for array constructors like ones
for f in matfuncs
    @eval begin
        $f(T) = Base.$f(T)
        $f(T, dims::Integer...) = Base.$f(T, dims...)
        $f(T, dims::Tuple{<:Integer}) = Base.$f(T, dims)
        $f(T, args...) = Base.$f(args...)
    end
end

# we want to change expressions like 1/2 to produce the new floating-point type
for f in intfuncs
    @eval begin
        $f(T, n::Promotable) = Base.$f(tofloat(T, n))
        $f(T, m::Promotable, n::Promotable) = Base.$f(tofloat(T, m), tofloat(T, n))
        $f(T, args...) = Base.$f(args...)
    end
end

# exception to intfuncs above: division on rationals produces an exact rational
inv(T, x::RatLike) = Base.inv(x)
/(T, y::IntLike, x::RatLike) = Base.:/(y, x)
\(T, x::RatLike, y::IntLike) = Base.:\(x, y)
/(T, y::RatLike, x::IntLike) = Base.:/(y, x)
\(T, x::IntLike, y::RatLike) = Base.:\(x, y)
/(T, y::RatLike, x::RatLike) = Base.:/(y, x)
\(T, x::RatLike, y::RatLike) = Base.:\(x, y)

for f in complexfuncs
    @eval begin
        $f(T, z::Union{Complex{<:HWInt},Complex{<:Rational{<:HWInt}}}) = Base.$f(tofloat(T, z))
        $f(T, args...) = Base.$f(args...)
    end
end

for f in binaryfuncs
    @eval begin
        $f(T, x::Irrational, y::Promotable) = Base.$f(tofloat(T, x), tofloat(T, y))
        $f(T, x::Promotable, y::Irrational) = Base.$f(tofloat(T, x), tofloat(T, y))
        $f(T, x::Irrational, y::Irrational) = Base.$f(tofloat(T, x), tofloat(T, y))
        $f(T, args...) = Base.$f(args...)
    end
end
-(T::Type, x::Irrational) = Base.:-(tofloat(T, x))
for f in (:+, :*) # these functions can accept 3+ arguments
    # FIXME: these methods may be slow compared to the built-in + or *
    #        because they do less inlining?
    @eval begin
        @inline $f(T, x::Promotable, y, z, args...) = $f(T, x, $f(T, y, z, args...))
        @inline $f(T, x::IntRatLike, y::IntRatLike, z::IntRatLike, args::IntRatLike...) = Base.$f(x, y, z, args...)
    end
end

^(T, x::Union{AbstractMatrix{<:Promotable},Promotable}, y::Union{RatLike,Complex{<:HWInt}}) = Base.:^(tofloat(T, x), y)

# e^x is handled specially
const esym = VERSION < v"0.7.0-DEV.1592" ? :e : :ℯ # changed in JuliaLang/julia#23427
^(T, x::Irrational{esym}, y::Promotable) = Base.exp(tofloat(T, y))
literal_pow(T, op, x::Irrational{esym}, ::Val{n}) where {n} = Base.exp(tofloat(T, n))

# literal integer powers are specially handled in Julia
if VERSION < v"0.7.0-DEV.843" # JuliaLang/julia#22475
    literal_pow(T, op, x::Irrational, ::Val{n}) where {n} = Base.literal_pow(op, tofloat(T, x), Val{n})
    @inline literal_pow(T, op, x, ::Val{n}) where {n} = Base.literal_pow(op, x, Val{n})
else
    literal_pow(T, op, x::Irrational, p) = Base.literal_pow(op, tofloat(T, x), p)
    @inline literal_pow(T, op, x, p) = Base.literal_pow(op, x, p)
end

for f in (arrayfuncs...)
    # for functions like factorize, if we are converting the matrix to floating-point
    # anyway then we might as well call factorize! instead to overwrite our temp array:
    if f ∈ (:factorize, :cholfact, :bkfact, :ldltfact, :lufact, :qrfact, :lqfact, :eigfact, :svdfact, :eigvals!, :svdvals!, :median)
        f! = Symbol(f, :!)
        @eval begin
            $f(T, x::AbstractArray{<:Promotable}, args...; kws...) = Base.$f!(tofloat(T, x), args...; kws...)
            $f(T, x::AbstractArray{<:Promotable}, y::AbstractArray{<:Promotable}, args...; kws...) = Base.$f!(tofloat(T, x), tofloat(T, y), args...; kws...)
        end
    else
        @eval begin
            $f(T, x::AbstractArray{<:Promotable}, args...; kws...) = Base.$f(tofloat(T, x), args...; kws...)
            $f(T, x::AbstractArray{<:Promotable}, y::AbstractArray{<:Promotable}, args...; kws...) = Base.$f(tofloat(T, x), tofloat(T, y), args...; kws...)
        end
    end
    @eval begin
        $f(T, x::AbstractArray{<:Promotable}, y::AbstractArray, args...; kws...) = Base.$f(x, y, args...; kws...)
        $f(T, args...; kws...) = Base.$f(args...; kws...)
    end
end
for f in (:varm, :stdm) # look at type of second (scalar) argument
    @eval begin
        $f(T, x::AbstractArray{<:Promotable}, m::Union{AbstractFloat,Complex{<:AbstractFloat}}, args...; kws...) = Base.$f(x, m, args...; kws...)
        $f(T, x::AbstractArray{<:PromotableNoRat}, m::PromotableNoRat, args...; kws...) = Base.$f(tofloat(T, x), tofloat(T, m), args...; kws...)
    end
end
inv(T, x::AbstractArray{<:PromotableNoRat}) = Base.inv(tofloat(T, x))
/(T, x::AbstractArray{<:Promotable}, y::Union{PromotableNoRat,AbstractArray{<:PromotableNoRat}}) = Base.:/(tofloat(T, x), tofloat(T, y))
\(T, y::Union{PromotableNoRat,AbstractArray{<:PromotableNoRat}}, x::AbstractArray{<:Promotable}) = Base.:\(tofloat(T, y), tofloat(T, x))

# more array functions that are exact for rationals: don't convert
for f in (:mean, :median, :var, :std, :cor, :cov, :ldltfact, :lufact)
    @eval begin
        $f(T, x::AbstractArray{<:RatLike}, y::AbstractArray{<:Promotable}, args...; kws...) = Base.$f(tofloat(T, x), tofloat(T, y), args...; kws...)
        $f(T, x::AbstractArray{<:RatLike}, y::AbstractArray{<:RatLike}, args...; kws...) = Base.$f(x, y, args...; kws...)
        $f(T, x::AbstractArray{<:RatLike}, args...; kws...) = Base.$f(x, args...; kws...)
    end
end

# linspace and logspace
linspace(T, a::PromotableNoRat, b::PromotableNoRat, args...) = Base.linspace(tofloat(T, a), tofloat(T, b), args...)
logspace(T, a::Promotable, b::Promotable, args...) = Base.logspace(tofloat(T, a), tofloat(T, b), args...)
for f in rangefuncs
    @eval $f(T, args...) = Base.$f(args...)
end

############################################################################

# end # module
