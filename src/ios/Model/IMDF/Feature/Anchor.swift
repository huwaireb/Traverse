import Foundation
import MapboxMaps

class Anchor: Feature<Anchor.Properties> {
    struct Properties: Codable {
        let addressId: UUID?
        let unitId: UUID
    }
}
