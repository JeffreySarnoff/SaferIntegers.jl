#=
    This code is used to generate the integer power lookup tables.
    
    result of `ipow(ipow_base::T, ipow_power::T) where {T}`
      - either an overflow exception is generated
      - orelse the result is a positive integer of type `T`
          - `result = ipow_base^ipow_power`
          - `result == BigInt(ipow_base)^BigInt(ipow_power)`
      
    Each result is determined through exaustive search for overflow
    using `Int128s` and `DecFP.Dec128s`.
    
    The results are independently validated by comparison with 
      the results obtained using a different algorithmic approach
      and computed using BigInts exclusively.
=#

# Parametric Constraints
const ParamT = Int128
basemin  = ParamT(2)
basemax  = ParamT(128)
basemax2 = ParamT(256)
powmin   = ParamT(2)
powmax   = ParamT(128)
powmax2  = ParamT(256)
