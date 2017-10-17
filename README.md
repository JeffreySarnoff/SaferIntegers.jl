, ## SaferIntegers

##### Jeffrey Sarnoff (2017-10-17T13:22Z in Manhattan, NY USA)

------------

## I am messing with it -- wait until this is not a message (a couple of hours)

------------

#### Give them a whirl.

Just put here (thank you Tim Holy -- this is the best of copy and paste).

Seeking suggestions and some things to put in runtests.  Wholly untested.

- These functions check for overflow/underflow automatically:

-- abs, (neg), (-), (+), (*), div, fld, cld, rem, mod 

## Export

SafeInt8, .. SafeInt128, SafeUInt8 .. SafeUInt128

They check for overflow, even when multiplied by the usual Int types.  Otherwise, they should be unsurprising.




