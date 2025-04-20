import struct Foundation.UUID

class Opening: Feature<Opening.Properties> {
    struct Properties: Codable {
        let category: Category
        let accessibility: [AccessibilityProperty]?
        let accessControl: [AccessControlCategory]?
        let door: Door?
        let name: LocalizedName?
        let altName: LocalizedName?
        let displayPoint: DisplayPoint?
        let levelId: UUID
    }

    enum Category: String, Codable {
        case automobile = "automobile"
        case bicycle = "bicycle"
        case emergencyExit = "emergencyexit"
        case pedestrian = "pedestrian"
        case pedestrianPrincipal = "pedestrian.principal"
        case pedestrianTransit = "pedestrian.transit"
        case service = "service"
    }
}
