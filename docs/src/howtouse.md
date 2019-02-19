# How To Use


#### Just use safe integer types in place of the usual integer types.  The rest is well handled.

----

## To Write Code With Safe Integers

Use these exported types in place of their built-in counterparts
- `SafeInt`, `SafeInt8`, `SafeInt16`, `SafeInt32`, `SafeInt64`, `SafeInt128`
- `SafeUInt`, `SafeUInt8` `SafeUInt16`, `SafeUInt32`, `SafeUInt64`, `SafeUInt128`

#### Almost all ops with a SafeInteger that result in an integer value will return a SafeInteger

#### one shift signature and one power signature are the exceptions

- shifts (`>>>`, `>>`, `<<`) check for overflow then return the same type as that shifted
- powers (`^`) check for overflow then return the same type as that of the base powered

To check for overflow and propagate safety:
    - use a `SafeInteger` on the left hand side of a shift 
    - use a `SafeInteger` as the base number that is raised to a power
    
To check for overflow only:
- use a `SafeInteger` on the right hand side of a shift
    - and an unsafe integer on the left hand side
- use a `SafeInteger` as the power to which the base number is raised
    - and an unsafe integer as the base number

