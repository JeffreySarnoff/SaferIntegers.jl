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

@test SafeInt16(7) + SafeInt32(2) === SafeInt32(7+2)
@test SafeInt8(7) - SafeInt64(2) === SafeInt64(7-2)
@test SafeInt32(7) * Int16(2) === SafeInt32(7*2)
