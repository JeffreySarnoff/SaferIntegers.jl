## SaferIntegers

#### These integer types do not ignore arithmetic overflows and underflows.

----

#### Copyright ©&thinsp;2018 by Jeffrey Sarnoff. &nbsp;&nbsp; This work is made available under The MIT License.

-----

[![Build Status](https://travis-ci.org/JeffreySarnoff/SaferIntegers.jl.svg?branch=master)](https://travis-ci.org/JeffreySarnoff/SaferIntegers.jl)

-----

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
 for i in 1:a
    secure(biohazard[i])
 end
 
 a = Int16(456) * Int16(567)
 a == -3592
 # the for loop does not execute
```

## Highlights

### Why Does This Package Exist?

- Your work may require that integer calculations be secure, well-behaved or unsurprising.

- Your clients may expect your package/app/product calculates with care and correctness.

- Your software may become part of a system on which the health or assets of others depends.

- Your prefer to publish research results that are free of error, and you work with integers.

### What Does This Package Offer?

- **SaferIntegers** lets you work more cleanly and always alerts otherwise silent problems.

- This package is designed for easy use and written to be performant in many sorts of use.

- Using **SaferIntegers** can preclude some known ways that insecure systems are breached.

----

### How Does One Use This?

Here is one way.  More detail is given later.

```julia

julia> using SaferIntegers, KahanSummation; sum_kbn = KahanSummation.sum_kbn;
julia> srand(1618);

julia> ints = [rand(Int64) for i in 1:10_000];
julia> bigints = map(BigInt, ints);
julia> safeints = map(SafeInt64, ints);

julia> ints_sum, bigints_sum = sum_kbn(ints), sum_kbn(bigints);
julia> round(Int, (ints_sum - bigints_sum) / ints_sum)
48

julia> try
           sum_kbn(safeints)
       catch
           print("\n\n\t");
           throw(OverflowError("invalid arithmetic result"))
       end
       
       ERROR: OverflowError: invalid arithmetic result
         
```


## A Basic Guide

To use safer integers within your computations, where you have been using    
explict digit sequences put them inside the safe integer constructors,    
`SafeInt(11)` or `SafeUInt(0x015A)` and similarly for the bitsize-named versions    
`SafeInt8`, `SafeInt16` .. `SafeInt128` and `SafeUInt8` .. `SafeUInt128`   

Where you had used`Int` or `UInt` now use `SafeInt` or `SafeUInt` and similarly
with the bitsize-named versions.    

SafeInt and SafeUInt give you these arithmetic operators:    
`+`, `-`, `*`, `div`, `rem`, `fld`, `mod`, `^`    
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
-- abs, (neg), (-), (+), (*), div, fld, cld, rem, mod, (^)
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

- `signbit`, `sign`, `abs`, `abs2`
- `count_ones`, `count_zeros`
- `leading_zeros`, `trailing_zeros`, `leading_ones`, `trailing_ones`
- `ndigits0z`
- `isless`, `isequal`, `<=`, `<`, `==`, `!=`, `>=`, `>`
- `>>>`, `>>`, `<<`, `+`, `-`, `*`, `\`, `^`
- `div`, `fld`, `cld`, `rem`, `mod`
- `zero`, `one`
- `typemin`, `typemax`, `widen` 

## Benchmarking (one one machine)

julia v0.7.0-alpha
```julia
julia> using SaferIntegers
julia> using BenchmarkTools
julia> BenchmarkTools.DEFAULT_PARAMETERS.time_tolerance=0.01

julia> a=17;b=27;c=37;d=47;e=57;f=67;g=77;h=87;i=97;
julia> sa=SafeInt(a);sb=SafeInt(b);sc=SafeInt(c);sd=SafeInt(d);
julia> se=SafeInt(e);sf=SafeInt(f);sg=SafeInt(g);sh=SafeInt(h);si=SafeInt(i);

julia> @btime $a+$b+$c+$d+$e+$f+$g+$h+$i
  1.968 ns (0 allocations: 0 bytes)
julia> @btime $sa+$sb+$sc+$sd+$se+$sf+$sg+$sh+$si
  3.360 ns (0 allocations: 0 bytes)
julia> 3.36/1.968
1.7

julia> @btime $a*$b*$c*$d*$e*$f*$g*$h*$i
  2.242 ns (0 allocations: 0 bytes)
julia> @btime $sa*$sb*$sc*$sd*$se*$sf*$sg*$sh*$si
  3.360 ns (0 allocations: 0 bytes)
julia> 3.36/2.242
1.5
```

### credits

This work derives from JuliaMath/RoundingIntegers.jl


