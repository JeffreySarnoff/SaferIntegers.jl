# How To Use

Just use safe integer types in place of the usual integer types.  The rest is well handled.

## To Write Code With Safe Integers

Use these exported types
- `SafeInt`, `SafeInt8`, `SafeInt16`, `SafeInt32`, `SafeInt64`, `SafeInt128`
- `SafeUInt`, `SafeUInt8` `SafeUInt16`, `SafeUInt32`, `SafeUInt64`, `SafeUInt128`
<!--
## To Write Code and Choose Safe or Unsafe Integers

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

export twice, val

using SaferIntegers

val = AkoInt(17)

function twice(x::AkoInt)
    return 2 * x
end

end # module
```
```julia
julia> ENV["USE_SAFE_INTS"] = true # develop & test
julia> using SaferIntegers
julia> using Twice

julia> result = twice(val)
34
julia> typeof(result) # on a 64bit platform
SafeInt64 
```
restart the REPL
```julia
julia> ENV["USE_SAFE_INTS"] = false # release
julia> using SaferIntegers
julia> using Twice

julia> result = twice(val)
34
julia> typeof(result) # on a 64bit platform
Int64 
```
-->
