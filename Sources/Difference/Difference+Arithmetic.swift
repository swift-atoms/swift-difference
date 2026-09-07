public import Magnitude
public import Addition
public import Cardinal
public import Polarity
public import Property
public import Subtraction

extension Difference {
    @inlinable
    public var add: Property<Addition, Self> { Property(self) }

    @inlinable
    public var subtract: Property<Subtraction, Self> { Property(self) }
}

extension Property where Tag == Addition, Base == Difference {
    @inlinable
    public func exact(_ other: Base) throws(Difference.Error) -> Base {
        do {
            let result = try Addition.Signed.exact(
                lhsMagnitude: base.magnitude.value.rawValue,
                lhsPolarity: base.polarity ?? .positive,
                rhsMagnitude: other.magnitude.value.rawValue,
                rhsPolarity: other.polarity ?? .positive
            )
            return Difference(
                polarity: result.polarity,
                magnitude: Difference.Magnitude(Cardinal(result.magnitude))
            )
        } catch { throw .overflow }
    }

    @inlinable
    public func saturating(_ other: Base) -> Base {
        let result = Addition.Signed.saturating(
            lhsMagnitude: base.magnitude.value.rawValue,
            lhsPolarity: base.polarity ?? .positive,
            rhsMagnitude: other.magnitude.value.rawValue,
            rhsPolarity: other.polarity ?? .positive
        )
        return Difference(
            polarity: result.polarity,
            magnitude: Difference.Magnitude(Cardinal(result.magnitude))
        )
    }
}

extension Property where Tag == Subtraction, Base == Difference {
    @inlinable
    public func exact(_ other: Base) throws(Difference.Error) -> Base {
        do {
            let result = try Subtraction.Signed.exact(
                lhsMagnitude: base.magnitude.value.rawValue,
                lhsPolarity: base.polarity ?? .positive,
                rhsMagnitude: other.magnitude.value.rawValue,
                rhsPolarity: other.polarity ?? .positive
            )
            return Difference(
                polarity: result.polarity,
                magnitude: Difference.Magnitude(Cardinal(result.magnitude))
            )
        } catch { throw .overflow }
    }

    @inlinable
    public func saturating(_ other: Base) -> Base {
        let result = Subtraction.Signed.saturating(
            lhsMagnitude: base.magnitude.value.rawValue,
            lhsPolarity: base.polarity ?? .positive,
            rhsMagnitude: other.magnitude.value.rawValue,
            rhsPolarity: other.polarity ?? .positive
        )
        return Difference(
            polarity: result.polarity,
            magnitude: Difference.Magnitude(Cardinal(result.magnitude))
        )
    }
}

extension Difference {

    @inlinable
    public static prefix func - (value: Self) -> Self {
        guard let polarity = value.polarity else { return .zero }
        return Self(polarity: polarity.opposite, magnitude: value.magnitude)
    }

    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        do {
            return try lhs.add.exact(rhs)
        } catch {
            preconditionFailure("Difference overflow in addition")
        }
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        do {
            return try lhs.subtract.exact(rhs)
        } catch {
            preconditionFailure("Difference overflow in subtraction")
        }
    }

    @inlinable
    public static func += (lhs: inout Self, rhs: Self) { lhs = lhs + rhs }

    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) { lhs = lhs - rhs }
}
