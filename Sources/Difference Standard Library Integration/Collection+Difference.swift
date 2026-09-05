public import Carrier_Protocol
public import Difference

extension Collection {

    @inlinable
    public func index(
        _ i: Self.Index,
        offsetBy distance: some Carrier.`Protocol`<Difference>
    ) -> Self.Index {
        guard let distance = Int(exactly: distance.difference) else {
            preconditionFailure("Difference is not representable as Int")
        }
        return self.index(i, offsetBy: distance)
    }

    @inlinable
    public func index(
        _ i: Self.Index,
        offsetBy distance: some Carrier.`Protocol`<Difference>,
        limitedBy limit: Self.Index
    ) -> Self.Index? {
        guard let distance = Int(exactly: distance.difference) else {
            preconditionFailure("Difference is not representable as Int")
        }
        return self.index(i, offsetBy: distance, limitedBy: limit)
    }

    @inlinable
    public func formIndex(
        _ i: inout Self.Index,
        offsetBy distance: some Carrier.`Protocol`<Difference>
    ) {
        guard let distance = Int(exactly: distance.difference) else {
            preconditionFailure("Difference is not representable as Int")
        }
        self.formIndex(&i, offsetBy: distance)
    }

    @discardableResult
    @inlinable
    public func formIndex(
        _ i: inout Self.Index,
        offsetBy distance: some Carrier.`Protocol`<Difference>,
        limitedBy limit: Self.Index
    ) -> Bool {
        guard let distance = Int(exactly: distance.difference) else {
            preconditionFailure("Difference is not representable as Int")
        }
        return self.formIndex(&i, offsetBy: distance, limitedBy: limit)
    }
}
