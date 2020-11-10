#=
    This code is used to generate the integer power lookup tables.
    
    result of `ipow(ipow\_base::T, ipow\_power::T) where {T}`
      - either an overflow exception is generated
      - orelse the result is a positive integer of type `T`
          - `result = ipow\_base^ipow\_power`
          - `result == BigInt(ipow\_base)^BigInt(ipow\_power)`
      
    Each result is determined through exaustive search for overflow
    using `Int128s` and `DecFP.Dec128s`.
    
    The results are independently validated by comparison with 
      the results obtained using a different algorithmic approach
      and computed using BigInts exclusively.
=#

impoer DecFP

# Parametric Constraints' Typwa
const ParamT = Int128
const PartsT = DecFP.Dec128

# Parametric Constraints
const ParamT = Int128
const PartsT = DecFP.Dec128

# Parametric Intervals
basemin = ParamT(2)
basemax  = ParamT(128)
basetop   = ParamT(1024)
powmin   = ParamT(2)
powmax   = ParamT(128)
powtop    = ParamT(1024)

# parametric domains
const allowed_bases   = collect(basemin:basemax)
const allowed_powers  = collect(powmin:powmax)
const possible_bases  = collect(basemin:basetop)
const possible_powers = collect(powmin:powtop)
