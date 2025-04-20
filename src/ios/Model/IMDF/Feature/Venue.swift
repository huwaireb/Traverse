import Foundation
import MapboxMaps

class Venue: Feature<Venue.Properties> {
    struct Properties: Codable {
        let category: Category
        let restriction: RestrictionCategory?
        let name: LocalizedName
        let altName: LocalizedName?
        let hours: String?
        let website: String?
        let phone: String?
        let addressId: UUID?
        let displayPoint: DisplayPoint
    }

    enum Category: String, Codable {
        case university
        case parkingfacility
    }
}
