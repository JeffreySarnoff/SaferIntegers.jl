## Safe Shifts

It is safe to shift (`<<`, `>>`) a value of type `T` where `β = sizeof(T) * 8 (with  __SafeUnsigned__ value
- by 0 bits, in which case the result is the value unchanged
- by `bitsof(T)` bits, in which case the result is `zero(T)`
- by `-bitsof(T)` bits, in which case the result is `zero(T)`
- by ⦃1, .., `bitsof(T)-1`⦄
     - the result is strictly less than any nonzero value given
     - the result, given a zero value remains zero
- by ⦃-1, .., `-(bitsof(T)-1)`⦄
    - the result is strictly greater than any nonzero value given
    - the result, given a zero value remains zero


of type `T` by 0 bits (unchanged) or by ±β bits where β ∈ ⦃0, 1, .., `bitsof(T)`⦄.

An `OverflowError` occurs when there is an attempt to shift a value of safe type `T`
by a magnitude greater than `±bitsof(T)`.
