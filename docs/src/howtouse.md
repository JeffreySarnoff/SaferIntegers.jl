# How To Use

Just use safe integer types in place of the usual integer types.  The rest is well handled.

## To Write Code With Safe Integers

Use these exported types
- `SafeInt`, `SafeInt8`, `SafeInt16`, `SafeInt32`, `SafeInt64`, `SafeInt128`
- `SafeUInt`, `SafeUInt8` `SafeUInt16`, `SafeUInt32`, `SafeUInt64`, `SafeUInt128`

## To Write Code and Choose Safe or Unsafe Integers

Within your [toplevel] module

First set the environment variable "USE_SAFE_INTS"
- `ENV["USE_SAFE_INTS"] = true` to use SafeInt and SafeUInt types
- `ENV["USE_SAFE_INTS"] = false` to use the system Int and UInt types

Then use this package
- `using SaferIntegers`

And write your code using these exported types
- `AkoInt`, `AkoInt8`, `AkoInt16`, `AkoInt32`, `AkoInt64`, `AkoInt128`
- `AkoUInt`, `AkoUInt8`, `AkoUInt16`, `AkoInt32`, `AkoInt64`, `AkoInt128`

### example


```julia
module Twice

export val

ENV["USE_SAFE_INTS"] = true
using SaferIntegers

val = AkoInt(17)

end # module
```
```julia
julia> using Twice

julia> typeof(val) # on a 64bit platform
SafeInt64 
```
edit the module, replace the ENV setting with `false`
```julia
module Twice

export val

ENV["USE_SAFE_INTS"] = false
using SaferIntegers

val = AkoInt(17)

end # module
```
restart the REPL
```julia
julia> using Twice

julia> typeof(val) # on a 64bit platform
Int64 
```
