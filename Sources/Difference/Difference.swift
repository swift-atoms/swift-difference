public import Cardinal
public import Magnitude
public import Polarity

public struct Difference: Sendable {
    private let _polarity: Polarity

    private let _magnitude: Magnitude

    public init(polarity: Polarity, magnitude: Magnitude) {
        self._polarity = magnitude.value.rawValue == 0 ? .positive : polarity
        self._magnitude = magnitude
    }
}

extension Difference {
    public typealias Magnitude = Magnitude::Magnitude<Cardinal>
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

    public var polarity: Polarity? {
        magnitude.value.rawValue == 0 ? nil : _polarity
    }

    public var magnitude: Magnitude { _magnitude }

    @inlinable
    public init(_ value: Int) {
        self =
            if value < 0 {
                .negative(Magnitude(Cardinal(value.magnitude)))
            } else {
                .positive(Magnitude(Cardinal(UInt(value))))
            }
    }
}

extension Difference {

    public enum Error: Swift::Error, Hashable, Sendable {
        case overflow
        case unrepresentable
    }

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

extension Difference: Swift::Comparable {

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

extension Difference: Swift::CustomStringConvertible {

    public var description: String {
        switch polarity {
        case .negative: return "-\(magnitude.value)"
        case nil: return "0"
        case .positive: return magnitude.value.description
        }
    }
}

extension Difference: Swift::Equatable, Swift::Hashable {

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

extension Difference: Swift::ExpressibleByIntegerLiteral {

    @_disfavoredOverload
    @inlinable
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}
