#if Hash
import Difference
import Testing

@Suite
struct `Affine Hash Tests` {

    @Test
    func `Difference supplies Hash's domain-typed value`() {
        let first: Int = hash(Difference(3))
        let second: Int = hash(Difference(3))

        #expect(first == second)
    }

}

private func hash<T: Swift.Hashable>(_ value: borrowing T) -> Int {
    value.hashValue
}

#endif
