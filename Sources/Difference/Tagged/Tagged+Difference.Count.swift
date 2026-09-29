#if Tagged
public import Cardinal
public import Magnitude
public import Tagged

extension Tagged where Underlying == Cardinal, Tag: ~Copyable & ~Escapable {
    @inlinable
    public init(_ offset: Tagged<Tag, Difference>) throws(Cardinal.Error) {
        guard offset.underlying >= .zero else {
            throw .negativeMagnitude(offset.underlying.magnitude.value.rawValue)
        }
        self.init(_unchecked: offset.underlying.magnitude.value)
    }
}
#endif
