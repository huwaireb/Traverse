import struct Foundation.UUID

class Amenity: Feature<Amenity.Properties> {
    struct Properties: Codable {
        let category: Category
        let name: LocalizedName?
        let altName: LocalizedName?
        let hours: String?
        let phone: String?
        let website: String?

        let unitIds: [UUID]
        let addressId: UUID?
        let correlationId: UUID?

        let accessibility: [AccessibilityProperty]?
    }

    enum Category: String, Codable {
        case restroom = "restroom"
        case restroomFemale = "restroom.female"
        case restroomMale = "restroom.male"
    }
}
