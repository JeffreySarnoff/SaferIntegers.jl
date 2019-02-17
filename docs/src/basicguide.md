# A Basic Guide


To use safer integers within your computations, where you have been using    
explict digit sequences put them inside the safe integer constructors,    
`SafeInt(11)` or `SafeUInt(0x015A)` and similarly for the bitsize-named versions    
`SafeInt8`, `SafeInt16` .. `SafeInt128` and `SafeUInt8` .. `SafeUInt128`   

Where you had used`Int` or `UInt` now use `SafeInt` or `SafeUInt` and similarly
with the bitsize-named versions.    

SafeInt and SafeUInt give you these arithmetic operators:    
`+`, `-`, `*`, `div`, `rem`, `fld`, `mod`, `^`    
which have become overflow and underflow aware.

The Int and UInt types can fail at simple arithmetic and will continue carrying the incorrectness forward.    
So, the validity of values obtained is difficult to ascertain.

Most calculations proceed without incident, 
and when used SafeInts operate as Ints
should a calculation encouter an overflow or underflow, 
    we are alerted and the calculation does not proceed.

## Give them a whirl.

> Get the package: `Pkg.add("SaferIntegers")`     
> Use the package:  `using SaferIntegers`     

- These functions check for overflow/underflow automatically:    
    - abs, (neg), (-), (+), (*), (^), div, fld, cld, rem (%), mod, divrem, fldmod
    - so does (/), before converting to Float64

## Exported Types / Constructors

- `SafeInt8`, `SafeInt16`, `SafeInt32`, `SafeInt64`, `SafeInt128`    
- `SafeUInt8`, `SafeUInt16`, `SafeUInt32`, `SafeUInt64`, `SafeUInt128`   
- `SafeSigned`, `SafeUnsigned`, `SafeInteger`

They check for overflow, even when multiplied by the usual Int and UInt types.

They do not auto-widen and are type stable. Otherwise, they are as system integers.
