import Addition
import Cardinal
import Carrier
import Difference
import Foundation
import Magnitude
import Polarity
import Property
import Subtraction
import Tagged
import Testing

@Suite
struct `Difference Tests` {

    @Test
    func `binary constructors are total and normalize both signs of zero`() {
        let positiveZero = Difference(
            polarity: .positive,
            magnitude: Difference.Magnitude(Cardinal(0 as UInt))
        )
        let negativeZero = Difference(
            polarity: .negative,
            magnitude: Difference.Magnitude(Cardinal(0 as UInt))
        )

        #expect(positiveZero == .zero)
        #expect(negativeZero == .zero)
        #expect(positiveZero.polarity == nil)
        #expect(negativeZero.polarity == nil)
        #expect(positiveZero.magnitude == Difference.Magnitude(Cardinal(0 as UInt)))
    }

    @Test
    func `signed magnitude covers the complete UInt range`() {
        let maximum = Difference.Magnitude(Cardinal(UInt.max))
        let positive = Difference.positive(maximum)
        let negative = Difference.negative(maximum)

        #expect(positive.polarity == .positive)
        #expect(negative.polarity == .negative)
        #expect(positive.magnitude == maximum)
        #expect(negative.magnitude == maximum)
        #expect(-positive == negative)
        #expect(-negative == positive)
        #expect(-Difference.zero == .zero)
    }

    @Test
    func `literal comparison and Codable preserve semantic values`() throws {
        let literal: Difference = -42
        #expect(literal < .zero)
        #expect(literal.description == "-42")

        let values: [Difference] = [
            .zero,
            .one,
            Difference(-1),
            .positive(Difference.Magnitude(Cardinal(UInt.max))),
            .negative(Difference.Magnitude(Cardinal(UInt.max))),
        ]
        for value in values {
            let encoded = try JSONEncoder().encode(value)
            #expect(try JSONDecoder().decode(Difference.self, from: encoded) == value)
        }
    }

    @Test
    func `Codable rejects sign and zero mismatches`() throws {
        let signedZero = EncodedDifference(polarity: .negative, magnitude: 0)
        let unsignedNonzero = EncodedDifference(polarity: nil, magnitude: 1)

        #expect(throws: (any Swift.Error).self) {
            try JSONDecoder().decode(
                Difference.self,
                from: JSONEncoder().encode(signedZero)
            )
        }
        #expect(throws: (any Swift.Error).self) {
            try JSONDecoder().decode(
                Difference.self,
                from: JSONEncoder().encode(unsignedNonzero)
            )
        }
    }

    @Test
    func `Int conversion is exact at both boundaries`() throws {
        #expect(try Difference(Int.max).intValue() == Int.max)
        #expect(try Difference(Int.min).intValue() == Int.min)
        #expect(throws: Difference.Error.unrepresentable) {
            try Difference.positive(Difference.Magnitude(Cardinal(UInt(Int.max) + 1))).intValue()
        }
        #expect(throws: Difference.Error.unrepresentable) {
            try Difference.negative(Difference.Magnitude(Cardinal(UInt(Int.max) + 2))).intValue()
        }
    }

    @Test
    func `exact and saturating arithmetic preserve full-width semantics`() throws {
        let maximum = Difference.Magnitude(Cardinal(UInt.max))
        #expect(try Difference(7).add.exact(Difference(-2)) == Difference(5))
        #expect(try Difference(-7).subtract.exact(Difference(-2)) == Difference(-5))
        #expect(try Difference.positive(maximum).add.exact(.negative(maximum)) == .zero)
        #expect(throws: Difference.Error.overflow) {
            try Difference.positive(maximum).add.exact(.one)
        }
        #expect(throws: Difference.Error.overflow) {
            try Difference.negative(maximum).subtract.exact(.one)
        }
        #expect(Difference.positive(maximum).add.saturating(.one) == .positive(maximum))
        #expect(Difference.negative(maximum).subtract.saturating(.one) == .negative(maximum))
    }

    @Test
    func `exact arithmetic agrees with an Int128 boundary oracle`() {
        let maximum = Difference.Magnitude(Cardinal(UInt.max))
        let values: [Difference] = [
            .negative(maximum),
            Difference(Int.min),
            Difference(-1),
            .zero,
            .one,
            Difference(Int.max),
            .positive(maximum),
        ]
        let maximumMagnitude = Int128(UInt.max)

        for lhs in values {
            for rhs in values {
                checkExact(lhs.add.exact, rhs, expected: int128(lhs) + int128(rhs), maximumMagnitude)
                checkExact(
                    lhs.subtract.exact,
                    rhs,
                    expected: int128(lhs) - int128(rhs),
                    maximumMagnitude
                )
            }
        }
    }
}

