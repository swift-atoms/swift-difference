extension Swift.Int {


    @inlinable
    public init?(exactly difference: Difference) {
        do {
            self = try difference.intValue()
        } catch {
            return nil
        }
    }
}

public import Carrier

extension Swift.Int {
    /// Exact conversion of a domain-tagged displacement; nil outside Int's range.
    @inlinable
    public init?<D: Carrier.`Protocol`>(exactly displacement: D)
    where D.Underlying == Difference {
        self.init(exactly: displacement.difference)
    }
}
