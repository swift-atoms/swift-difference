import Cardinal
import Polarity
import Magnitude

extension Difference: Swift.ExpressibleByIntegerLiteral {

    @_disfavoredOverload
    @inlinable
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}
