import Cardinal
import Polarity
import Magnitude

#if !hasFeature(Embedded)
extension Difference: Swift.Codable {

        private enum CodingKeys: String, CodingKey {
            case polarity
            case magnitude
        }

        public init(from decoder: any Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let polarity = try values.decodeIfPresent(Polarity.self, forKey: .polarity)
            let rawMagnitude = try values.decode(UInt.self, forKey: .magnitude)
            let isZero = rawMagnitude == 0
            guard isZero == (polarity == nil) else {
                throw DecodingError.dataCorruptedError(
                    forKey: .polarity,
                    in: values,
                    debugDescription: "Difference polarity must be nil exactly when magnitude is zero"
                )
            }
            self.init(
                polarity: polarity ?? .positive,
                magnitude: Magnitude(Cardinal(rawMagnitude))
            )
        }

        public func encode(to encoder: any Encoder) throws {
            var values = encoder.container(keyedBy: CodingKeys.self)
            try values.encodeIfPresent(polarity, forKey: .polarity)
            try values.encode(magnitude.value.rawValue, forKey: .magnitude)
        }
    }
#endif
