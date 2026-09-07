import Cardinal
import Difference
import Tagged

struct First: ~Copyable, ~Escapable {}

#if MISMATCH_DOMAIN
struct Second: ~Copyable, ~Escapable {}
#else
typealias Second = First
#endif

let count = Tagged<Second, Cardinal>(Cardinal(UInt.max))
let offset = Tagged<First, Difference>(count)
