# How To Use


#### Just use safe integer types in place of the usual integer types.  The rest is well handled.

----

## To Write Code With Safe Integers

Use these exported types in place of their built-in counterparts
- `SafeInt`, `SafeInt8`, `SafeInt16`, `SafeInt32`, `SafeInt64`, `SafeInt128`
- `SafeUInt`, `SafeUInt8` `SafeUInt16`, `SafeUInt32`, `SafeUInt64`, `SafeUInt128`

#### Operations with a SafeInteger that result in an integer value will return a SafeInteger
- except shifts of a system integer by a SafeInteger
     - check for overflow
     - return the same type of value as is shifted
- shifts of a SafeInteger by a system integer or SafeInteger
     - check for overflow
     - return a SafeInteger, the same type of value as is shifted
