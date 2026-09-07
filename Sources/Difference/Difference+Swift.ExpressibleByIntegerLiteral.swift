public import Cardinal
public import Polarity
public import Magnitude

extension Difference: Swift.ExpressibleByIntegerLiteral {

    @_disfavoredOverload
    @inlinable
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}
