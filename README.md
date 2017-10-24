## SaferIntegers

##### Jeffrey Sarnoff (2017-10-17T13:22Z in Manhattan, NY USA)

------------

#### Give them a whirl.

Just put here (thank you Tim Holy -- this is the best of copy and paste).

Seeking suggestions and some things to put in runtests.  Wholly untested.

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

