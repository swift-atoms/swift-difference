public import Magnitude
#if SYNCHRONIZATION_AVAILABLE
public import Cardinal
#endif

#if SYNCHRONIZATION_AVAILABLE
public import Polarity
#endif

#if SYNCHRONIZATION_AVAILABLE
public import Synchronization
#endif


#if SYNCHRONIZATION_AVAILABLE



    extension Difference: AtomicRepresentable {

        public typealias AtomicRepresentation = UInt128.AtomicRepresentation

        @inlinable
        public static func encodeAtomicRepresentation(
            _ value: consuming Self
        ) -> AtomicRepresentation {
            let sign: UInt128 = value.polarity == .negative ? 1 : 0
            let bits = (UInt128(value.magnitude.value.rawValue) << 1) | sign
            return UInt128.encodeAtomicRepresentation(bits)
        }

        @inlinable
        public static func decodeAtomicRepresentation(
            _ representation: consuming AtomicRepresentation
        ) -> Self {
            let bits = UInt128.decodeAtomicRepresentation(representation)
            let encodedMagnitude = bits >> 1
            precondition(
                encodedMagnitude <= UInt128(UInt.max),
                "Invalid Difference atomic representation"
            )
            let magnitude = Difference.Magnitude(Cardinal(UInt(encodedMagnitude)))
            return Difference(
                polarity: bits & 1 == 0 ? .positive : .negative,
                magnitude: magnitude
            )
        }
    }
#endif
