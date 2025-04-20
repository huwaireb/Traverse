import CoreLocation
import Foundation
import MapboxMaps
import SwiftUI

@MainActor
@Observable
class RootViewModel {
    var universities: [University] = University.allCases.filter { $0.isEnabled }
    var venues: [University: DecodedIMDF] = [:]
    var selectedUniversity: University?
    var searchText: String = ""
    var navigationPath: [LocationRoute] = []
    var selectedDetent: PresentationDetent = .trSmall
    var isLoading = false
    var error: Error?
    var currentPath: [CLLocationCoordinate2D]?
    let navigationManager: NavigationManager

    private let venuePaths: [University: String] = [
        .aud: Bundle.main.path(forResource: "AUD", ofType: "imdf")!
    ]

    var filteredLocations: [any CampusLocation] {
        guard let selectedUniversity = selectedUniversity else { return [] }
        let allLocations = campusLocations(for: selectedUniversity)
        if searchText.isEmpty { return allLocations }
        return allLocations.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    init() {
        self.navigationManager = NavigationManager()
        Task { await loadVenues() }
    }

    func loadVenues() async {
        isLoading = true
        error = nil
        venues = [:]

        let decoder = IMDFDecoder()
        for university in universities {
            guard let path = venuePaths[university] else {
                print("No IMDF path for \(university.name)")
                continue
            }
            do {
                let imdfData = try decoder.decode(URL(fileURLWithPath: path))
                venues[university] = imdfData
                initializeNavigationGraph(for: imdfData, university: university)
            } catch {
                print("Failed to decode venue for \(university.name): \(error)")
                self.error = error
            }
        }

        isLoading = false
    }

    func selectUniversity(_ university: University?) {
        selectedUniversity = university
        navigationPath = []
        selectedDetent = .trSmall
        currentPath = nil
    }

    func navigateToLocation(_ location: LocationRoute) {
        navigationPath = [location]
        let targetDetent = PresentationDetent.trMedium
        if selectedDetent > targetDetent {
            print(
                "Keeping detent \(selectedDetent) as it is larger than \(targetDetent)"
            )
        } else {
            selectedDetent = targetDetent
        }

        print("Navigating to location: \(location.location.name)")
        if location.location.name.lowercased() == "entrance a" {
            currentPath = computePath(
                from: "737220f5-9b8f-4ca6-b2fb-cd0b9731c51b",
                to: "428d90ea-0cae-4861-b8b7-087c57c35848"
            )
        } else {
            currentPath = computePath(from: "Start", to: location.location.name)
        }
    }

    func computePath(from sourceId: String, to destinationId: String)
        -> [CLLocationCoordinate2D]?
    {
        print("Computing path from \(sourceId) to \(destinationId)")
        let path = navigationManager.getShortestPath(
            from: sourceId,
            to: destinationId
        )
        if path == nil {
            print("Failed to compute path from \(sourceId) to \(destinationId)")
        } else {
            print(
                "Path computed: \(path?.map { "\($0.latitude), \($0.longitude)" }.joined(separator: " -> ") ?? "")"
            )
        }
        return path
    }

    func campusLocations(for university: University?) -> [any CampusLocation] {
        guard let university = university,
            let imdfData = venues[university]
        else { return [] }
        var locations: [any CampusLocation] = []

        locations += imdfData.buildings.values.map {
            BuildingLocation(building: $0, university: university)
        }

        let amenityUnitIds = imdfData.amenities.values.flatMap {
            $0.properties.unitIds
        }
        locations += imdfData.units.values
            .filter { !amenityUnitIds.contains($0.id) }
            .map {
                RoomLocation(
                    unit: $0,
                    level: imdfData.level(for: $0.properties.levelId),
                    university: university,
                    imdfData: imdfData
                )
            }

        locations += imdfData.openings.values.map {
            EntranceLocation(
                opening: $0,
                level: imdfData.level(for: $0.properties.levelId),
                university: university,
                imdfData: imdfData
            )
        }

        locations += imdfData.amenities.values.map {
            let level = $0.properties.unitIds.first
                .flatMap { imdfData.unit(for: $0) }
                .flatMap { imdfData.level(for: $0.properties.levelId) }
            return AmenityLocation(
                amenity: $0,
                level: level,
                university: university,
                imdfData: imdfData
            )
        }

        return locations.sorted { $0.name < $1.name }
    }

    private func haversineDistance(
        _ coord1: CLLocationCoordinate2D,
        _ coord2: CLLocationCoordinate2D
    ) -> Double {
        let R = 6371000.0  // Earth radius in meters
        let lat1 = coord1.latitude * .pi / 180
        let lat2 = coord2.latitude * .pi / 180
        let dLat = lat2 - lat1
        let dLon = (coord2.longitude - coord1.longitude) * .pi / 180
        let a =
            sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2)
            * sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        return R * c
    }

