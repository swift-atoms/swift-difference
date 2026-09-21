import Difference
import Testing

extension Difference {
    @Suite("Difference Checked Arithmetic Migration Tests")
    struct Test {
        @Suite struct Unit {}
    }
}

extension Difference.Test.Unit {
    @Test
    func `identity is zero`() throws {
        #expect(Difference.zero.polarity == nil)
    }

    @Test
    func `combining matches addition`() throws {
        let a: Difference = 3
        let b: Difference = 5
        #expect(try a.add.exact(b) == a + b)
    }

    @Test
    func `inverting matches negation`() throws {
        let a: Difference = 7
        #expect(Int(exactly: -a) == -7)
    }

    @Test
    func `identity left`() throws {
        let a: Difference = 7
        #expect(try Difference.zero.add.exact(a) == a)
    }

    @Test
    func `identity right`() throws {
        let a: Difference = 7
        #expect(try a.add.exact(.zero) == a)
    }

    @Test
    func `inverse left`() throws {
        let a: Difference = 7
        #expect(try (-a).add.exact(a) == Difference.zero)
    }

    @Test
    func `inverse right`() throws {
        let a: Difference = 7
        #expect(try a.add.exact(-a) == Difference.zero)
    }

    @Test
    func `commutativity`() throws {
        let a: Difference = 3
        let b: Difference = -5
        #expect(try a.add.exact(b) == b.add.exact(a))
    }
}
