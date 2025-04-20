import Foundation
import MapboxMaps

class Occupant: Feature<Occupant.Properties> {
    struct Properties: Codable {
        let name: LocalizedName
        let category: Category
        let anchorId: UUID
        let hours: String?
        let phone: String?
        let website: URL?
        // let validity: Temporality?
        let corelationId: UUID?
    }

    enum Category: String, Codable {
        case publiclibrary
    }
}
