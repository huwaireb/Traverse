class Section: Feature<Section.Properties> {
    struct Properties: Codable {
        let category: Category
        let restriction: RestrictionCategory
    }

    enum Category: String, Codable {
        case walkway = "walkway"
    }
}
