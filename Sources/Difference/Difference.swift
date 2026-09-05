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

extension Difference: Equatable, Hashable {

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

extension Difference: Comparable {

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

extension Difference: ExpressibleByIntegerLiteral {

    @_disfavoredOverload
    @inlinable
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

extension Difference: CustomStringConvertible {

    public var description: String {
        switch polarity {
        case .negative: return "-\(magnitude.value)"
        case nil: return "0"
        case .positive: return magnitude.value.description
        }
    }
}

#if !hasFeature(Embedded)
    extension Difference: Codable {

        private enum CodingKeys: String, CodingKey {
            case polarity
            case magnitude
        }

        public init(from decoder: any Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let polarity = try values.decodeIfPresent(Polarity.self, forKey: .polarity)
            let rawMagnitude = try values.decode(UInt.self, forKey: .magnitude)
            let isZero = rawMagnitude == 0
            guard isZero == (polarity == nil) else {
                throw DecodingError.dataCorruptedError(
                    forKey: .polarity,
                    in: values,
                    debugDescription: "Difference polarity must be nil exactly when magnitude is zero"
                )
            }
            self.init(
                polarity: polarity ?? .positive,
                magnitude: Magnitude(Cardinal(rawMagnitude))
            )
        }

        public func encode(to encoder: any Encoder) throws {
            var values = encoder.container(keyedBy: CodingKeys.self)
            try values.encodeIfPresent(polarity, forKey: .polarity)
            try values.encode(magnitude.value.rawValue, forKey: .magnitude)
        }
    }
#endif
