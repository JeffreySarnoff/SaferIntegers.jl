SafeRational(num::T, den::T) where {T<:SafeSigned} = num//den
SafeRational(num::T, den::T) where {T<:Signed} = safeint(num)//safeint(den)

SafeRational(num::T1, den::T2) where {T1<:SafeSigned, T2<:SafeSigned} = SafeRational(promote(num, den)...)
SafeRational(num::T1, den::T2) where {T1<:Signed, T2<:Signed} = SafeRational(promote(safeint(num), safeint(den))...)

SafeRational(num::T1, den::T2) where {T1<:Signed, T2<:SafeSigned} = SafeRational(promote(safeint(num), den)...)
SafeRational(num::T1, den::T2) where {T1<:SafeSigned, T2<:Signed} = SafeRational(promote(num, safeint(den))...)


SafeRational(num::T, den::T) where {T<:SafeUnsigned} = num//den
SafeRational(num::T, den::T) where {T<:Unsigned} = safeint(num)//safeint(den)

SafeRational(num::T1, den::T2) where {T1<:SafeUnsigned, T2<:SafeUnsigned} = SafeRational(promote(num, den)...)
SafeRational(num::T1, den::T2) where {T1<:Unsigned, T2<:Unsigned} = SafeRational(promote(num, den)...)

SafeRational(num::T1, den::T2) where {T1<:Unsigned, T2<:SafeUnsigned} = SafeRational(promote(safeint(num), den)...)
SafeRational(num::T1, den::T2) where {T1<:SafeUnsigned, T2<:Unsigned} = SafeRational(promote(num, safeint(den))...)

SafeRational(num::T1, den::T2) where {T1<:SafeSigned, T2<:SafeUnsigned} = SafeRational(promote(num, den)...)
SafeRational(num::T1, den::T2) where {T1<:SafeUnsigned, T2<:SafeSigned} = SafeRational(promote(num, den)...)
SafeRational(num::T1, den::T2) where {T1<:Signed, T2<:Unsigned} = SafeRational(promote(num, den)...)
SafeRational(num::T1, den::T2) where {T1<:Unsigned, T2<:Signed} = SafeRational(promote(num, den)...)
SafeRational(num::T1, den::T2) where {T1<:Unsigned, T2<:SafeSigned} = SafeRational(promote(safeint(num), den)...)
SafeRational(num::T1, den::T2) where {T1<:SafeSigned, T2<:Unsigned} = SafeRational(promote(num, safeint(den))...)
SafeRational(num::T1, den::T2) where {T1<:Signed, T2<:SafeUnsigned} = SafeRational(promote(safeint(num), den)...)
SafeRational(num::T1, den::T2) where {T1<:SafeUnsigned, T2<:Signed} = SafeRational(promote(num, safeint(den))...)
