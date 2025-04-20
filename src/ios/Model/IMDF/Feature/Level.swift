import struct Foundation.UUID

class Level: Feature<Level.Properties> {
    struct Properties: Codable {
        let category: Category
        let restriction: RestrictionCategory?
        let outdoor: Bool
        let ordinal: Int
        let name: LocalizedName
        let shortName: LocalizedName
        let displayPoint: DisplayPoint?
        let addressId: UUID?
        let buildingIds: [UUID]?
    }

    enum Category: String, Codable {
        case arrivals = "arrivals"
        case arrivalsDomestic = "arrivals.domestic"
        case arrivalsIntl = "arrivals.intl"
        case departures = "departures"
        case departuresDomestic = "departures.domestic"
        case departuresIntl = "departures.intl"
        case parking = "parking"
        case transit = "transit"
        case unspecified = "unspecified"
    }
}
