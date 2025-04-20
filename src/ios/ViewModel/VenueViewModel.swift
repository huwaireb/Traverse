import MapboxMaps
import SwiftUI

import struct Turf.Polygon

@MainActor
@Observable
class VenueViewModel {
    let imdfData: DecodedIMDF
    var venue: Venue
    var venuePolygon: Polygon?
    var buildings: [Building] = []
    var amenities: [Amenity] = []
    var visibleUnits: [Unit] = []
    var selectedLevel: Level?
    var availableLevels: [Level] = []
    var buildingAnnotations: [BuildingAnnotation] = []
    var openingAnnotations: [OpeningAnnotation] = []
    let markerHeight: CGFloat = 36


    struct BuildingAnnotation: Identifiable {
        let id: String
        let coordinate: CLLocationCoordinate2D
        let title: String
        let levels: [Level]
    }

    struct OpeningAnnotation: Identifiable {
        let id: String
        let lineString: LineString?
    }

    init(imdfData: DecodedIMDF) {
        self.imdfData = imdfData
        self.venue = imdfData.venue
        self.venuePolygon = imdfData.venue.geometry?.asPolygon
        self.buildings = imdfData.buildings.values.sorted {
            $0.id.uuidString < $1.id.uuidString
        }
        self.amenities = imdfData.amenities.values.sorted {
            $0.id.uuidString < $1.id.uuidString
        }
        self.availableLevels = imdfData.levels.values.sorted {
            $0.properties.ordinal < $1.properties.ordinal
        }
        self.selectedLevel = availableLevels.min(by: {
            $0.properties.ordinal < $1.properties.ordinal
        })
        self.visibleUnits =
            selectedLevel.map { imdfData.units(forLevelId: $0.id) } ?? []

        self.buildingAnnotations = buildings.compactMap { building in
            guard let name = building.properties.name?.bestLocalizedValue else {
                print("Building missing name: \(building.id.uuidString)")
                return nil
            }
            let coordinate = CLLocationCoordinate2D(
                latitude: building.properties.displayPoint.coordinates[1],
                longitude: building.properties.displayPoint.coordinates[0]
            )
            let title =
                "Building "
                + name.replacingOccurrences(of: " Building", with: "")
            let levels = imdfData.levels.values.filter {
                $0.properties.buildingIds?.contains(building.id) ?? false
            }.sorted { $0.properties.ordinal < $1.properties.ordinal }
            return BuildingAnnotation(
                id: building.id.uuidString,
                coordinate: coordinate,
                title: title,
                levels: levels
            )
        }

        self.openingAnnotations = imdfData.openings.values.map { opening in
            OpeningAnnotation(
                id: opening.id.uuidString,
                lineString: opening.geometry?.lineString
            )
        }

        for building in buildings {
            if building.geometry?.asPolygon == nil {
                print(
                    "Building missing polygon geometry: \(building.id.uuidString)"
                )
            }
        }

        for amenity in amenities {
            _ = getAmenityCoordinate(amenity)
        }
    }

    func loadMap() {
    }

    func selectLevel(_ level: Level?) {
        withAnimation {
            guard selectedLevel?.id != level?.id else {
                print(
                    "Level already selected: \(level?.properties.name.bestLocalizedValue ?? "None")"
                )
                return
            }
            selectedLevel = level
            visibleUnits = level.map { imdfData.units(forLevelId: $0.id) } ?? []
            print(
                "Updated visible units: \(visibleUnits.count) for level: \(level?.properties.shortName.bestLocalizedValue ?? "None")"
            )
        }
    }

    func removeAnnotation(withId id: String) {
        buildingAnnotations.removeAll { $0.id == id }
    }

    func getAmenityCoordinate(_ amenity: Amenity) -> CLLocationCoordinate2D? {
        let unitIds = amenity.properties.unitIds.map { $0.uuidString }.joined(
            separator: ", "
        )
        print(
            "Processing amenity \(amenity.id.uuidString) (\(amenity.properties.name?.bestLocalizedValue ?? "Unnamed")) with unitIds: [\(unitIds)]"
        )
        if let coordinate = amenity.geometry?.point?.coordinates {
            print(
                "Amenity \(amenity.id.uuidString) using geometry point: \(coordinate.latitude), \(coordinate.longitude)"
            )
            return coordinate
        }
        guard let unitId = amenity.properties.unitIds.first else {
            print("Amenity \(amenity.id.uuidString) missing unit_ids")
            return fallbackCoordinate()
        }
        guard let unit = imdfData.unit(for: unitId) else {
            print(
                "Amenity \(amenity.id.uuidString) unit not found: \(unitId.uuidString)"
            )
            return fallbackCoordinate()
        }
        guard let polygon = unit.geometry?.asPolygon else {
            print(
                "Amenity \(amenity.id.uuidString) unit missing polygon: \(unitId.uuidString)"
            )
            return fallbackCoordinate()
        }
        let centroid = polygon.centroid
        return centroid
    }

    func isUnitOnSelectedLevel(_ unit: Unit) -> Bool {
        guard let selectedLevel else { return true }
        return unit.properties.levelId == selectedLevel.id
    }

    func isAmenityOnSelectedLevel(_ amenity: Amenity) -> Bool {
        guard let selectedLevel else { return true }
        let levelId = amenity.properties.unitIds.first
            .flatMap { imdfData.unit(for: $0) }
            .map { $0.properties.levelId }
        return levelId == selectedLevel.id
    }

    private func fallbackCoordinate() -> CLLocationCoordinate2D? {
        let coordinates = venue.properties.displayPoint.coordinates
        let coord = CLLocationCoordinate2D(
            latitude: coordinates[1],
            longitude: coordinates[0]
        )
        print(
            "Using fallback coordinate: \(coord.latitude), \(coord.longitude)"
        )
        return coord
    }
}
