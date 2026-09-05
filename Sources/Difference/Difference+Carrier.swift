public import Addition
public import Carrier_Protocol
public import Property
public import Subtraction

extension Difference: Carrier.`Protocol` {
    public typealias Underlying = Difference
}

extension Carrier.`Protocol` where Underlying == Difference {

    @inlinable
    public var difference: Difference { underlying }

    @inlinable
    public static var zero: Self { Self(.zero) }

    @inlinable
    public static var one: Self { Self(.one) }

    @inlinable
    public static prefix func - (value: Self) -> Self { Self(-value.difference) }

    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.difference + rhs.difference)
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.difference - rhs.difference)
    }

    @inlinable
    public static func += (lhs: inout Self, rhs: Self) { lhs = lhs + rhs }

    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) { lhs = lhs - rhs }

    @inlinable
    public var add: Property<Addition, Self> { Property(self) }

    @inlinable
    public var subtract: Property<Subtraction, Self> { Property(self) }
}

extension Property where Tag == Addition, Base: Carrier.`Protocol`, Base.Underlying == Difference {

    @inlinable
    public func exact(_ other: Base) throws(Difference.Error) -> Base {
        try Base(base.difference.add.exact(other.difference))
    }

    @inlinable
    public func saturating(_ other: Base) -> Base {
        Base(base.difference.add.saturating(other.difference))
    }
}

extension Property where Tag == Subtraction, Base: Carrier.`Protocol`, Base.Underlying == Difference {

    @inlinable
    public func exact(_ other: Base) throws(Difference.Error) -> Base {
        try Base(base.difference.subtract.exact(other.difference))
    }

    @inlinable
    public func saturating(_ other: Base) -> Base {
        Base(base.difference.subtract.saturating(other.difference))
    }
}
