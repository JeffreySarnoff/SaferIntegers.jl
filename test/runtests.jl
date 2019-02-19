using SaferIntegers
using Test


macro no_error(x)
    :(@test (try $x; true; catch e; false; end))
end
macro is_error(x)
    :(@test (try $x; false; catch e; true; end))
end

@testset "construct" begin
    for (S,I) in (
        (:SafeInt8, :Int8), (:SafeInt16, :Int16), (:SafeInt32, :Int32), (:SafeInt64, :Int64), (:SafeInt128, :Int128),
        (:SafeUInt8, :UInt8), (:SafeUInt16, :UInt16), (:SafeUInt32, :UInt32), (:SafeUInt64, :UInt64), (:SafeUInt128, :UInt128) )
      @eval begin
        @test safeint(::Type{$I}) === $S
        @test safeint(::Type{$S}) === $S
        @test baseint(::Type{$I}) === $I
        @test baseint(::Type{$S}) === $I
        @test safeint($I(5)) === reinterpret($S, $I(5))
        @test baseint($S(5)) === reinterpret($I, $S(5))
        @test safeint($S(5)) === $S(5)
        @test baseint($I(5)) === $I(5)
        @test $S($I(5)) === reinterpret($S, $I(5))
        @test $I($S(5)) === reinterpret($I, $S(5))
      end
    end

    @test safeint(Bool) === Bool
    @test baseint(Bool) === Bool
    @test safeint(true) === true
    @test baseint(true) === true
    
    @tesst SafeInt32(true) === true
    @test Float16(SafeInt(5)) === Float16(5)
    @test BigInt(SafeInt(5)) === BigInt(5)
    @test BigFloat(SafeInt(5)) === BigFloat(5)
end

@testset "checked" begin
    @test_throws OverflowError (+)(SafeInt8(120), SafeInt8(20))
    @test_throws OverflowError (-)(SafeUInt8(10), SafeUInt8(20))
    @test_throws OverflowError (*)(SafeInt8(100), SafeInt8(100))
end

@testset "throw" begin
    for (S,T) in ((:SafeInt8, :Int8), (:SafeInt16, :Int16), (:SafeInt32, :Int32), 
                  (:SafeInt64, :Int64), (:SafeInt128, :Int128))
       @eval begin
            @test one($S) === $S(one($T))
            @test one($T) === $T(one($S))
            @no_error( $S(typemin($T)) )
            @is_error( $S(typemax($T)) + one($T) )
            @is_error( $S(typemin($T)) - one($T) )
            @is_error( $S(typemax($T)) + one($S) )
            @is_error( $S(typemin($T)) - one($S) )
       end         
    end

    for (S,T) in ((:SafeUInt8, :UInt8), (:SafeUInt16, :UInt16), (:SafeUInt32, :UInt32), 
                  (:SafeUInt64, :UInt64), (:SafeUInt128, :UInt128))
       @eval begin
            @test one($S) === $S(one($T))        
            @test one($T) === $T(one($S))
            @no_error( $S(typemax($T)) )
            @is_error( $S(typemax($T)) + one($T) )
            @is_error( zero($S) - one($T) )
            @is_error( $S(typemax($T)) + one($S) )
            @is_error( zero($S) - one($S) )
            @test $S(5) === $S($T(5))
            @test $T(5) === $T($S(5))
       end         
    end
end

@testset "float" begin
    @test Float64(SafeInt16(22)) === Float64(22)
    @test Float32(SafeInt64(22)) === Float32(22)
end
@testset "constructors" begin
    @test SafeInt16(Int8(2)) === SafeInt16(2)
    @test Int16(SafeInt8(2)) === Int16(2)
    @test SafeUInt64(UInt8(2)) === SafeUInt64(2)
    @test UInt16(SafeUInt64(2)) === UInt16(2)
    @test SafeInt16(UInt32(2)) === SafeInt16(2)
    @test UInt32(SafeInt8(2)) === UInt32(2)
    @test SafeUInt128(Int8(2)) === SafeUInt128(2)
    @test Int16(SafeUInt128(2)) === Int16(2)
end

@testset "comparisons" begin
    @test SafeInt64(7) ==  SafeInt32(7)
    @test SafeInt32(7) !=  SafeInt32(2)
    @test SafeInt16(7) >  SafeInt32(2)
    @test SafeInt8(7)  >= SafeInt64(2) 
    @test SafeInt16(2) <  SafeInt32(7)
    @test SafeInt8(2)  <= SafeInt64(7) 
    @test isless(SafeInt16(2), SafeInt16(7))
    @test isequal(SafeInt16(2), SafeInt64(2))

    @test SafeInt64(7) ==  Int32(7)
    @test SafeInt32(7) !=  Int32(2)
    @test SafeInt16(7) >   Int32(2)
    @test SafeInt8(7)  >=  Int64(2) 
    @test SafeInt16(2) <   Int32(7)
    @test SafeInt8(2)  <=  Int64(7) 
    @test isless(SafeInt16(2), Int16(7))
    @test isequal(SafeInt16(2), Int64(2))

    @test Int64(7) ==  SafeInt32(7)
    @test Int32(7) !=  SafeInt32(2)
    @test Int16(7) >  SafeInt32(2)
    @test Int8(7)  >= SafeInt64(2) 
    @test Int16(2) <  SafeInt32(7)
    @test Int8(2)  <= SafeInt64(7) 
    @test isless(Int16(2), SafeInt16(7))
    @test isequal(Int16(2), SafeInt64(2))
