using SaferIntegers
using Test

baseint = SaferIntegers.baseint
safeint = SaferIntegers.safeint

macro no_error(x)
    :(@test (try $x; true; catch e; false; end))
end
macro is_error(x)
    :(@test (try $x; false; catch e; true; end))
end

@testset "construct0" begin
    for T in (:Int8, :Int16, :Int32, :Int64, :Int128, :UInt8, :UInt16, :UInt32, :UInt64, :UInt128)
      @eval begin
        @test $T(BigInt(2)) == $T(2)
      end
    end
end

@testset "construct1" begin
    for (S,I) in (
        (:SafeInt8, :Int8), (:SafeInt16, :Int16), (:SafeInt32, :Int32), (:SafeInt64, :Int64), (:SafeInt128, :Int128),
        (:SafeUInt8, :UInt8), (:SafeUInt16, :UInt16), (:SafeUInt32, :UInt32), (:SafeUInt64, :UInt64), (:SafeUInt128, :UInt128) )
      @eval begin
        @test safeint($I) === $S
        @test safeint($S) === $S
        @test baseint($I) === $I
        @test baseint($S) === $I
        @test safeint($I(5)) === reinterpret($S, $I(5))
        @test baseint($S(5)) === reinterpret($I, $S(5))
        @test safeint($S(5)) === $S(5)
        @test baseint($I(5)) === $I(5)
        @test $S($I(5)) === reinterpret($S, $I(5))
        @test $I($S(5)) === reinterpret($I, $S(5))
      end
    end
end

@testset "construct2" begin
    @test safeint(Bool) === Bool
    @test baseint(Bool) === Bool
    @test safeint(true) === true
    @test baseint(true) === true
    
    @test Float16(SafeInt(5)) === Float16(5)
    @test BigInt(SafeInt(5)) == BigInt(5)
    @test BigFloat(SafeInt(5)) == BigFloat(5)
end

@testset "construct3" begin
    @test SafeInt128(Float16(5)) === SafeInt128(5)
    @test SafeInt128(Float32(5)) === SafeInt128(5)
    @test SafeInt128(Float64(5)) === SafeInt128(5)
    @test SafeInt64(Float16(5)) === SafeInt64(5)
    @test SafeInt64(Float32(5)) === SafeInt64(5)
    @test SafeInt64(Float64(5)) === SafeInt64(5)
    @test SafeInt32(Float16(5)) === SafeInt32(5)
    @test SafeInt32(Float32(5)) === SafeInt32(5)
    @test SafeInt32(Float64(5)) === SafeInt32(5)
    @test SafeInt16(Float16(5)) === SafeInt16(5)
    @test SafeInt16(Float32(5)) === SafeInt16(5)
    @test SafeInt16(Float64(5)) === SafeInt16(5)
    @test SafeInt8(Float16(5)) === SafeInt8(5)
    @test SafeInt8(Float32(5)) === SafeInt8(5)
    @test SafeInt8(Float64(5)) === SafeInt8(5)

    @test SafeUInt128(Float16(5)) === SafeUInt128(5)
    @test SafeUInt128(Float32(5)) === SafeUInt128(5)
    @test SafeUInt128(Float64(5)) === SafeUInt128(5)
    @test SafeUInt64(Float16(5)) === SafeUInt64(5)
    @test SafeUInt64(Float32(5)) === SafeUInt64(5)
    @test SafeUInt64(Float64(5)) === SafeUInt64(5)
    @test SafeUInt32(Float16(5)) === SafeUInt32(5)
    @test SafeUInt32(Float32(5)) === SafeUInt32(5)
    @test SafeUInt32(Float64(5)) === SafeUInt32(5)
    @test SafeUInt16(Float16(5)) === SafeUInt16(5)
    @test SafeUInt16(Float32(5)) === SafeUInt16(5)
    @test SafeUInt16(Float64(5)) === SafeUInt16(5)
    @test SafeUInt8(Float16(5)) === SafeUInt8(5)
    @test SafeUInt8(Float32(5)) === SafeUInt8(5)
    @test SafeUInt8(Float64(5)) === SafeUInt8(5)
end

