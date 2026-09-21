public import Cardinal
public import Carrier

@inlinable
public func < <D: Carrier.`Protocol`, C: Carrier.`Protocol`>(lhs: D, rhs: C) -> Bool
where D.Underlying == Difference, C.Underlying == Cardinal, D.Domain == C.Domain {
    lhs.difference < Difference.positive(.init(rhs.cardinal))
}

@inlinable
public func < <D: Carrier.`Protocol`, C: Carrier.`Protocol`>(lhs: C, rhs: D) -> Bool
where D.Underlying == Difference, C.Underlying == Cardinal, D.Domain == C.Domain {
    Difference.positive(.init(lhs.cardinal)) < rhs.difference
}

@inlinable
public func <= <D: Carrier.`Protocol`, C: Carrier.`Protocol`>(lhs: D, rhs: C) -> Bool
where D.Underlying == Difference, C.Underlying == Cardinal, D.Domain == C.Domain {
    lhs.difference <= Difference.positive(.init(rhs.cardinal))
}

@inlinable
public func <= <D: Carrier.`Protocol`, C: Carrier.`Protocol`>(lhs: C, rhs: D) -> Bool
where D.Underlying == Difference, C.Underlying == Cardinal, D.Domain == C.Domain {
    Difference.positive(.init(lhs.cardinal)) <= rhs.difference
}

@inlinable
public func > <D: Carrier.`Protocol`, C: Carrier.`Protocol`>(lhs: D, rhs: C) -> Bool
where D.Underlying == Difference, C.Underlying == Cardinal, D.Domain == C.Domain {
    lhs.difference > Difference.positive(.init(rhs.cardinal))
}

@inlinable
public func > <D: Carrier.`Protocol`, C: Carrier.`Protocol`>(lhs: C, rhs: D) -> Bool
where D.Underlying == Difference, C.Underlying == Cardinal, D.Domain == C.Domain {
    Difference.positive(.init(lhs.cardinal)) > rhs.difference
}

@inlinable
public func >= <D: Carrier.`Protocol`, C: Carrier.`Protocol`>(lhs: D, rhs: C) -> Bool
where D.Underlying == Difference, C.Underlying == Cardinal, D.Domain == C.Domain {
    lhs.difference >= Difference.positive(.init(rhs.cardinal))
}

@inlinable
public func >= <D: Carrier.`Protocol`, C: Carrier.`Protocol`>(lhs: C, rhs: D) -> Bool
where D.Underlying == Difference, C.Underlying == Cardinal, D.Domain == C.Domain {
    Difference.positive(.init(lhs.cardinal)) >= rhs.difference
}

