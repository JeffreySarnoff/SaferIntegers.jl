# SaferIntegers
### These integer types do not ignore arithmetic overflows and underflows.

----

Copyright ©2018-2019 by Jeffrey Sarnoff. This work is made available under [The MIT License](https://opensource.org/licenses/MIT).

----

#### A Safer Way 

Using the default Int or UInt types allows overflow and underflow errors to occur silently, without notice. These incorrect values propagate and such errors are difficult to recognize after the fact.

This package exports safer versions. These types check for _overflow and underflow_ in each of the basic arithmetic functions. The processing will stop with a message in the event of _overflow or underflow_.  On one machine, the overhead relative to the built-in integer types is <= 1.2x.

#### Background

Integer overflow occurs when an integer type is increased beyond its maximum value. Integer underflow occurs when an integer type is decreased below its minimum value.  Signed and Unsigned values are subject to overflow and underflow.  With Julia, you can see the rollover using Int or UInt types:

```julia
typemax(Int) + one(Int) < 0
typemin(Int) - one(Int) > 0
typemax(UInt) + one(UInt) == typemin(UInt)
typemin(UInt) - one(UInt) == typemax(UInt)
```

There are security implications for integer overflow in certain situations.

```julia
a = Int16(456) * Int16(567)
# a == -3592

for i in 1:a
    secure(biohazard[i])
end
```
With `a < 0`, the `for` loop does not execute.
