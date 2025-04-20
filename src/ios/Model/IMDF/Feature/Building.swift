class Building: Feature<Building.Properties> {
    struct Properties: Codable {
        let category: Category
        let restriction: RestrictionCategory?

        let name: LocalizedName?
        let altName: LocalizedName?
        let displayPoint: DisplayPoint
    }

    enum Category: String, Codable {
        case parking = "parking"
        case transit = "transit"
        case transitBus = "transit.bus"
        case transitTrain = "transit.train"
        case unspecified = "unspecified"
    }
}