@testset "construct 4" begin
    @test SafeInt8(typemax(SafeInt8)) == typemax(SafeInt8)
    @test SafeInt16(typemax(SafeInt16)) == typemax(SafeInt16)
    @test SafeInt32(typemax(SafeInt32)) == typemax(SafeInt32)
    @test SafeInt64(typemax(SafeInt64)) == typemax(SafeInt64)
    @test SafeInt128(typemax(SafeInt128)) == typemax(SafeInt128)
    @test SafeUInt8(typemax(SafeUInt8)) == typemax(SafeUInt8)
    @test SafeUInt16(typemax(SafeUInt16)) == typemax(SafeUInt16)
    @test SafeUInt32(typemax(SafeUInt32)) == typemax(SafeUInt32)
    @test SafeUInt64(typemax(SafeUInt64)) == typemax(SafeUInt64)
    @test SafeUInt128(typemax(SafeUInt128)) == typemax(SafeUInt128)
end

@testset "checked signed" begin
    @test_throws OverflowError (+)(SafeInt8(120), SafeInt8(20))
    @test_throws OverflowError (-)(SafeInt8(-120), SafeInt8(20))
    @test_throws OverflowError (*)(SafeInt8(100), SafeInt8(100))
    @test div(SafeInt16(100), SafeInt16(20)) === SafeInt16(div(100, 20))
    @test fld(SafeInt16(100), SafeInt16(15)) === SafeInt16(fld(100, 15))
    @test fld1(SafeInt16(100), SafeInt16(15)) === SafeInt16(fld1(100, 15))
    @test cld(SafeInt16(100), SafeInt16(15)) === SafeInt16(cld(100, 15))
    @test mod(SafeInt16(100), SafeInt16(15)) === SafeInt16(mod(100, 15))
    @test mod1(SafeInt16(100), SafeInt16(15)) === SafeInt16(mod1(100, 15))
    @test rem(SafeInt16(100), SafeInt16(15)) === SafeInt16(rem(100, 15))
    
    @test_throws OverflowError (+)(typemax(SafeInt16), SafeInt8(20))
    @test_throws OverflowError (-)(typemin(SafeInt16), SafeInt8(20))
    @test_throws OverflowError (*)(typemax(SafeInt16), SafeInt8(100))
    @test div(SafeInt16(100), SafeInt64(20)) === SafeInt64(div(100, 20))
    @test fld(SafeInt16(100), SafeInt32(15)) === SafeInt32(fld(100, 15))
    @test fld1(SafeInt16(100), SafeInt32(15)) === SafeInt32(fld1(100, 15))
    @test cld(SafeInt16(100), SafeInt32(15)) === SafeInt32(cld(100, 15))
    @test mod(SafeInt16(100), SafeInt32(15)) === SafeInt32(mod(100, 15))
    @test mod1(SafeInt16(100), SafeInt32(15)) === SafeInt32(mod1(100, 15))
    @test rem(SafeInt16(100), SafeInt32(15)) === SafeInt32(rem(100, 15))
end

