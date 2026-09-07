public import Cardinal
public import Polarity
public import Magnitude

extension Difference: Swift.Comparable {

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs.polarity, rhs.polarity) {
        case (.negative, .negative): return lhs.magnitude > rhs.magnitude
        case (.negative, _): return true
        case (nil, .positive): return true
        case (nil, _): return false
        case (.positive, .positive): return lhs.magnitude < rhs.magnitude
        case (.positive, _): return false
        }
    }
}
