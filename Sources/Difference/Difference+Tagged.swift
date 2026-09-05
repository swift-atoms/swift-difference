public import Addition
public import Cardinal
public import Property
public import Subtraction
public import Tagged

extension Tagged where Underlying == Difference, Tag: ~Copyable & ~Escapable {
    @inlinable
    public init(_ value: Int) {
        self.init(_unchecked: Difference(value))
    }
}

