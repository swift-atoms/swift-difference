public import Cardinal
public import Polarity
public import Magnitude

/// A signed, discrete difference whose positive and negative ranges both span
/// the complete `Cardinal` range.
public struct Difference: Sendable {

    /// The shared magnitude value specialized to whole steps; this alias adds no tag.
    public typealias Magnitude = Magnitude::Magnitude<Cardinal>

    private let _polarity: Polarity

    private let _magnitude: Magnitude

    /// Creates a difference from any binary sign and magnitude.
    ///
    /// Both signs paired with a zero magnitude normalize to the unique zero.
    public init(polarity: Polarity, magnitude: Magnitude) {
        self._polarity = magnitude.value.rawValue == 0 ? .positive : polarity
        self._magnitude = magnitude
    }
}

extension Difference {

    @inlinable
    public static func positive(_ magnitude: Magnitude) -> Self {
        Self(polarity: .positive, magnitude: magnitude)
    }

    @inlinable
    public static func negative(_ magnitude: Magnitude) -> Self {
        Self(polarity: .negative, magnitude: magnitude)
    }

    @inlinable
    public static var zero: Self { .positive(Magnitude(Cardinal(UInt.zero))) }

    @inlinable
    public static var one: Self { .positive(Magnitude(Cardinal(1 as UInt))) }

    /// The sign of a nonzero difference, or `nil` for zero.
    public var polarity: Polarity? {
        magnitude.value.rawValue == 0 ? nil : _polarity
    }

    public var magnitude: Magnitude { _magnitude }

    @inlinable
    public init(_ value: Int) {
        if value < 0 {
            self = .negative(Magnitude(Cardinal(value.magnitude)))
        } else {
            self = .positive(Magnitude(Cardinal(UInt(value))))
        }
    }
}

extension Difference {

    public enum Error: Swift.Error, Hashable, Sendable {
        case overflow
        case unrepresentable
    }

    /// Returns the exactly represented standard-library integer.
    @inlinable
    public func intValue() throws(Error) -> Int {
        switch polarity {
        case nil:
            return 0
        case .positive:
            guard magnitude.value.rawValue <= UInt(Int.max) else {
                throw .unrepresentable
            }
            return Int(magnitude.value.rawValue)
        case .negative:
            let intMinimumMagnitude = UInt(Int.max) + 1
            guard magnitude.value.rawValue <= intMinimumMagnitude else {
                throw .unrepresentable
            }
            if magnitude.value.rawValue == intMinimumMagnitude { return Int.min }
            return -Int(magnitude.value.rawValue)
        }
    }
}
