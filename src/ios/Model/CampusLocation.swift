import CoreLocation
import Foundation
import SwiftUI
import Turf

// MARK: - Shared Types
struct PeakTime: Identifiable {
    let id = UUID()
    let day: String
    let hour: String
    let busyness: BusynessLevel
}

enum BusynessLevel: Int {
    case low = 1
    case medium = 2
    case high = 3

    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .red
        }
    }
}

struct TimeColors {
    let foreground: Color
    let background: Color
}

// MARK: - Display Struct for Navigation Sheet
struct CampusLocationDisplay {
    let id: UUID
    let name: String
    let iconName: String
    let building: String
    let buildingAltName: String
    let level: String
    let levelShortName: String
    let description: String
    let isWheelchairAccessible: Bool
    let timeToReach: String?
    let distanceInMeters: Int?
    let currentBusyness: BusynessLevel
    let peakTimes: [PeakTime]
    let timeColors: TimeColors
    let coordinate: CLLocationCoordinate2D?
}

// MARK: - Protocol with Common Fields
protocol CampusLocation: Identifiable, Equatable, Hashable {
    var id: UUID { get }
    var name: String { get }
    var university: University { get }
    var coordinate: CLLocationCoordinate2D? { get }
    func toDisplay() -> CampusLocationDisplay
}

extension CampusLocation {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Self, rhs: any CampusLocation) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Building Location
struct BuildingLocation: CampusLocation {
    let id: UUID
    let name: String
    let university: University
    let coordinate: CLLocationCoordinate2D?

    init(building: Building, university: University) {
        self.id = building.id
        self.name =
            building.properties.name?.bestLocalizedValue ?? "Unknown Building"
        self.university = university
        self.coordinate = getCoordinate(from: building.geometry)
    }

    func toDisplay() -> CampusLocationDisplay {
        CampusLocationDisplay(
            id: id,
            name: name,
            iconName: "building",
            building: "",
            buildingAltName: "",  // Use alt_name in locationRow
            level: "",
            levelShortName: "",
            description: "Main building at \(university.name).",
            isWheelchairAccessible: false,  // Placeholder: No accessibility in building.json
            timeToReach: nil,
            distanceInMeters: nil,
            currentBusyness: .low,
            peakTimes: [
                PeakTime(
                    day: "Mon-Fri",
                    hour: "10:00–12:00",
                    busyness: .medium
                ),
                PeakTime(day: "Mon-Fri", hour: "14:00–16:00", busyness: .high),
            ],
            timeColors: TimeColors(foreground: .white, background: .blue),
            coordinate: coordinate
        )
    }
}

// MARK: - Room Location (Unit)
struct RoomLocation: CampusLocation {
    let id: UUID
    let name: String
    let university: University
    let coordinate: CLLocationCoordinate2D?
    let building: String
    let buildingAltName: String
    let level: String
    let levelShortName: String
    let isWheelchairAccessible: Bool
    let timeToReach: String?
    let distanceInMeters: Int?

    init(
        unit: Unit,
        level: Level?,
        university: University,
        imdfData: DecodedIMDF
    ) {
        self.id = unit.id
        self.name = unit.properties.name?.bestLocalizedValue ?? "Unknown Room"
        self.university = university
        self.coordinate = getCoordinate(from: unit.geometry)
        let building = level?.properties.buildingIds?.first
            .flatMap { imdfData.building(for: $0) }
        self.building =
            building?.properties.name?.bestLocalizedValue
            ?? "Building \(university.rawValue)"
        self.buildingAltName =
            building?.properties.altName?.bestLocalizedValue ?? ""
        self.level =
            level?.properties.name.bestLocalizedValue
            ?? "Level \(level?.properties.ordinal ?? 0)"
        self.levelShortName =
            level?.properties.shortName.bestLocalizedValue
            ?? "\(level?.properties.ordinal ?? 0)"
        self.isWheelchairAccessible =
            unit.properties.accessibility?.contains(.wheelchair) != nil || false
        self.timeToReach = "5 min"  // Fake data
        self.distanceInMeters = 100  // Fake data
    }

    func toDisplay() -> CampusLocationDisplay {
        CampusLocationDisplay(
            id: id,
            name: name,
            iconName: "cube",
            building: building,
            buildingAltName: buildingAltName,
            level: level,
            levelShortName: levelShortName,
            description: "\(name) at \(university.name).",
            isWheelchairAccessible: isWheelchairAccessible,
            timeToReach: timeToReach,
            distanceInMeters: distanceInMeters,
            currentBusyness: .low,
            peakTimes: [
                PeakTime(
                    day: "Mon-Fri",
                    hour: "10:00–12:00",
                    busyness: .medium
                ),
                PeakTime(day: "Mon-Fri", hour: "14:00–16:00", busyness: .high),
            ],
            timeColors: TimeColors(foreground: .white, background: .blue),
            coordinate: coordinate
        )
    }
}

// MARK: - Entrance Location (Opening)
struct EntranceLocation: CampusLocation {
    let id: UUID
    let name: String
    let university: University
    let coordinate: CLLocationCoordinate2D?
    let building: String
    let buildingAltName: String
    let level: String
    let levelShortName: String
    let isWheelchairAccessible: Bool
    let timeToReach: String?
    let distanceInMeters: Int?

