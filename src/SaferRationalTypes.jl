SafeRational(num::T, den::T) where {T<:SafeSigned} = num//den
SafeRational(num::T, den::T) where {T<:Signed} = safeint(num)//safeint(den)

SafeRational(num::T1, den::T2) where {T1<:SafeSigned, T2<:SafeSigned} = SafeRational(promote(num, den)...)
SafeRational(num::T1, den::T2) where {T1<:Signed, T2<:Signed} = SafeRational(promote(num, den)...)

SafeRational(num::T1, den::T2) where {T1<:Signed, T2<:SafeSigned} = SafeRational(promote(safeint(num), den)...)
SafeRational(num::T1, den::T2) where {T1<:SafeSigned, T2<:Signed} = SafeRational(promote(num, safeint(den))...)
