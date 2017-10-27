using SaferIntegers
if VERSION < v"0.7.0-DEV.2004"
    using Base.Test
else
    using Test
end

macro catcher(x)
  quote 
    begin
        try
            $x
        catch e
            e
        end
    end
  end  
end

macro isinexact(x)
    :(InexactError() == @catcher($x))
end
macro isoverflow(x)
    :(OverflowError() == @catcher($x))
end
macro isexact(expected, expression)
    :($expected == @catcher($expression))
end

@test @inexact(SafeInt8(0x80))
@test @exact(SafeUInt8(0xFE), SafeUInt8(0x7F)+SafeUInt8(0x7F))
@test @overflow(SafeUInt8(0x7F) + SafeUInt8(0x81))
@test @overflow(SafeUInt8(0x7F) - SafeUInt8(0x81))

@test @exact(SafeInt32(typemax(SafeUInt16)), convert(SafeInt32, ~zero(SafeUInt16)))
@test @inexact(convert(SafeInt32, ~zero(SafeUInt32)))

@test SafeInt(12) == SafeUInt16(12)
@test SafeInt(-1) != ~zero(SafeUInt)

@test @exact(SafeUInt8(0xFE >> 2), (SafeUInt8(0x7F)+SafeUInt8(0x7F)) >> 2)
@test @overflow(SafeUInt8(0x7F) >> SafeUInt8(0x81))

