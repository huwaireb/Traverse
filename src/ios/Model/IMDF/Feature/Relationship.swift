import struct Foundation.UUID

class Relationship: Feature<Relationship.Properties> {
    struct Properties: Codable {
        let category: String
        let direction: Direction
        let origin: UUID?
        let intermediary: UUID?
        let destination: UUID?
        let hours: String?
    }

    enum Direction: String, Codable {
        case directed = "directed"
        case undirected = "undirected"
    }
}
