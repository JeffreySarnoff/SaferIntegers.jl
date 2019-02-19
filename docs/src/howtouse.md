# How To Use


#### Just use safe integer types in place of the usual integer types.  The rest is well handled.

----

## To Write Code With Safe Integers

Use these exported types in place of their built-in counterparts
- `SafeInt`, `SafeInt8`, `SafeInt16`, `SafeInt32`, `SafeInt64`, `SafeInt128`
- `SafeUInt`, `SafeUInt8` `SafeUInt16`, `SafeUInt32`, `SafeUInt64`, `SafeUInt128`

#### Almost all ops with a SafeInteger that result in an integer value will return a SafeInteger
- shifts (`>>>`, `>>`, `<<`) check for overflow then return the same type as that shifted
- powers (`^`) check for overflow then return the same type as that of the base powered

When the intent is to propagate safety, use a `SafeInteger` on the left hand side of a shift and as the base number to a power.  When the intent is to check for overflow and propagate an unsafe integer, use an unsafe integer on the left hand side of a shift and as the base number to a power with a `SafeInteger` on the right hand side of a shift and as the power to which a base number is raised.

