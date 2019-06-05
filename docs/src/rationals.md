# SaferRationals

## Construction

```julia
SafeRational(2, 5) == SafeInt(2) // SafeInt(5)

SafeRational(SafeUInt16(2), SafeUInt16(5)) == SafeUInt16(2) // SafeUInt16(5)

SafeRational(Int16(2), Int32(5)) == SafeInt32(2) // SafeInt32(5)
```

## Use

Use just as you would use Julia's Rationals.  These will check for overflow, though.
