# Difference

`Difference` represents a signed discrete difference whose positive and negative
ranges both span `UInt.max`. It stores binary polarity plus a validated magnitude.
Zero has one canonical representation and exposes `nil` polarity.

```text
Difference.Magnitude = Magnitude<Cardinal>
```

This alias adds no `Tagged<Difference, Cardinal>` layer. Magnitude validates its
finite nonnegative scalar and does not conform to `Carrier<Cardinal>`.

An outer application domain is preserved by generic Tagged projection:

```swift
let magnitude: Tagged<Domain, Difference.Magnitude> = difference.magnitude
let count: Tagged<Domain, Cardinal> = magnitude.map { $0.value }
```

The conversion to a count is explicit because magnitude and count are different
roles.

Difference owns its exact and saturating arithmetic policies while delegating the
binary signed-magnitude calculation to `Addition.Signed.exact` and
`Addition.Signed.saturating`. Subtraction delegates to `Subtraction.Signed`,
which reverses the right polarity and reuses Addition. Opposite signs subtract
magnitudes; matching signs
can overflow. Either sign paired with zero normalizes to canonical zero.

Import `Difference_Standard_Library_Integration` for exact `Int` conversion,
collection and raw-pointer offsets, and atomic support. The atomic representation
uses `UInt128`: bit zero stores the negative sign and the following
`UInt.bitWidth` bits store the full magnitude.