    init(
        opening: Opening,
        level: Level?,
        university: University,
        imdfData: DecodedIMDF
    ) {
        self.id = opening.id
        self.name =
            opening.properties.name?.bestLocalizedValue
            ?? opening.properties.category.rawValue.capitalized
        self.university = university
        self.coordinate = getCoordinate(from: opening.geometry)
        let building = level?.properties.buildingIds?.first
            .flatMap { imdfData.building(for: $0) }
        self.building =
            building?.properties.name?.bestLocalizedValue
            ?? "Building \(university.rawValue)"
        self.buildingAltName =
            building?.properties.altName?.bestLocalizedValue ?? ""
        self.level =
            level?.properties.name.bestLocalizedValue
            ?? "Level \(level?.properties.ordinal ?? 0)"
        self.levelShortName =
            level?.properties.shortName.bestLocalizedValue
            ?? "\(level?.properties.ordinal ?? 0)"
        self.isWheelchairAccessible =
            opening.properties.accessibility?.contains(.wheelchair) != nil
            || false
        self.timeToReach = "3 min"  // Fake data
        self.distanceInMeters = 50  // Fake data
    }

    func toDisplay() -> CampusLocationDisplay {
        CampusLocationDisplay(
            id: id,
            name: name,
            iconName: "door.right.hand.open",
            building: building,
            buildingAltName: buildingAltName,
            level: level,
            levelShortName: levelShortName,
            description: "Entrance at \(university.name).",
            isWheelchairAccessible: isWheelchairAccessible,
            timeToReach: timeToReach,
            distanceInMeters: distanceInMeters,
            currentBusyness: .low,
            peakTimes: [
                PeakTime(
                    day: "Mon-Fri",
                    hour: "10:00–12:00",
                    busyness: .medium
                ),
                PeakTime(day: "Mon-Fri", hour: "14:00–16:00", busyness: .high),
            ],
            timeColors: TimeColors(foreground: .white, background: .blue),
            coordinate: coordinate
        )
    }
}

// MARK: - Amenity Location
struct AmenityLocation: CampusLocation {
    let id: UUID
    let name: String
    let university: University
    let coordinate: CLLocationCoordinate2D?
    let building: String
    let buildingAltName: String
    let level: String
    let levelShortName: String
    let isWheelchairAccessible: Bool
    let timeToReach: String?
    let distanceInMeters: Int?

    init(
        amenity: Amenity,
        level: Level?,
        university: University,
        imdfData: DecodedIMDF
    ) {
        self.id = amenity.id
        self.name =
            amenity.properties.name?.bestLocalizedValue
            ?? amenity.properties.category.rawValue.capitalized
        self.university = university
        self.coordinate = getCoordinate(from: amenity.geometry)
        let building = level?.properties.buildingIds?.first
            .flatMap { imdfData.building(for: $0) }
        self.building =
            building?.properties.name?.bestLocalizedValue
            ?? "Building \(university.rawValue)"
        self.buildingAltName =
            building?.properties.altName?.bestLocalizedValue ?? ""
        self.level =
            level?.properties.name.bestLocalizedValue
            ?? "Level \(level?.properties.ordinal ?? 0)"
        self.levelShortName =
            level?.properties.shortName.bestLocalizedValue
            ?? "\(level?.properties.ordinal ?? 0)"
        self.isWheelchairAccessible =
            amenity.properties.accessibility?.contains(
                .wheelchair
            ) != nil || false
        self.timeToReach = "4 min"  // Fake data
        self.distanceInMeters = 75  // Fake data
    }

    func toDisplay() -> CampusLocationDisplay {
        CampusLocationDisplay(
            id: id,
            name: name,
            iconName: "toilet",
            building: building,
            buildingAltName: buildingAltName,
            level: level,
            levelShortName: levelShortName,
            description: "\(name) at \(university.name).",
            isWheelchairAccessible: isWheelchairAccessible,
            timeToReach: timeToReach,
            distanceInMeters: distanceInMeters,
            currentBusyness: .low,
            peakTimes: [
                PeakTime(
                    day: "Mon-Fri",
                    hour: "10:00–12:00",
                    busyness: .medium
                ),
                PeakTime(day: "Mon-Fri", hour: "14:00–16:00", busyness: .high),
            ],
            timeColors: TimeColors(foreground: .white, background: .blue),
            coordinate: coordinate
        )
    }
}

// MARK: - Navigation Route Enum
enum LocationRoute: Hashable {
    case building(BuildingLocation)
    case room(RoomLocation)
    case entrance(EntranceLocation)
    case amenity(AmenityLocation)

    init(_ location: any CampusLocation) {
        switch location {
        case let loc as BuildingLocation:
            self = .building(loc)
        case let loc as RoomLocation:
            self = .room(loc)
        case let loc as EntranceLocation:
            self = .entrance(loc)
        case let loc as AmenityLocation:
            self = .amenity(loc)
        default:
            fatalError("Unsupported location type")
        }
    }

    var location: any CampusLocation {
        switch self {
        case .building(let loc): return loc
        case .room(let loc): return loc
        case .entrance(let loc): return loc
        case .amenity(let loc): return loc
        }
    }
}

// MARK: - Helper Functions
private func getCoordinate(from geometry: Geometry?) -> CLLocationCoordinate2D?
{
    switch geometry {
    case .point(let point):
        return point.coordinates
    case .polygon(let polygon):
        return polygon.centroid
    case .lineString(let linestring):
        return linestring.coordinates.first
    default:
        return nil
    }
}
