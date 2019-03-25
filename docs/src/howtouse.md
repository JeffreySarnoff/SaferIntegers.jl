# How To Use


#### Just use safe integer types in place of the usual integer types.  The rest is well handled.

----

## To Write Code With Safe Integers

Use these exported types in place of their built-in counterparts
- `SafeInt`, `SafeInt8`, `SafeInt16`, `SafeInt32`, `SafeInt64`, `SafeInt128`
- `SafeUInt`, `SafeUInt8` `SafeUInt16`, `SafeUInt32`, `SafeUInt64`, `SafeUInt128`

----

### Almost all ops with a SafeInteger that yield an Integer will return a SafeInteger

#### one shift signature and one power signature are the exceptions

These two cases are allowed to provide more flexible overflow testing with shifts and powers.

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
