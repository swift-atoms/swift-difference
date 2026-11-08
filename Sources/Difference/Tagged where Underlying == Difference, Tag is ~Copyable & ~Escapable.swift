public import Cardinal
public import Carrier
public import Tagged

extension Tagged where Underlying == Difference, Tag: ~Copyable & ~Escapable {
    @inlinable
    public init(_ value: Int) {
        self.init(_unchecked: Difference(value))
    }

    @inlinable
    public init<C: Carrier.`Protocol`<Cardinal>>(_ count: C) where C.Domain == Tag {
        self.init(_unchecked: .positive(.init(count.cardinal)))
    }
}
