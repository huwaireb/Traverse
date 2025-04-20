import Foundation
import MapboxMaps
import Turf
import ZIPFoundation

protocol IMDFDecodableFeature {
    init(feature: Turf.Feature) throws
}

extension FeatureType {
    var filename: String { "\(self).geojson" }
}

struct DecodedIMDF {
    let manifest: Manifest
    let venue: Venue
    let addresses: [UUID: Address]
    let levels: [UUID: Level]
    let units: [UUID: Unit]
    let footprints: [UUID: Footprint]
    let relationships: [UUID: Relationship]
    let anchors: [UUID: Anchor]
    let sections: [UUID: Section]
    let buildings: [UUID: Building]
    let occupants: [UUID: Occupant]
    let amenities: [UUID: Amenity]
    let openings: [UUID: Opening]

    func level(for id: UUID) -> Level? { levels[id] }
    func unit(for id: UUID) -> Unit? { units[id] }
    func building(for id: UUID) -> Building? { buildings[id] }
    func amenity(for id: UUID) -> Amenity? { amenities[id] }
    func address(for id: UUID?) -> Address? { id.flatMap { addresses[$0] } }
    func units(forLevelId id: UUID) -> [Unit] {
        units.values.filter { $0.properties.levelId == id }.sorted {
            $0.id.uuidString < $1.id.uuidString
        }
    }
    func amenities(forUnitIds ids: [UUID]) -> [Amenity] {
        amenities.values.filter { amenity in
            amenity.properties.unitIds.contains { ids.contains($0) }
        }.sorted { $0.id.uuidString < $1.id.uuidString }
    }
}

class IMDFDecoder {
    let decoder = JSONDecoder()

    func decode(_ imdfDirectory: URL) throws -> DecodedIMDF {
        let archive = IMDFArchive(directory: imdfDirectory)

        print("decoding manifest")
        let manifest = try decodeManifest(from: archive)
        print("decoding venue")

        let venues = try decodeFeatures(
            Venue.self,
            from: .venue,
            in: archive,
            optional: false
        )

        print("decoded")

        print(venues.count)

        guard venues.count == 1 else {
            throw IMDFError.invalidData
        }

        let venue = venues[0]

        let addresses = try decodeFeatures(
            Address.self,
            from: .address,
            in: archive,
            optional: false
        )
        .reduce(into: [UUID: Address]()) { $0[$1.id] = $1 }

        let levels = try decodeFeatures(Level.self, from: .level, in: archive)
            .reduce(into: [UUID: Level]()) { $0[$1.id] = $1 }

        let units = try decodeFeatures(Unit.self, from: .unit, in: archive)
            .reduce(into: [UUID: Unit]()) { $0[$1.id] = $1 }

        let footprints = try decodeFeatures(
            Footprint.self,
            from: .footprint,
            in: archive
        )
        .reduce(into: [UUID: Footprint]()) { $0[$1.id] = $1 }

        let relationships = try decodeFeatures(
            Relationship.self,
            from: .relationship,
            in: archive
        )
        .reduce(into: [UUID: Relationship]()) { $0[$1.id] = $1 }

        let anchors = try decodeFeatures(
            Anchor.self,
            from: .anchor,
            in: archive
        )

        .reduce(into: [UUID: Anchor]()) { $0[$1.id] = $1 }

        let sections = try decodeFeatures(
            Section.self,
            from: .section,
            in: archive
        )
        .reduce(into: [UUID: Section]()) { $0[$1.id] = $1 }

        let buildings = try decodeFeatures(
            Building.self,
            from: .building,
            in: archive
        )
        .reduce(into: [UUID: Building]()) { $0[$1.id] = $1 }

        let occupants = try decodeFeatures(
            Occupant.self,
            from: .occupant,
            in: archive
        )
        .reduce(into: [UUID: Occupant]()) { $0[$1.id] = $1 }

        let amenities = try decodeFeatures(
            Amenity.self,
            from: .amenity,
            in: archive
        )
        .reduce(into: [UUID: Amenity]()) { $0[$1.id] = $1 }

        let openings = try decodeFeatures(
            Opening.self,
            from: .opening,
            in: archive
        )
        .reduce(into: [UUID: Opening]()) { $0[$1.id] = $1 }

        return DecodedIMDF(
            manifest: manifest,
            venue: venue,
            addresses: addresses,
            levels: levels,
            units: units,
            footprints: footprints,
            relationships: relationships,
            anchors: anchors,
            sections: sections,
            buildings: buildings,
            occupants: occupants,
            amenities: amenities,
            openings: openings
        )
    }

    private func decodeManifest(from archive: IMDFArchive) throws -> Manifest {
        let file = archive.fileURLForManifest()
        guard FileManager.default.fileExists(atPath: file.path) else {
            throw IMDFError.invalidData
        }
        let data = try Data(contentsOf: file)
        return try decoder.decode(Manifest.self, from: data)
    }

    private func decodeFeatures<T: IMDFDecodableFeature>(
        _ type: T.Type,
        from feature: FeatureType,
        in archive: IMDFArchive,
        optional: Bool = true
    ) throws -> [T] {
        let fileURL = archive.fileURL(for: feature)
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            if optional {
                return []
            }
            throw IMDFError.invalidData
        }
        let data = try Data(contentsOf: fileURL)
        let geojson = try decoder.decode(GeoJSONObject.self, from: data)
        guard case .featureCollection(let collection) = geojson else {
            throw IMDFError.invalidType
        }

        return try collection.features.map { try T.init(feature: $0) }
    }

    private struct IMDFArchive {
        let baseDirectory: URL

        init(directory: URL) {
            let fileManager = FileManager.default
            if directory.pathExtension.lowercased() == "imdf" {
                let tempDir = fileManager.temporaryDirectory
                    .appendingPathComponent(UUID().uuidString)
                do {
                    try fileManager.createDirectory(
                        at: tempDir,
                        withIntermediateDirectories: true
                    )
                    try fileManager.unzipItem(at: directory, to: tempDir)
                    baseDirectory = tempDir
                } catch {
                    fatalError("Failed to unzip IMDF archive: \(error)")
                }
            } else {
                baseDirectory = directory
            }
        }

        func fileURLForManifest() -> URL {
            baseDirectory.appendingPathComponent("manifest.json")
        }

        func fileURL(for file: FeatureType) -> URL {
            baseDirectory.appendingPathComponent(file.filename)
        }
    }
}