private struct EncodedDifference: Encodable {
    let polarity: Polarity?
    let magnitude: UInt
}

private func checkExact(
    _ operation: (Difference) throws(Difference.Error) -> Difference,
    _ rhs: Difference,
    expected: Int128,
    _ maximumMagnitude: Int128
) {
    do {
        let result = try operation(rhs)
        #expect(absolute(expected) <= maximumMagnitude)
        #expect(int128(result) == expected)
    } catch {
        #expect(absolute(expected) > maximumMagnitude)
    }
}

private func int128(_ difference: Difference) -> Int128 {
    let magnitude = Int128(difference.magnitude.value.rawValue)
    return difference.polarity == .negative ? -magnitude : magnitude
}

private func absolute(_ value: Int128) -> Int128 {
    value < 0 ? -value : value
}

private enum Distance {}

private struct Wrapped<Tag>: Carrier.`Protocol`, Equatable {
    typealias Domain = Tag
    let underlying: Difference
    init(_ underlying: Difference) { self.underlying = underlying }
}

extension `Difference Tests` {

    @Test(arguments: [UInt.zero, 1, UInt(Int.max), UInt(Int.max) + 1, UInt.max])
    func `count conversion retains its complete magnitude and domain`(value: UInt) {
        let count = Tagged<Distance, Cardinal>(_unchecked: Cardinal(value))
        let offset = Tagged<Distance, Difference>(count)

        #expect(offset.underlying.magnitude.value == count.underlying)
        #expect(offset.underlying.polarity == (value == 0 ? nil : .positive))
    }

    @Test
    func `custom count carriers preserve noncopyable and nonescapable domains`() {
        let count = Count<PhantomDomain>(Cardinal(UInt.max))
        let offset = Tagged<PhantomDomain, Difference>(count)

        #expect(offset.underlying.magnitude.value.rawValue == UInt.max)
        #expect(offset.underlying.polarity == .positive)
    }

    @Test
    func `custom carrier arithmetic preserves the wrapper`() throws {
        let a = Wrapped<Distance>(Difference(4))
        let b = Wrapped<Distance>(Difference(-9))
        let addition: Property<Addition, Wrapped<Distance>> = a.add
        let subtraction: Property<Subtraction, Wrapped<Distance>> = a.subtract
        let sum: Wrapped<Distance> = try addition.exact(b)
        let difference: Wrapped<Distance> = try subtraction.exact(b)
        #expect(sum == Wrapped(Difference(-5)))
        #expect(difference == Wrapped(Difference(13)))
        #expect(-sum == Wrapped(Difference(5)))
    }

    @Test
    func `tagged magnitude preserves domain and role until explicitly mapped`() throws {
        let difference = Tagged<Distance, Difference>(Difference(-12))
        let nested: Tagged<Distance, Difference.Magnitude> = difference.magnitude
        let count: Tagged<Distance, Cardinal> = nested.map { $0.value }

        #expect(nested.underlying == Difference.Magnitude(Cardinal(12 as UInt)))
        #expect(count.underlying == Cardinal(12 as UInt))
    }

    @Test
    func `nested magnitude arithmetic retains both tags`() throws {
        typealias Magnitude = Tagged<Distance, Difference.Magnitude>
        let three = Magnitude(_unchecked: Difference.Magnitude(Cardinal(3 as UInt)))
        let five = Magnitude(_unchecked: Difference.Magnitude(Cardinal(5 as UInt)))
        let maximum = Magnitude(_unchecked: Difference.Magnitude(Cardinal(UInt.max)))

        let sum: Magnitude = three + five
        let exactSum: Magnitude = try three.add.exact(five)
        let exactDifference: Magnitude = try five.subtract.exact(three)
        let saturated: Magnitude = three.subtract.saturating(five)

        #expect(sum.underlying.value == Cardinal(8 as UInt))
        #expect(exactSum == sum)
        #expect(exactDifference.underlying.value == Cardinal(2 as UInt))
        #expect(saturated.underlying.value == Cardinal(0 as UInt))
        #expect(throws: Cardinal.Error.overflow) {
            try maximum.add.exact(three)
        }
    }
}

private struct PhantomDomain: ~Copyable, ~Escapable {}

private struct Count<Tag: ~Copyable & ~Escapable>: Carrier.`Protocol` {
    typealias Domain = Tag
    let underlying: Cardinal
    init(_ underlying: Cardinal) { self.underlying = underlying }
}
