import Foundation
import MapboxMaps

class Unit: Feature<Unit.Properties> {
    struct Properties: Codable {
        let category: Category
        let restriction: RestrictionCategory?
        let accessibility: [AccessibilityProperty]?
        let name: LocalizedName?
        let altName: LocalizedName?
        let levelId: UUID
        let displayPoint: DisplayPoint?
    }

    enum Category: String, Codable {
        case classroom
        case lounge
        case parking
        case walkway
        case laboratory
        case office
        case restroom
    }
}
