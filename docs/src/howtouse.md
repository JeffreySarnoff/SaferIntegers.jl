# How To Use

Just use safe integer types in place of the usual integer types.  The rest is well handled.

## To Write Code With Safe Integers

Use these exported types in place of their built-in counterparts
- `SafeInt`, `SafeInt8`, `SafeInt16`, `SafeInt32`, `SafeInt64`, `SafeInt128`
- `SafeUInt`, `SafeUInt8` `SafeUInt16`, `SafeUInt32`, `SafeUInt64`, `SafeUInt128`

## Symbols Used

- 𝒯  is an _unsafe type_
    - 𝓉  𝓉₁  𝓉₂ are values of type 𝒯
    - 𝒯ᵦ is the bitwidth of 𝒯 (32 is the bitwidth of Int32) 

- 𝒮 is a built-in signed integer type (\scrS)
    - 𝓈  𝓈₁  𝓈₂ are signed values (values of type 𝒮)

- 𝒰 is a build-in unsigned integer type (\scrU)
    - 𝓊  𝓊₁  𝓊₂ are unsigned values (values of type 𝒰)



- 𝓣  is a _safe type_
    - 𝓽  𝓽₁  𝓽₂ are values of type 𝓣
    - 𝓣ᵦ is the bitwidth of 𝓣 (64 is the bitwidth of SafeInt64) 

- 𝓢 is a safe signed integer type
    - 𝓼  𝓼₁  𝓼₂ are values of safe type 𝓢 

- 𝓤 is a safe unsigned integer type
    - 𝓾  𝓾₁  𝓾₂ are safe unsigned values (values of type 𝓤)



## Safe Shifts

It is safe to shift (`<<`, `>>`) a value of type `T` where `β = sizeof(T) * 8 (with  __SafeUnsigned__ value
- by 0 bits, in which case the result is the value unchanged
- by `bitsof(T)` bits, in which case the result is `zero(T)`
- by `-bitsof(T)` bits, in which case the result is `zero(T)`
- by ⦃1, .., `bitsof(T)-1`⦄
     - the result is strictly less than any nonzero value given
     - the result, given a zero value remains zero
- by ⦃-1, .., `-(bitsof(T)-1)`⦄
    - the result is strictly greater than any nonzero value given
    - the result, given a zero value remains zero


of type `T` by 0 bits (unchanged) or by ±β bits where β ∈ ⦃0, 1, .., `bitsof(T)`⦄.

An `OverflowError` occurs when there is an attempt to shift a value of safe type `T`
by a magnitude greater than `±bitsof(T)`.

## Notes

#### Operations with a SafeInteger that result in an integer value will return SafeIntegers
