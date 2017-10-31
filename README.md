## SaferIntegers

##### Jeffrey Sarnoff (2017-10-31T13:10Z {40N47, 73W58})

-----

#### A Safer Way 


To use safer integers within your computations, where you have been using    
explict digit sequences put them inside the safe integer constructors,    
`SafeInt(11)` or `SafeUInt(0x015A)` and similarly for the bitsize-named versions    
`SafeInt8`, `SafeInt16` .. `SafeInt128` and `SafeUInt8` .. `SafeUInt128`   

Where you had used`Int` or `UInt` now use `SafeInt` or `SafeUInt` and similarly
with the bitsize-named versions.    

SafeInt and SafeUInt give you these arithmetic operators:    
+, -, *, div, rem, fld, mod    
which have become overflow and underflow aware.

The Int and UInt types can fail at simple arithmetic        
and will continue carrying the incorrectness forward.    
The validity of values obtained is difficult to ascertain.

Most calculations proceed without incident, 
and when used SafeInts operate as Ints
should a calculation encouter an overflow or underflow, 
    we are alerted and the calculation does not proceed.

#### Give them a whirl.

> Get the package: `Pkg.add("SaferIntegers")`     
> Use the package:  `using SaferIntegers`     

- These functions check for overflow/underflow automatically:    
-- abs, (neg), (-), (+), (\*), div, fld, cld, rem, mod 

## Exported Types

- SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128    
- SafeUInt8, SafeUInt16, SafeUInt32, SafeUInt64, SafeUInt128    

They check for overflow, even when multiplied by the usual Int and UInt types.    
Otherwise, they should be unsurprising.

## Conversions 

SafeSigned(x::Signed) returns a SaferInteger (Signed) of the same bitwidth as x    
SafeSigned(x::Unsigned) returns a SaferInteger (Signed) of the same bitwidth as x    
SafeUnsigned(x::Signed) returns a SaferInteger (Unsigned) of the same bitwidth as x    
SafeUnsigned(x::Unsigned) returns a SaferInteger (Unsigned) of the same bitwidth as x    

Signed(x::SafeSigned) returns an Integer (Signed) of the same bitwidth as x    
Signed(x::SafeUnsigned) returns an Integer (Signed) of the same bitwidth as x    
Unsigned(x::SafeSigned) returns anInteger (Unsigned) of the same bitwidth as x    
Unsigned(x::SafeUnsigned) returns an Integer (Unsigned) of the same bitwidth as x    

Integer(x::SafeInteger) returns an Integer of the same bitwidth and either Signed or Unsigned as x

widen(x::SafeInteger) returns a SafeInteger of greater bitwidth and either Signed or Unsigned as x    
- widen(SafeInt128), widen(SafeUInt128) generate domain errors

## Additionally

most other ops that work with Int types

### credits

This work derives from JuliaMath/RoundingIntegers.jl
