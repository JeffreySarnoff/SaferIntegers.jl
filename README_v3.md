SaferIntegers.jl 4 version 3 exists. The exported abstract types SafeInteger, SafeSigned, SafeUnsigned are now defined as originally intended – Julia’s advancement, the active pursuit of consistant type abstractions, made it easy.

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


see (Ratios/pull/23)[https://github.com/timholy/Ratios.jl/pull/23] for details.

----

The formal distinction is in the creation of the abstract types, and so the inheritance hierarchy that pervades the concrete types.

The new way is much cleaner and makes reasoning about the shallow extension to the abstract inheritance paths much simpler. This is given in the announcement above.

The old way was a result of earlier internal limitations that Julia’s type patterning had embedded in the way Unsigned and Signed integer types had been developed (well, implemented). This forced defining these abstract types:

```
abstract type SafeInteger  <: Integer     end
abstract type SafeUnsigned <: SafeInteger end
abstract type SafeSigned   <: SafeInteger end
```

So it precluded the natural type abstraction pattern and Type logic we have now. For example, it had been the case that `!(SafeUnsigned <: Unsigned)`.

There are some additional changes.
- Several rarely encountered bugs (limited to small yet substantive subdomains)
were found by careful users and now are fixed. 
- `float(x::SafeInteger)` now works to mirror `float(x::Integer)`, for cross-package support.
- There are other implementation improvements that just work.


