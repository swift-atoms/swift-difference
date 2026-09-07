public import Carrier
public import Difference

extension UnsafeRawPointer {

    @inlinable
    public func advanced(by offset: some Carrier.`Protocol`<Difference>) -> Self {
        guard let offset = Int(exactly: offset.difference) else {
            preconditionFailure("Difference is not representable as Int")
        }
        return unsafe self.advanced(by: offset)
    }

    @inlinable
    public func load<T>(
        fromByteOffset offset: some Carrier.`Protocol`<Difference>,
        as type: T.Type
    ) -> T {
        guard let offset = Int(exactly: offset.difference) else {
            preconditionFailure("Difference is not representable as Int")
        }
        return unsafe self.load(fromByteOffset: offset, as: type)
    }
}
