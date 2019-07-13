# Supported Operations and Functions

- `signbit`, `sign`, `abs`, `abs2`
- `count_ones`, `count_zeros`
- `leading_zeros`, `trailing_zeros`, `leading_ones`, `trailing_ones`
- `ndigits0z`
- `isless`, `isequal`, `<=`, `<`, `==`, `!=`, `>=`, `>`
- `>>>`, `>>`, `<<`, `+`, `-`, `*`, `\`, `^`
- `div`, `fld`, `fld1`, `cld`, `rem`, `mod`, `mod1`
- `divrem`, `fldmod`, `fldmod1`
- `zero`, `one`
- `typemin`, `typemax`, `widen`


## Other Conversions 

`Signed(x::SafeSigned)` returns an signed integer of the same bitwidth as x    
`Unsigned(x::SafeUnsigned)` returns an unsigned integer of the same bitwidth as x    
`Integer(x::SafeInteger)` returns an Integer of the same bitwidth and either Signed or Unsigned as is x

`SafeSigned(x::Signed)` returns a safe signed integer of the same bitwidth as x    
`SafeUnsigned(x::Unsigned)` returns a safe unsigned integer of the same bitwidth as x    
`SafeInteger(x::Integer)` returns a safe Integer of the same bitwidth and either Signed or Unsigned as is x
