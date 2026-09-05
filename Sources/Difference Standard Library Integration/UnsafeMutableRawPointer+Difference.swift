public import Carrier_Protocol
public import Difference

extension UnsafeMutableRawPointer {

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

    @inlinable
    public func storeBytes<T>(
        of value: T,
        toByteOffset offset: some Carrier.`Protocol`<Difference>,
        as type: T.Type
    ) {
        guard let offset = Int(exactly: offset.difference) else {
            preconditionFailure("Difference is not representable as Int")
        }
        unsafe self.storeBytes(of: value, toByteOffset: offset, as: type)
    }
}
