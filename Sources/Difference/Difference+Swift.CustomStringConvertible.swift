import Cardinal
import Polarity
import Magnitude

extension Difference: Swift.CustomStringConvertible {

    public var description: String {
        switch polarity {
        case .negative: return "-\(magnitude.value)"
        case nil: return "0"
        case .positive: return magnitude.value.description
        }
    }
}
