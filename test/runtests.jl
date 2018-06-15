using SaferIntegers
if VERSION < v"0.7.0-DEV.2004"
    using Base.Test
else
    using Test
end


macro no_error(x)
    :(@test (try $x; true; catch e; false; end))
end
macro is_error(x)
    :(@test (try $x; false; catch e; true; end))
end

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

@test SafeInt16(7) >  SafeInt32(2)
@test SafeInt8(7)  >= SafeInt64(2) 
@test SafeInt16(2) <  SafeInt32(7)
@test SafeInt8(2)  <= SafeInt64(7) 

@test SafeInt32(7) & SafeInt32(2) === SafeInt32(7&2)
@test SafeInt16(7) | SafeInt16(2) === SafeInt16(7|2)
@test xor(SafeInt64(7), Int64(2)) === SafeInt64(xor(7,2))
@test SafeInt32(7) >>> SafeInt32(2) === SafeInt32(7 >>> 2)
@test SafeInt32(7) >> SafeInt32(2) === SafeInt32(7 >> 2)
@test SafeInt32(7) << SafeInt32(2) === SafeInt32(7 << 2)

@test SafeInt16(7) + SafeInt32(2) === SafeInt32(7+2)
@test SafeInt8(7) - SafeInt64(2) === SafeInt64(7-2)
@test SafeInt32(7) * Int16(2) === SafeInt32(7*2)

@test SafeInt16(Int8(2)) === SafeInt16(2)
@test Int16(SafeInt8(2)) === Int16(2)
@test SafeUInt64(UInt8(2)) === SafeUInt64(2)
@test UInt16(SafeUInt64(2)) === UInt16(2)
@test SafeInt16(UInt32(2)) === SafeInt16(2)
@test UInt32(SafeInt8(2)) === UInt32(2)
@test SafeUInt128(Int8(2)) === SafeUInt128(2)
@test Int16(SafeUInt128(2)) === Int16(2)

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