@testset "checked unsigned" begin
    @test_throws OverflowError (+)(SafeUInt8(250), SafeUInt8(20))
    @test_throws OverflowError (-)(SafeUInt8(10), SafeUInt8(20))
    @test_throws OverflowError (*)(SafeUInt8(100), SafeUInt8(100))
    @test div(SafeUInt16(100), SafeUInt16(20)) === SafeUInt16(div(UInt16(100), UInt16(20)))
    @test fld(SafeUInt16(100), SafeUInt16(15)) === SafeUInt16(fld(UInt16(100), UInt16(15)))
    @test fld1(SafeUInt16(100), SafeUInt16(15)) === SafeUInt16(fld1(UInt16(100), UInt16(15)))
    @test cld(SafeUInt16(100), SafeUInt16(15)) === SafeUInt16(cld(UInt16(100), UInt16(15)))
    @test mod(SafeUInt16(100), SafeUInt16(15)) === SafeUInt16(mod(UInt16(100), UInt16(15)))
    @test mod1(SafeUInt16(100), SafeUInt16(15)) === SafeUInt16(mod1(UInt16(100), UInt16(15)))
    @test rem(SafeUInt16(100), SafeUInt16(15)) === SafeUInt16(rem(UInt16(100), UInt16(15)))

    @test_throws OverflowError (+)(SafeUInt8(10), typemax(SafeUInt16))
    @test_throws OverflowError (-)(SafeUInt8(10), typemax(SafeUInt16))
    @test_throws OverflowError (*)(SafeUInt8(100), typemax(SafeUInt16))
    @test div(SafeUInt32(100), SafeUInt16(20)) === SafeUInt32(div(UInt16(100), UInt16(20)))
    @test fld(SafeUInt32(100), SafeUInt16(15)) === SafeUInt32(fld(UInt16(100), UInt16(15)))
    @test fld1(SafeUInt32(100), SafeUInt16(15)) === SafeUInt32(fld1(UInt16(100), UInt16(15)))
    @test cld(SafeUInt32(100), SafeUInt16(15)) === SafeUInt32(cld(UInt16(100), UInt16(15)))
    @test mod(SafeUInt32(100), SafeUInt16(15)) === SafeUInt32(mod(UInt16(100), UInt16(15)))
    @test mod1(SafeUInt32(100), SafeUInt16(15)) === SafeUInt32(mod1(UInt16(100), UInt16(15)))
    @test rem(SafeUInt32(100), SafeUInt16(15)) === SafeUInt32(rem(UInt16(100), UInt16(15)))
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

@testset "-unsigned" begin
    @is_error( -SafeUInt(0) )
    @is_error( -SafeUInt8(1) )
    @is_error( -SafeUInt16(1) )
    @is_error( -SafeUInt32(1) )
    @is_error( -SafeUInt64(1) )
    @is_error( -SafeUInt128(1) )
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
    @test mod1(SafeInt32(7), SafeInt16(-2)) === SafeInt32(mod1(7,-2))
    @test fld1(SafeInt32(7), SafeInt16(2)) === SafeInt32(fld1(7,2))
    @test cld(SafeInt32(7), SafeInt16(2)) === SafeInt32(cld(7,2))

    @test SafeInt16(7) + Int32(2) === SafeInt16(7+2)
    @test SafeInt8(7) - Int64(2) === SafeInt8(7-2)
    @test SafeInt32(7) * Int16(2) === SafeInt32(7*2)
    @test div(SafeInt32(7), Int16(2)) === SafeInt32(div(7,2))
    @test rem(SafeInt32(7), Int16(-2)) === SafeInt32(rem(7,-2))
    @test mod(SafeInt32(7), Int16(-2)) === SafeInt32(mod(7,-2))
    @test fld(SafeInt32(7), Int16(2)) === SafeInt32(fld(7,2))
    @test mod1(SafeInt32(7), Int16(-2)) === SafeInt32(mod1(7,-2))
    @test fld1(SafeInt32(7), Int16(2)) === SafeInt32(fld1(7,2))
    @test cld(SafeInt32(7), Int16(2)) === SafeInt32(cld(7,2))

    @test Int16(7) + SafeInt32(2) === SafeInt32(7+2)
    @test Int8(7) - SafeInt64(2) === SafeInt64(7-2)
    @test Int32(7) * SafeInt16(2) === SafeInt16(7*2)
    @test div(Int32(7), SafeInt16(2)) === SafeInt16(div(7,2))
    @test rem(Int32(7), SafeInt16(-2)) === SafeInt16(rem(7,-2))
    @test mod(Int32(7), SafeInt16(-2)) === SafeInt16(mod(7,-2))
    @test fld(Int32(7), SafeInt16(2)) === SafeInt16(fld(7,2))
    @test mod1(Int32(7), SafeInt16(-2)) === SafeInt16(mod1(7,-2))
    @test fld1(Int32(7), SafeInt16(2)) === SafeInt16(fld1(7,2))
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

