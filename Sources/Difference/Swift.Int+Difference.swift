extension Swift.Int {

    /// Creates an `Int` when `difference` is exactly representable.
    @inlinable
    public init?(exactly difference: Difference) {
        do {
            self = try difference.intValue()
        } catch {
            return nil
        }
    }
}
