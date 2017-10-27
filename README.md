## SaferIntegers

#### Section SafeInt(1): A Safer Way 


To use safer integers within your computations, where you have been using    
explict digit sequences put them inside the safe integer constructors,    
`SafeInt(11)` or `SafeUInt(0x015A)` and similarly for the bitsize-named versions    
`SafeInt8`, `SafeInt16` .. `SafeInt128` and `SafeUInt8` .. `SafeUInt128`   

Where you had used`Int` or `UInt` now use `SafeInt` or `SafeUInt` and similarly
with the bitsize-named versions.    

SafeInt and SafeUInt give you these arithmetic operators:    
+, -, *, div, rem, fld, mod    
which have become overflow and underflow aware.

overflow aware integer calculations that just work::  virtuous causation   
less stress ⇢ better rest ⇢ social ease 
                           ⇢ new friends ⇢ less stress

Many calculations proceed without unsafe action
Some calcuations proceed avoiding unsafe acts.

Most calculations proceed safely much of the time.    
Some calculations proceed until there is an unsafe act.
Some calculations proceed unless there is an unsafe act.

^  prefer these ^

Some calcuations proceed 
Some calculations proceed, encountering an incident.

Some calculations proceed,
after an incident that   

Most calculations proceed without incident, 
and when used SafeInts operate as Ints.
Should a calculation encouter an overflow or underflow, 
    we are alerted and the calculation does proceed without reinitializaiton


The Int64 and Int32 types can fail at simple arithmetic       
and blithely continue carrying the incorrectness forward.   
The validity of values obtained cannot be ascertained.


##### Jeffrey Sarnoff (2017-10-17T13:22Z {40N47, 73W58})

#### Give them a whirl.

> Get the package: `Pkg.add("SaferIntegers")`     
> Use the package:  `using SaferIntegers`     


```julia
Pkg.add("SaferIntegers")

- These functions check for overflow/underflow automatically:    
-- abs, (neg), (-), (+), (*), div, fld, cld, rem, mod 

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

`is_safeint(::Type{T})::Bool`, `is_safeint(x)::Bool`

### credits

This work derives from JuliaMath/RoundingIntegers.jl