@testset "checked signed arithmetic" begin
    @test SaferIntegers.checked_neg(SafeInt16(7)) === SafeInt16(-7)
    @test SaferIntegers.checked_abs(SafeInt16(-7)) === SafeInt16(7)

    @test SaferIntegers.checked_add(SafeInt32(7), SafeInt32(2)) === SafeInt32(7+2)
    @test SaferIntegers.checked_sub(SafeInt64(7), SafeInt64(2)) === SafeInt64(7-2)
    @test SaferIntegers.checked_mul(SafeInt32(7), SafeInt32(2)) === SafeInt32(7*2)
    @test SaferIntegers.checked_div(SafeInt32(7), SafeInt32(2)) === SafeInt32(div(7,2))
    @test SaferIntegers.checked_rem(SafeInt32(7), SafeInt32(-2)) === SafeInt32(rem(7,-2))
    @test SaferIntegers.checked_mod(SafeInt32(7), SafeInt32(-2)) === SafeInt32(mod(7,-2))
    @test SaferIntegers.checked_fld(SafeInt16(7), SafeInt16(2)) === SafeInt16(fld(7,2))
    @test SaferIntegers.checked_cld(SafeInt32(7), SafeInt32(2)) === SafeInt32(cld(7,2))

    @test SaferIntegers.checked_add(SafeInt16(7), SafeInt32(2)) === SafeInt32(7+2)
    @test SaferIntegers.checked_sub(SafeInt8(7), SafeInt64(2)) === SafeInt64(7-2)
    @test SaferIntegers.checked_mul(SafeInt32(7), SafeInt16(2)) === SafeInt32(7*2)
    @test SaferIntegers.checked_div(SafeInt32(7), SafeInt16(2)) === SafeInt32(div(7,2))
    @test SaferIntegers.checked_rem(SafeInt32(7), SafeInt16(-2)) === SafeInt32(rem(7,-2))
    @test SaferIntegers.checked_mod(SafeInt32(7), SafeInt16(-2)) === SafeInt32(mod(7,-2))
    @test SaferIntegers.checked_fld(SafeInt32(7), SafeInt16(2)) === SafeInt32(fld(7,2))
    @test SaferIntegers.checked_cld(SafeInt32(7), SafeInt16(2)) === SafeInt32(cld(7,2))
    
    @test SaferIntegers.add_with_overflow(SafeInt32(7), SafeInt32(2))[2] === false
    @test SaferIntegers.sub_with_overflow(SafeInt32(7), SafeInt32(2))[2] === false
    @test SaferIntegers.mul_with_overflow(SafeInt32(7), SafeInt32(2))[2] === false
    
    @test SaferIntegers.add_with_overflow(SafeInt32(7), SafeInt16(2))[2] === false
    @test SaferIntegers.sub_with_overflow(SafeInt32(7), SafeInt16(2))[2] === false
    @test SaferIntegers.mul_with_overflow(SafeInt32(7), SafeInt16(2))[2] === false
end