end

@testset "boolean" begin
    @test ~SafeUInt32(5) === SafeUInt32(~UInt32(5))
    @test SafeInt32(7) & SafeInt32(2) === SafeInt32(7&2)
    @test SafeInt16(7) | SafeInt16(2) === SafeInt16(7|2)
    @test xor(SafeInt64(7), SafeInt64(2)) === SafeInt64(xor(7,2))

    @test SafeInt32(7) & SafeInt16(2) === SafeInt32(7&2)
    @test SafeInt32(7) | SafeInt16(2) === SafeInt32(7|2)
    @test xor(SafeInt32(7), SafeInt16(2)) === SafeInt32(xor(7,2))

    @test ~SafeUInt32(5) == ~UInt32(5)
    @test SafeInt32(7) & Int32(2) === SafeInt32(7&2)
    @test SafeInt16(7) | Int16(2) === SafeInt16(7|2)
    @test xor(SafeInt64(7), Int64(2)) === SafeInt64(xor(7,2))

    @test Int32(7) & SafeInt32(2) === SafeInt32(7&2)
    @test Int16(7) | SafeInt16(2) === SafeInt16(7|2)
    @test xor(Int64(7), SafeInt64(2)) === SafeInt64(xor(7,2))
end

@testset "arithmetic" begin
    @test SafeInt16(7) + SafeInt32(2) === SafeInt32(7+2)
    @test SafeInt8(7) - SafeInt64(2) === SafeInt64(7-2)
    @test SafeInt32(7) * SafeInt16(2) === SafeInt32(7*2)
    @test div(SafeInt32(7), SafeInt16(2)) === SafeInt32(div(7,2))
    @test rem(SafeInt32(7), SafeInt16(-2)) === SafeInt32(rem(7,-2))
    @test mod(SafeInt32(7), SafeInt16(-2)) === SafeInt32(mod(7,-2))
    @test fld(SafeInt32(7), SafeInt16(2)) === SafeInt32(fld(7,2))
    @test cld(SafeInt32(7), SafeInt16(2)) === SafeInt32(cld(7,2))

    @test SafeInt16(7) + Int32(2) === SafeInt16(7+2)
    @test SafeInt8(7) - Int64(2) === SafeInt8(7-2)
    @test SafeInt32(7) * Int16(2) === SafeInt32(7*2)
    @test div(SafeInt32(7), Int16(2)) === SafeInt32(div(7,2))
    @test rem(SafeInt32(7), Int16(-2)) === SafeInt32(rem(7,-2))
    @test mod(SafeInt32(7), Int16(-2)) === SafeInt32(mod(7,-2))
    @test fld(SafeInt32(7), Int16(2)) === SafeInt32(fld(7,2))
    @test cld(SafeInt32(7), Int16(2)) === SafeInt32(cld(7,2))

    @test Int16(7) + SafeInt32(2) === SafeInt32(7+2)
    @test Int8(7) - SafeInt64(2) === SafeInt64(7-2)
    @test Int32(7) * SafeInt16(2) === SafeInt16(7*2)
    @test div(Int32(7), SafeInt16(2)) === SafeInt16(div(7,2))
    @test rem(Int32(7), SafeInt16(-2)) === SafeInt16(rem(7,-2))
    @test mod(Int32(7), SafeInt16(-2)) === SafeInt16(mod(7,-2))
    @test fld(Int32(7), SafeInt16(2)) === SafeInt16(fld(7,2))
    @test cld(Int32(7), SafeInt16(2)) === SafeInt16(cld(7,2))

    @test Int32(521) + Int32(125) == Int32(SafeInt32(521) + SafeInt32(125))
    @test Int32(521) - Int32(125) == Int32(SafeInt32(521) - SafeInt32(125))
    @test Int32(521) * Int32(125) == Int32(SafeInt32(521) * SafeInt32(125))
    @test div(Int32(521), Int32(125)) == Int32(div(SafeInt32(521), SafeInt32(125)))

    @test SafeInt32(521) + SafeInt32(125) == SafeInt32(Int32(521) + Int32(125))
    @test SafeInt32(521) - SafeInt32(125) == SafeInt32(Int32(521) - Int32(125))
    @test SafeInt32(521) * SafeInt32(125) == SafeInt32(Int32(521) * Int32(125))
    @test div(SafeInt32(521), SafeInt32(125)) == SafeInt32(div(Int32(521), Int32(125)))

    @test Int64(521) + Int64(125) == Int64(SafeInt64(521) + SafeInt64(125))
    @test Int64(521) - Int64(125) == Int64(SafeInt64(521) - SafeInt64(125))
    @test Int64(521) * Int64(125) == Int64(SafeInt64(521) * SafeInt64(125))
    @test div(Int64(521), Int64(125)) == Int64(div(SafeInt64(521), SafeInt64(125)))

    @test SafeInt64(521) + SafeInt64(125) == SafeInt64(Int64(521) + Int64(125))
    @test SafeInt64(521) - SafeInt64(125) == SafeInt64(Int64(521) - Int64(125))
    @test SafeInt64(521) * SafeInt64(125) == SafeInt64(Int64(521) * Int64(125))
    @test div(SafeInt64(521), SafeInt64(125)) == SafeInt64(div(Int64(521), Int64(125)))

    @test Int64(73)^Int64(5) == Int64(SafeInt64(73)^SafeInt64(5))
    @test SafeInt64(73)^SafeInt64(5) == SafeInt64(Int64(73)^Int64(5))
    @test Int32(73)^Int32(5) == Int64(SafeInt32(73)^SafeInt32(5))
    @test SafeInt32(73)^SafeInt32(5) == SafeInt32(Int32(73)^Int32(5))

    @test Int32(521)+Int32(125) == Int32(SafeInt32(521) + SafeInt32(125))
    @test Int32(521)-Int32(125) == Int32(SafeInt32(521) - SafeInt32(125))
