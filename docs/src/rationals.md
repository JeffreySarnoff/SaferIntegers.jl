# SaferRationals

## Construction

```julia
Rational{SafeInt32}(3, 5) === SafeInt32(3) // SafeInt32(5)

Rational(SafeInt(3), SafeInt(5)) === SafeInt(3) // SafeInt(5)
# Rational{SafeInt64}(3, 5) on 64 bit machine

a = SafeInt16(3); b = 5;
Rational(a, b)
# Rational{SafeInt16}(3, 5)
```

## Use

Use just as you would use Julia's Rationals.  These will check for overflow, though.
