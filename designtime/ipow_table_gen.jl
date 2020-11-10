#=
    This code is used to generate the integer power lookup tables.
    
    result of ipow(ipow_base::T, ipow_power::T) where {T}
      - either an overflow exception is generated
      - orelse the result is a positive integer of type `T`
          - result = ipow_base^ipow_power
          - result == BigInt(ipow_base)^BigInt(ipow_power)
      
    Each result is determined through exaustive search for overflow
    using Base.Int128s and DecFP.Dec128s.
    
    The results are independently validated by comparison with 
      the results obtained using a different algorithmic approach
      and computed using BigInts exclusively.
=#

import DecFP
const D128 = DecFP.Dec128

setprecision(BigFloat, ceil(Int, 3.125*log2(maxintfloat(D128))))

Base.BigFloat(x::D128) = BigFloat(string(x))
D128(x::BigFloat) = parse(D128,string(x))
# Parametric Constraints' Typwa
const ParamT = Int128
const PartsT = DecFP.Dec128

# Parametric Constraints
const ParamT = Int128
const PartsT = DecFP.Dec128

# Parametric Intervals
basemin = ParamT(2)
basemax = ParamT(128)
basetop = ParamT(1024)
powmin  = ParamT(2)
powmax  = ParamT(128)
powtop  = ParamT(1024)

# parametric domains
const allowed_bases   = collect(basemin:basemax);
const allowed_powers  = collect(powmin:powmax);
const possible_bases  = collect(basemin:basetop);
const possible_powers = collect(powmin:powtop);

