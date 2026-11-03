# swift-difference

Use this package when you need a signed offset between two counts or positions, for example moving an index backwards or forwards, where a negative answer is valid and the full unsigned range must stay reachable in both directions. Start from `Difference`, and wrap it in a `Carrier.Protocol` type or `Tagged` when the offset belongs to a domain. When the offset can never be negative and `end` behind `start` is a fault, use `Distance` from swift-distance instead. For a plain unsigned count, use `Cardinal` from swift-cardinal.

## Laws

- A `Difference` is a sign and a `Cardinal` magnitude, so it spans −`UInt.max` through +`UInt.max`. That is wider than `Int` on both sides.
- Zero has no sign. `polarity` is `nil` exactly when the magnitude is zero, and building a zero with a negative polarity gives the same value as `Difference.zero`.
- Under `add`, differences form a commutative group. `Difference.zero` is the identity, and negation is the inverse.
- `add.exact` and `subtract.exact` return the true integer result whenever it lies within ±`UInt.max`, and throw otherwise. `add.saturating` and `subtract.saturating` clamp to ±`UInt.max`.
- Ordering is numeric. Every negative value is below zero, every positive value is above it, and a larger magnitude means further from zero.
- Converting to `Int` is exact. `Difference(Int.min)` and `Difference(Int.max)` round-trip. A magnitude outside the `Int` range on its side is unrepresentable: `intValue()` throws, and `Int(exactly:)` returns `nil`.
- The collection index and raw-pointer adapters convert the offset with `Int(exactly:)`. They trap when it does not fit, and keep the sign.
- When encoded, `polarity` is omitted exactly when the magnitude is zero. Decoding rejects a signed zero and an unsigned non-zero value.
- The atomic representation round-trips every value, including ±`UInt.max`.
- A count converts into an offset only within the same domain. The result has the count's magnitude and positive polarity, or no polarity for zero. An offset converts back into a `Cardinal` count only when it is not negative.