end

@testset "divide" begin
    @test (/)(SafeInt32(625), SafeInt32(125)) == (/)(Int32(625), Int32(125))
    @test (/)(SafeInt64(625), SafeInt32(125)) == (/)(Int64(625), Int32(125))
    @test (/)(SafeInt32(625), Int32(125)) == (/)(Int32(625), Int32(125))
    @test (/)(Int32(625), SafeInt32(125)) == (/)(Int32(625), Int32(125))
    @test (/)(Int64(625), Int64(125)) == Int64((/)(SafeInt64(625), SafeInt64(125)))
    @test (\)(SafeInt32(125), SafeInt32(625)) == (\)(Int32(125), Int32(625))
    @test (\)(SafeInt64(125), SafeInt32(625)) == (\)(Int64(125), Int32(625))
    @test (\)(SafeInt32(125), Int32(625)) == (\)(Int32(125), Int32(625))
    @test (\)(SafeInt32(125), Int32(625)) == (\)(Int32(125), Int32(625))
    @test (\)(Int32(125), SafeInt32(625)) == (\)(Int32(125), Int32(625))
    @test (\)(Int64(125), Int64(625)) == Int64((\)(SafeInt64(125), SafeInt64(625)))
end

@testset "number theory" begin
    @test lcm(SafeInt32(7), SafeInt16(2)) === SafeInt32(lcm(7,2))
    @test gcd(SafeInt32(7), SafeInt16(-2)) === SafeInt32(gcd(7,-2))
    @test divrem(SafeInt32(7), SafeInt16(2)) === SafeInt32.(divrem(7,2))
    @test fldmod(SafeInt32(7), SafeInt16(-2)) === SafeInt32.(fldmod(7,-2))
    @test SaferIntegers.divgcd(SafeInt32(7), SafeInt32(-2)) === SafeInt32.(Base.divgcd(7,-2))
    @test SaferIntegers.divgcd(SafeInt32(7), SafeInt16(-2)) === SafeInt32.(Base.divgcd(7,-2))

    @test lcm(SafeInt32(7), Int16(2)) === SafeInt32(lcm(7,2))
    @test gcd(SafeInt32(7), Int16(-2)) === SafeInt32(gcd(7,-2))
    @test divrem(SafeInt32(7), Int16(2)) === SafeInt32.(divrem(7,2))
    @test fldmod(SafeInt32(7), Int16(-2)) === SafeInt32.(fldmod(7,-2))
    @test SaferIntegers.divgcd(SafeInt32(7), Int16(-2)) === SafeInt32.(Base.divgcd(7,-2))

    @test lcm(Int32(7), SafeInt16(2)) === SafeInt16(lcm(7,2))
    @test gcd(Int32(7), SafeInt16(-2)) === SafeInt16(gcd(7,-2))
    @test divrem(Int32(7), SafeInt16(2)) === SafeInt16.(divrem(7,2))
    @test fldmod(Int32(7), SafeInt16(-2)) === SafeInt16.(fldmod(7,-2))
    @test SaferIntegers.divgcd(Int32(7), SafeInt16(-2)) === SafeInt16.(Base.divgcd(7,-2))
