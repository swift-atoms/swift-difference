public import Cardinal
public import Polarity
public import Magnitude

extension Difference: Swift.Equatable, Swift.Hashable {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.polarity == rhs.polarity && lhs.magnitude == rhs.magnitude
    }

    @inlinable
    public borrowing func hash(into hasher: inout Hasher) {
        hasher.combine(polarity)
        hasher.combine(magnitude)
    }
}