@testset "checked unsigned arithmetic" begin
    @test SaferIntegers.checked_add(SafeUInt32(7), SafeUInt32(2)) === SafeUInt32(7+2)
    @test SaferIntegers.checked_sub(SafeUInt64(7), SafeUInt64(2)) === SafeUInt64(7-2)
    @test SaferIntegers.checked_mul(SafeUInt32(7), SafeUInt32(2)) === SafeUInt32(7*2)
    @test SaferIntegers.checked_div(SafeUInt32(7), SafeUInt32(2)) === SafeUInt32(div(7,2))
    @test SaferIntegers.checked_rem(SafeUInt32(7), SafeUInt32(2)) === SafeUInt32(rem(7,2))
    @test SaferIntegers.checked_mod(SafeUInt32(7), SafeUInt32(2)) === SafeUInt32(mod(7,2))
    @test SaferIntegers.checked_fld(SafeUInt16(7), SafeUInt16(2)) === SafeUInt16(fld(7,2))
    @test SaferIntegers.checked_cld(SafeUInt32(7), SafeUInt32(2)) === SafeUInt32(cld(7,2))

    @test SaferIntegers.checked_add(SafeUInt16(7), SafeUInt32(2)) === SafeUInt32(7+2)
    @test SaferIntegers.checked_sub(SafeUInt8(7), SafeUInt64(2)) === SafeUInt64(7-2)
    @test SaferIntegers.checked_mul(SafeUInt32(7), SafeUInt16(2)) === SafeUInt32(7*2)
    @test SaferIntegers.checked_div(SafeUInt32(7), SafeUInt16(2)) === SafeUInt32(div(7,2))
    @test SaferIntegers.checked_rem(SafeUInt32(7), SafeUInt16(2)) === SafeUInt32(rem(7,2))
    @test SaferIntegers.checked_mod(SafeUInt32(7), SafeUInt16(2)) === SafeUInt32(mod(7,2))
    @test SaferIntegers.checked_fld(SafeUInt32(7), SafeUInt16(2)) === SafeUInt32(fld(7,2))
    @test SaferIntegers.checked_cld(SafeUInt32(7), SafeUInt16(2)) === SafeUInt32(cld(7,2))
    
    @test SaferIntegers.add_with_overflow(SafeUInt32(7), SafeUInt32(2))[2] === false
    @test SaferIntegers.sub_with_overflow(SafeUInt32(7), SafeUInt32(2))[2] === false
    @test SaferIntegers.mul_with_overflow(SafeUInt32(7), SafeUInt32(2))[2] === false
    
    @test SaferIntegers.add_with_overflow(SafeUInt32(7), SafeUInt16(2))[2] === false
    @test SaferIntegers.sub_with_overflow(SafeUInt32(7), SafeUInt16(2))[2] === false
    @test SaferIntegers.mul_with_overflow(SafeUInt32(7), SafeUInt16(2))[2] === false   
end

@testset "checked mixed arithmetic" begin
    @test SaferIntegers.checked_add(SafeInt32(7), SafeUInt32(2)) === SafeUInt32(7+2)
    @test SaferIntegers.checked_sub(SafeInt64(7), SafeUInt64(2)) === SafeUInt64(7-2)
    @test SaferIntegers.checked_mul(SafeInt32(7), SafeUInt32(2)) === SafeUInt32(7*2)
    @test SaferIntegers.checked_div(SafeInt32(7), SafeUInt32(2)) === SafeUInt32(div(7,2))
    @test SaferIntegers.checked_rem(SafeInt32(7), SafeUInt32(2)) === SafeUInt32(rem(7,2))
    @test SaferIntegers.checked_mod(SafeInt32(7), SafeUInt32(2)) === SafeUInt32(mod(7,2))
    @test SaferIntegers.checked_fld(SafeInt16(7), SafeUInt16(2)) === SafeUInt16(fld(7,2))
    @test SaferIntegers.checked_cld(SafeInt32(7), SafeUInt32(2)) === SafeUInt32(cld(7,2))

    @test SaferIntegers.checked_add(SafeInt16(7), SafeUInt32(2)) === SafeUInt32(7+2)
    @test SaferIntegers.checked_sub(SafeInt8(7), SafeUInt64(2)) === SafeUInt64(7-2)
    @test SaferIntegers.checked_mul(SafeInt32(7), SafeUInt16(2)) === SafeInt32(7*2)
    @test SaferIntegers.checked_div(SafeInt32(7), SafeUInt16(2)) === SafeInt32(div(7,2))
    @test SaferIntegers.checked_rem(SafeInt32(7), SafeUInt16(2)) === SafeInt32(rem(7,2))
    @test SaferIntegers.checked_mod(SafeInt32(7), SafeUInt16(2)) === SafeInt32(mod(7,2))
    @test SaferIntegers.checked_fld(SafeInt32(7), SafeUInt16(2)) === SafeInt32(fld(7,2))
    @test SaferIntegers.checked_cld(SafeInt32(7), SafeUInt16(2)) === SafeInt32(cld(7,2))
end

