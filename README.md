## SaferIntegers

##### Jeffrey Sarnoff (2017-11-07T02:39Z {40N47, 73W58})

-----

#### A Safer Way 

Using the default Int or UInt types allows overflow and underflow errors to occur silently, without notice. These incorrect values propagate and such errors are difficult to recognize after the fact.

This package exports safer versions: SafeInt8, SafeInt16, SafeInt32, SafeInt64, SafeInt128 and similarly for UInts. The safer versions check for overflow/underflow in arithmetic functions. The processing will stop with a message in the event that either exception is encountered.

#### Background

Integer overflow occurs when an integer type is increased beyond its maximum value. Integer underflow occurs when an integer type is decreased below its minimum value.  Signed and Unsigned values are subject to overflow and underflow.  With Julia, you can see the rollover using Int or UInt types:
   ```julia
   typemax(Int) + one(Int) < 0
   typemin(Int) - one(Int) > 0
   typemax(UInt) + one(UInt) == typemin(UInt)
   typemin(UInt) - one(UInt) == typemax(UInt)
   ```
There are security implications for integer overflow in certain situations.
   
#### Use

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
-- so does (/), before converting to Float64

## Exported Types and Constructors / Converters

- `SafeInt8`, `SafeInt16`, `SafeInt32`, `SafeInt64`, `SafeInt128`    
- `SafeUInt8`, `SafeUInt16`, `SafeUInt32`, `SafeUInt64`, `SafeUInt128`   
- `SafeSigned`, `SafeUnsigned`, `SafeInteger`

They check for overflow, even when multiplied by the usual Int and UInt types.    
Otherwise, they should be unsurprising.

## Other Conversions 

`Signed(x::SafeSigned)` returns an signed integer of the same bitwidth as x    
`Unsigned(x::SafeUnsigned)` returns an unsigned integer of the same bitwidth as x    
`Integer(x::SafeInteger)` returns an Integer of the same bitwidth and either Signed or Unsigned as is x

`SafeSigned(x::Signed)` returns a safe signed integer of the same bitwidth as x    
`SafeUnsigned(x::Unsigned)` returns a safe unsigned integer of the same bitwidth as x    
`SafeInteger(x::Integer)` returns a safe Integer of the same bitwidth and either Signed or Unsigned as is x

## Supports

`sign`, `signbit`, `abs`, `abs2`, `count_ones`, `leading_zeros`, `trailing_zeros`,
`leading_ones`, `trailing_ones`, `ndigits0z`,
`isless`, `isequal`, `<=`, `<`, `==`, `!=`, `>=`, `>`, `>>>`, `>>`, `<<`, `+`, `-`, `*`, `\`,
`div`, `fld`, `cld`, `rem`, `mod`, `zero`, `one`, `typemin`, `typemax`, `widen` 

### credits

This work derives from JuliaMath/RoundingIntegers.jl
