import Cardinal
import Carrier
import Difference
import Testing

private struct Offset: Carrier.`Protocol` {
    let underlying: Difference
    init(_ underlying: Difference) { self.underlying = underlying }
}

@Suite
struct `Difference adapters preserve signed offsets and exact representation` {

    @Test
    func `exact Int conversion covers both boundaries`() throws {
        #expect(Int(exactly: Difference(Int.min)) == Int.min)
        #expect(Int(exactly: Difference(Int.max)) == Int.max)
        #expect(Int(exactly: Difference.zero) == 0)
        #expect(Int(exactly: .positive(Difference.Magnitude(Cardinal(UInt(Int.max) + 1)))) == nil)
        #expect(Int(exactly: .negative(Difference.Magnitude(Cardinal(UInt(Int.max) + 2)))) == nil)
        #expect(try Difference(Int.min).intValue() == Int.min)
        #expect(try Difference(Int.max).intValue() == Int.max)
    }

    @Test
    func `collection offsets preserve their sign`() {
        let values = Array(0..<10)
        let forward = values.index(values.startIndex, offsetBy: Offset(Difference(6)))
        let backward = values.index(forward, offsetBy: Offset(Difference(-4)))
        #expect(values[forward] == 6)
        #expect(values[backward] == 2)

        var index = forward
        values.formIndex(&index, offsetBy: Offset(Difference(-2)))
        #expect(values[index] == 4)
        #expect(
            values.index(forward, offsetBy: Offset(Difference(8)), limitedBy: values.endIndex)
                == nil
        )
    }

    @Test
    func `raw pointer adapters use exact byte offsets`() {
        let pointer = UnsafeMutableRawPointer.allocate(byteCount: 8, alignment: 4)
        defer { unsafe pointer.deallocate() }

        unsafe pointer.storeBytes(
            of: UInt32(0xAABBCCDD),
            toByteOffset: Offset(Difference(4)),
            as: UInt32.self
        )
        let mutableValue = unsafe pointer.load(
            fromByteOffset: Offset(Difference(4)),
            as: UInt32.self
        )
        let immutable = UnsafeRawPointer(pointer)
        let immutableValue = unsafe immutable.load(
            fromByteOffset: Offset(Difference(4)),
            as: UInt32.self
        )
        let mutableAdvancedMatches = unsafe pointer.advanced(
            by: Offset(Difference(4))
        ) == pointer + 4
        let immutableAdvancedMatches = unsafe immutable.advanced(
            by: Offset(Difference(4))
        ) == immutable + 4

        #expect(mutableValue == 0xAABBCCDD)
        #expect(immutableValue == 0xAABBCCDD)
        #expect(mutableAdvancedMatches)
        #expect(immutableAdvancedMatches)
    }

    #if SYNCHRONIZATION_AVAILABLE
        @Test(arguments: [
            Difference.zero,
            .one,
            Difference(-1),
            Difference(Int.min),
            Difference(Int.max),
            .positive(Difference.Magnitude(Cardinal(UInt.max))),
            .negative(Difference.Magnitude(Cardinal(UInt.max))),
        ])
        func `atomic representation round trips the complete range`(_ value: Difference) {
            let representation = Difference.encodeAtomicRepresentation(value)
            #expect(Difference.decodeAtomicRepresentation(representation) == value)
        }
    #endif
}
