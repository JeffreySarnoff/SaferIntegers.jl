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
macro inexact(x)
    :(InexactError() == @catcher($x))
end
macro overflow(x)
    :(OverflowError() == @catcher($x))
end
macro exact(expected, expression)
    :($expected == @catcher($expression))
end

@test @inexact(SafeInt8(0x80))
@test @exact(SafeUInt8(0xFE), SafeUInt8(0x7F)+SafeUInt8(0x7F))
@test @overflow(SafeUInt8(0x7F) + SafeUInt8(0x81))
@test @overflow(SafeUInt8(0x7F) - SafeUInt8(0x81))