end

@testset "int ops" begin
    @test copysign(SafeInt32(1), SafeInt32(-1)) === SafeInt32(-1)
    @test copysign(SafeInt32(-1), SafeInt32(1)) === SafeInt32(1)
    @test copysign(SafeInt16(1), -1.0) === SafeInt16(-1)
    @test copysign(SafeInt16(-1), SafeInt32(1)) === SafeInt16(1)
    @test copysign(1, SafeInt16(1)) === 1
    @test copysign(1, SafeInt16(-1)) === -1
    @test copysign(SafeInt16(1), -1) === SafeInt16(-1)
    @test copysign(SafeInt16(-1), 1) === SafeInt16(1)
    @test copysign(SafeInt16(1), SafeInt32(-1)) === SafeInt16(-1)
    @test copysign(SafeInt16(-1), SafeInt32(1)) === SafeInt16(1)
    
    @test flipsign(SafeInt32(1), SafeInt32(-1)) === SafeInt32(-1)
    @test flipsign(SafeInt32(-1), SafeInt32(1)) === SafeInt32(-1)
    @test flipsign(SafeInt16(1), -1.0) === SafeInt16(-1)
    @test flipsign(SafeInt16(-1), SafeInt32(1)) === SafeInt16(-1)
    @test flipsign(1, SafeInt16(1)) === 1
    @test flipsign(1, SafeInt16(-1)) === -1
    @test flipsign(SafeInt16(1), -1) === SafeInt16(-1)
    @test flipsign(SafeInt16(-1), 1) === SafeInt16(-1)
    @test flipsign(SafeInt16(1), SafeInt32(-1)) === SafeInt16(-1)
    @test flipsign(SafeInt32(-1), SafeInt16(1)) === SafeInt32(-1)
    
    @test -SafeInt(1) === SafeInt(-1)
    
    @test abs2(SafeInt(5)) === SafeInt(25)
    @test abs2(SafeUInt(5)) === SafeUInt(25)
end

# shifts
const bitsof = SaferIntegers.bitsof

@testset "shifts" begin
    @no_error( SafeInt(typemax(Int)) << bitsof(Int) )
    @is_error( SafeInt(typemax(Int)) << (bitsof(Int)+1) )
    @no_error( SafeInt(typemax(Int)) << (-bitsof(Int)) )
    @is_error( SafeInt(typemax(Int)) << (-(bitsof(Int)+1)) )

    @no_error( SafeInt(typemax(Int)) >>> bitsof(Int) )
    @is_error( SafeInt(typemax(Int)) >>> (bitsof(Int)+1) )
    @no_error( SafeInt(typemax(Int)) >>> (-bitsof(Int)) )
    @is_error( SafeInt(typemax(Int)) >>> (-(bitsof(Int)+1)) )

    @test SafeInt32(7) >>> SafeInt32(2) === SafeInt32(7 >>> 2)
    @test SafeInt32(7) >> SafeInt32(2) === SafeInt32(7 >> 2)
    @test SafeInt32(7) << SafeInt32(2) === SafeInt32(7 << 2)

    @test SafeInt32(7) >>> SafeInt16(2) === SafeInt32(7 >>> 2)
    @test SafeInt16(7) >> SafeInt32(2) === SafeInt16(7 >> 2)
    @test SafeInt16(7) << SafeInt32(2) === SafeInt16(7 << 2)

    @test SafeInt32(7) >>> Int32(2) === SafeInt32(7 >>> 2)
    @test SafeInt32(7) >> Int32(2) === SafeInt32(7 >> 2)
    @test SafeInt32(7) << Int32(2) === SafeInt32(7 << 2)

    @test Int32(7) >>> SafeInt32(2) === Int32(7 >>> 2)
    @test Int32(7) >> SafeInt32(2) === Int32(7 >> 2)
    @test Int32(7) << SafeInt32(2) === Int32(7 << 2)
end


@testset "power" begin
    @test SafeInt32(7)^SafeInt32(5) === SafeInt32(7^5)
    @test SafeInt32(7)^5 === SafeInt32(7^5)
    @test 7^SafeInt32(5) === 7^5
    @test SafeInt32(32)^3 === SafeInt32(32^3)
end

@testset "rational" begin
    a = SafeInt32(32); b = SafeInt32(25); c = a//b - 1;

    @test typeof(SafeInt32(7) // SafeInt32(5)) === Rational{SafeInt32}
    @test typeof(c) === Rational{SafeInt32}
    @test a//b * b//a === Rational{SafeInt32}(1,1)
end

@testset "string" begin
    @test string(SafeInt16(5)) == string(Int16(5))
    @test string(SafeUInt16(5)) == string(UInt16(5))
end

    