@testset "checked safe with unsafe arithmetic" begin
    @test SaferIntegers.checked_add(SafeInt32(7), Int32(2)) === SafeInt32(7+2)
    @test SaferIntegers.checked_sub(SafeInt64(7), Int64(2)) === SafeInt64(7-2)
    @test SaferIntegers.checked_mul(SafeInt32(7), Int32(2)) === SafeInt32(7*2)
    @test SaferIntegers.checked_div(SafeInt32(7), Int32(2)) === SafeInt32(div(7,2))
    @test SaferIntegers.checked_rem(SafeInt32(7), Int32(2)) === SafeInt32(rem(7,2))
    @test SaferIntegers.checked_mod(SafeInt32(7), Int32(2)) === SafeInt32(mod(7,2))
    @test SaferIntegers.checked_fld(SafeInt16(7), Int16(2)) === SafeInt16(fld(7,2))
    @test SaferIntegers.checked_cld(SafeInt32(7), Int32(2)) === SafeInt32(cld(7,2))

    @test SaferIntegers.checked_add(Int16(7), SafeInt32(2)) === SafeInt32(7+2)
    @test SaferIntegers.checked_sub(Int8(7), SafeInt64(2)) === SafeInt64(7-2)
    @test SaferIntegers.checked_mul(Int32(7), SafeInt16(2)) === SafeInt16(7*2)
    @test SaferIntegers.checked_div(Int32(7), SafeInt16(2)) === SafeInt16(div(7,2))
    @test SaferIntegers.checked_rem(Int32(7), SafeInt16(2)) === SafeInt16(rem(7,2))
    @test SaferIntegers.checked_mod(Int32(7), SafeInt16(2)) === SafeInt16(mod(7,2))
    @test SaferIntegers.checked_fld(Int32(7), SafeInt16(2)) === SafeInt16(fld(7,2))
    @test SaferIntegers.checked_cld(Int32(7), SafeInt64(2)) === SafeInt64(cld(7,2))
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
    @test fldmod1(SafeInt32(7), SafeInt16(-2)) === SafeInt32.(fldmod1(7,-2))
    @test SaferIntegers.divgcd(SafeInt32(7), SafeInt32(-2)) === SafeInt32.(Base.divgcd(7,-2))
    @test SaferIntegers.divgcd(SafeInt32(7), SafeInt16(-2)) === SafeInt32.(Base.divgcd(7,-2))

    @test lcm(SafeInt32(7), Int16(2)) === SafeInt32(lcm(7,2))
    @test gcd(SafeInt32(7), Int16(-2)) === SafeInt32(gcd(7,-2))
    @test divrem(SafeInt32(7), Int16(2)) === SafeInt32.(divrem(7,2))
    @test fldmod(SafeInt32(7), Int16(-2)) === SafeInt32.(fldmod(7,-2))
    @test fldmod1(SafeInt32(7), Int16(-2)) === SafeInt32.(fldmod1(7,-2))
    @test SaferIntegers.divgcd(SafeInt32(7), Int16(-2)) === SafeInt32.(Base.divgcd(7,-2))

    @test lcm(Int32(7), SafeInt16(2)) === SafeInt16(lcm(7,2))
    @test gcd(Int32(7), SafeInt16(-2)) === SafeInt16(gcd(7,-2))
    @test divrem(Int32(7), SafeInt16(2)) === SafeInt16.(divrem(7,2))
    @test fldmod(Int32(7), SafeInt16(-2)) === SafeInt16.(fldmod(7,-2))
    @test fldmod1(Int32(7), SafeInt16(-2)) === SafeInt16.(fldmod1(7,-2))
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

    @test SafeInt64(40)^SafeInt32(2) === SafeInt64(Int64(40)^2)
    @test SafeInt64(130)^SafeInt64(2) === SafeInt64(Int64(130)^2)
    @test_throws OverflowError SafeInt16(32)^SafeInt16(32)
    @test_throws DomainError SafeInt16(32)^SafeInt16(-2)
    @test_throws DomainError SafeInt64(130)^SafeInt64(-2)
    
    @test SafeInt64(40)^2 === SafeInt64(Int64(40^2))
    @test Int64(40)^SafeInt32(2) === Int64(40)^2
    @test SafeInt64(40)^2 === SafeInt64(Int64(40)^2)
    
    @test SaferIntegers.ipower(SafeInt32(2), SafeInt32(3)) === SafeInt32(8)
    @test_throws OverflowError SaferIntegers.ipower(SafeInt16(16), SafeInt16(16))
    @test_throws OverflowError SaferIntegers.ipower(typemax(SafeInt64), typemax(SafeInt64))
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

    
