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
