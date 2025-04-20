import struct Foundation.UUID

class Footprint: Feature<Footprint.Properties> {
    struct Properties: Codable {
        let category: Category
        let name: LocalizedName?
        let buildingIds: [UUID]
    }

    enum Category: String, Codable {
        case aerial = "aerial"
        case ground = "ground"
        case subterranean = "subterranean"
    }
}
