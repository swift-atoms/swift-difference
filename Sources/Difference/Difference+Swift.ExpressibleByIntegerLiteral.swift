import Cardinal
import Magnitude
import Polarity

extension Difference: Swift::ExpressibleByIntegerLiteral {

    @_disfavoredOverload
    @inlinable
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}
