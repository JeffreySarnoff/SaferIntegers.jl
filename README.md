# SaferIntegers
### These integer types do not ignore arithmetic overflows.

----

#### Copyright ©&thinsp;2018-2023 by Jeffrey Sarnoff. &nbsp;&nbsp; This work is made available under [The MIT License](https://opensource.org/licenses/MIT).

-----

[![Docs](https://img.shields.io/badge/docs-stable-blue.svg)](http://jeffreysarnoff.github.io/SaferIntegers.jl/dev/) [![Docs](https://img.shields.io/badge/docs-dev-blue.svg)](http://jeffreysarnoff.github.io/SaferIntegers.jl/dev/) [![Test Coverage](https://codecov.io/github/JeffreySarnoff/SaferIntegers.jl/coverage.svg?branch=main)](https://codecov.io/github/JeffreySarnoff/SaferIntegers.jl?branch=main) [![Package Downloads](https://shields.io/endpoint?url=https://pkgs.genieframework.com/api/v1/badge/SaferIntegers)](https://pkgs.genieframework.com?packages=SaferIntegers&startdate=2010-01-01&enddate=2040-12-31) [![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT) 

-----

#### A Safer Way 

Using the default Int or UInt types allows overflow errors to occur silently, without notice. These incorrect values propagate and such errors are difficult to recognize after the fact.

This package exports safer versions. These types check for overflow in each of the basic arithmetic functions. The processing will stop with a message in the event of overflow.  On one machine, the overhead relative to the built-in integer types is <= 1.2x.

#### Background

Integer overflow occurs when an integer type is increased beyond its maximum value or below its minimum value. Signed and Unsigned values are subject to overflow.  With Julia, you can see the rollover using Int or UInt types:
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

- _SaferIntegers_ let you work more cleanly and always alerts otherwise silent problems.

- This package is designed for easy use and written to be performant in many sorts of use.

- All exported types are stable (e.g. `typeof(SafeInt32(1) + 1) == SafeInt32`)

- Using _SaferIntegers_ can preclude some known ways that insecure systems are breached.

### Test code for integer safety

- `@saferintegers include(joinpath("PackageTestDirectory", "PackageTests.jl"))`
    - includes a type modified `PackageTests.jl` in the current environment
    - all `Integer` types in `PackageTests.jl` are become `SafeInteger` types
    - run it and see if there are any problems!


----

## A Basic Guide

To use safer integers within your computations, where you have been using    
explict digit sequences put them inside the safe integer constructors,    
`SafeInt(11)` or `SafeUInt(0x015A)` and similarly for the bitsize-named versions    
`SafeInt8`, `SafeInt16` .. `SafeInt128` and `SafeUInt8` .. `SafeUInt128`   

Where you had used`Int` or `UInt` now use `SafeInt` or `SafeUInt` and similarly
with the bitsize-named versions.    

SafeInt and SafeUInt give you these arithmetic operators:    
`+`, `-`, `*`, `div`, `rem`, `fld`, `mod`, `fld1`, `mod1`, `^`   
which have become overflow aware.

The Int and UInt types can fail at simple arithmetic        
and will continue carrying the incorrectness forward.    
The validity of values obtained is difficult to ascertain.

Most calculations proceed without incident, 
and when used SafeInts operate as Ints
should a calculation encouter an overflow, 
    we are alerted and the calculation does not proceed.

#### Give them a whirl.

> Get the package: `Pkg.add("SaferIntegers")`     
> Use the package:  `using SaferIntegers`     

- These functions check for overflow automatically:    
    - `abs`, `neg`, `div`, `fld`, `fld1`, `cld`, `rem`, `mod`, `mod1`
    - `divrem`, `fldmod`, `fldmod1`
    - `-`, `+`, `*`, `^`

## Exported Types and Constructors / Converters

- `SafeInt8`, `SafeInt16`, `SafeInt32`, `SafeInt64`, `SafeInt128`    
- `SafeUInt8`, `SafeUInt16`, `SafeUInt32`, `SafeUInt64`, `SafeUInt128`   
- `SafeSigned`, `SafeUnsigned`, `SafeInteger`
- `SafeRational`

They check for overflow, even when multiplied by the usual Int and UInt types.    
Otherwise, they should be unsurprising.

### Type definitions

```
abstract type SafeUnsigned <: Unsigned end
abstract type SafeSigned <: Signed end
const SafeInteger = Union{SafeUnsigned, SafeSigned}
```

(thanks to Mark Kittisopikul's PR and TimHoly's design of Ratios.jl)

## Other Conversions 

`Signed(x::SafeSigned)` returns an signed built-in integer of the same bitwidth as x    
`Unsigned(x::SafeUnsigned)` returns an unsigned built-in integer of the same bitwidth as x    
`Integer(x::SafeInteger)` returns a built-in integer of the same bitwidth and either Signed or Unsigned as is x

`SafeSigned(x::Signed)` returns a safe signed integer of the same bitwidth as x    
`SafeUnsigned(x::Unsigned)` returns a safe unsigned integer of the same bitwidth as x    
`SafeInteger(x::Integer)` returns a safe Integer of the same bitwidth and is either Signed or Unsigned as matches x

## Supports

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

## Test code for integer safety

### test snippets
```julia

julia> @saferintegers begin
         x = 64
         y = Int16(16)
         z = x + y + SafeInt128(x)
         x, y, z
         end
(64, 16, 144)

julia> typeof.(ans)
(SafeInt64, SafeInt16, SafeInt128)
```

### test source file
```julia
julia> cd(<source file directory>)
julia> @saferintegers include(<filename.jl>)
```

## Benchmarking (on one machine)

julia v1.1-dev
```julia
using SaferIntegers
using BenchmarkTools
BenchmarkTools.DEFAULT_PARAMETERS.time_tolerance=0.005

@noinline function test(n, f, a,b,c,d)
   result = a;
   i = 0
   while true
       i += 1
       i > n && break       
       result += f(d,c)+f(b,a)+f(d,b)+f(c,a)
   end
   return result
end

hundredths(x) = round(x, digits=2)

a = 17; b = 721; c = 75; d = 567;
sa, sb, sc, sd = SafeInt.((a, b, c, d));
n = 10_000;

hundredths( (@belapsed test(n, +, $sa, $sb, $sc, $sd)) /
            (@belapsed test(n, +, $a, $b, $c, $d))        )
1.25

hundredths( (@belapsed test(n, *, $sa, $sb, $sc, $sd)) /
            (@belapsed test(n, *, $a, $b, $c, $d))        )
1.25

hundredths( (@belapsed test(n, div, $sa, $sb, $sc, $sd)) /
            (@belapsed test(n, div, $a, $b, $c, $d))      )
1.14
```

### technical notes about code updated a while ago

The exported abstract types SafeInteger, SafeSigned, SafeUnsigned are now defined as originally intended.
Julia’s advancement, the active pursuit of consistant type abstractions, made it easy.

```
SafeUnsigned  <:  Unsigned
SafeSigned    <:  Signed
SafeInteger   <:  Integer
```

This clean approach holds through the exported concrete types.

```
SafeUInt <: SafeUnsigned <: Unsigned <: Integer <: Real
SafeInt  <: SafeSigned   <: Signed   <: Integer <: Real
```

A good deal of benchmarking was done to evaluate the appropriateness of using SaferIntegers with Ratios.jl.to protect calculations within Interpolations.jl from Integer overflow in innocent looking linear interpolation without warning. The results are compelling, encouraging their wider application.

Using SafeInt64s with Ratios requires 1.025 the time used with Int64 Ratios.
This is merely an extra 1.5 seconds per minute.

see [Ratios/pull/23](https://github.com/timholy/Ratios.jl/pull/23) for details.

----

The formal distinction is in the creation of the abstract types, and so the inheritance hierarchy that pervades the concrete types.

The new way is much cleaner and makes reasoning about the shallow extension to the abstract inheritance paths much simpler. This is given in the announcement above. The old way was a result of earlier internal limitations that Julia’s type patterning had embedded in the way Unsigned and Signed integer types had been developed (well, implemented). This forced defining these abstract types:

```
abstract type SafeInteger  <: Integer     end
abstract type SafeSigned   <: SafeInteger end
```

So it precluded the natural pattern of type abstraction and well-formed instantiation logic we have now.
- it had been the case that `!(SafeUnsigned <: Unsigned)`.

There are some additional changes.
- Several bugs (limited to small yet substantive subdomains) were found by careful users and are fixed. 
- `float(x::SafeInteger)` now works to mirror `float(x::Integer)`, for cross-package support.
- There are other implementation improvements that just work.


### credits

This work derives from [RoundingIntegers.jl](https://github.com/JuliaMath/RoundingIntegers.jl).

The @saferintegers macro machinery is heavily informed by [ChangePrecision.jl](https://github.com/stevengj/ChangePrecision.jl).