    private func initializeNavigationGraph(
        for imdfData: DecodedIMDF,
        university: University
    ) {

        // Add fixed nodes
        let startCoord = CLLocationCoordinate2D(
            latitude: 25.091397,
            longitude: 55.155822
        )
        let endCoord = CLLocationCoordinate2D(
            latitude: 25.092397,
            longitude: 55.156822
        )
        navigationManager.addNode(name: "Start", coordinate: startCoord)
        navigationManager.addNode(name: "End", coordinate: endCoord)
        print("Added fixed nodes: Start at \(startCoord), End at \(endCoord)")

        // Add building nodes
        for building in imdfData.buildings.values {
            let coordinate = CLLocationCoordinate2D(
                latitude: building.properties.displayPoint.coordinates[1],
                longitude: building.properties.displayPoint.coordinates[0]
            )
            navigationManager.addNode(
                name: building.id.uuidString,
                coordinate: coordinate
            )
            let weight = haversineDistance(startCoord, coordinate)
            navigationManager.addEdge(
                from: "Start",
                to: building.id.uuidString,
                weight: weight
            )
            print(
                "Added building node: \(building.id.uuidString) at \(coordinate)"
            )
        }

        // Add opening nodes
        for opening in imdfData.openings.values {
            if let coordinate = getOpeningCoordinate(opening) {
                let name =
                    opening.properties.name?.bestLocalizedValue
                    ?? opening.id.uuidString
                navigationManager.addNode(
                    name: opening.id.uuidString,
                    coordinate: coordinate
                )
                let weight = haversineDistance(startCoord, coordinate)
                navigationManager.addEdge(
                    from: "Start",
                    to: opening.id.uuidString,
                    weight: weight
                )
                print(
                    "Added opening node: \(name) (\(opening.id.uuidString)) at \(coordinate)"
                )
            } else {
                print(
                    "Skipped opening node \(opening.id.uuidString): no coordinate"
                )
            }
        }

        // Add unit nodes (e.g., restrooms)
        for unit in imdfData.units.values {
            if unit.properties.category == .restroom,
                let centroid = unit.geometry?.asPolygon?.centroid
            {
                navigationManager.addNode(
                    name: unit.id.uuidString,
                    coordinate: centroid
                )

                // Connect to Entrance A
                if let entranceA = imdfData.openings.values.first(where: {
                    $0.id.uuidString == "737220f5-9b8f-4ca6-b2fb-cd0b9731c51b"
                }),
                    let entranceACoord = getOpeningCoordinate(entranceA)
                {
                    let weight = haversineDistance(entranceACoord, centroid)
                    navigationManager.addEdge(
                        from: entranceA.id.uuidString,
                        to: unit.id.uuidString,
                        weight: weight
                    )
                    navigationManager.addEdge(
                        from: unit.id.uuidString,
                        to: entranceA.id.uuidString,
                        weight: weight
                    )  // Bidirectional
                    print(
                        "Added edge: \(entranceA.id.uuidString) <-> \(unit.id.uuidString), weight: \(weight)"
                    )
                } else {
                    print(
                        "Failed to connect unit \(unit.id.uuidString) to Entrance A: Entrance A not found"
                    )
                }
            } else {
                print(
                    "Skipped unit \(unit.id.uuidString): \(unit.properties.category != .restroom ? "Not a restroom" : "Missing polygon")"
                )
            }
        }

        // Add amenity nodes
        for amenity in imdfData.amenities.values {
            if let coordinate = getAmenityCoordinate(amenity) {
                navigationManager.addNode(
                    name: amenity.id.uuidString,
                    coordinate: coordinate
                )
                let weight = haversineDistance(startCoord, coordinate)
                navigationManager.addEdge(
                    from: "Start",
                    to: amenity.id.uuidString,
                    weight: weight
                )
                print(
                    "Added amenity node: \(amenity.id.uuidString) at \(coordinate)"
                )
            } else {
                print(
                    "Skipped amenity node \(amenity.id.uuidString): no coordinate"
                )
            }
        }

        navigationManager.addEdge(
            from: "Start",
            to: "End",
            weight: haversineDistance(startCoord, endCoord)
        )
        print("Added edge: Start <-> End")

        // Debug graph
        navigationManager.debugGraph()
    }

    private func getAmenityCoordinate(_ amenity: Amenity)
        -> CLLocationCoordinate2D?
    {
        return amenity.geometry?.point?.coordinates
    }

    private func getOpeningCoordinate(_ opening: Opening)
        -> CLLocationCoordinate2D?
    {
        if let point = opening.geometry?.point?.coordinates {
            print(
                "Opening \(opening.id.uuidString) using point: \(point.latitude), \(point.longitude)"
            )
            return point
        } else if let lineString = opening.geometry?.lineString,
            let first = lineString.coordinates.first
        {
            print(
                "Opening \(opening.id.uuidString) using linestring first: \(first.latitude), \(first.longitude)"
            )
            return first
        }
        print("Opening \(opening.id.uuidString) has no valid geometry")
        return nil
    }
}

extension PresentationDetent: Comparable {
    public static func < (lhs: PresentationDetent, rhs: PresentationDetent)
        -> Bool
    {
        switch (lhs, rhs) {
        case (.trSmall, .trMedium), (.trSmall, .trFull), (.trMedium, .trFull):
            return true
        default:
            return false
        }
    }
}
