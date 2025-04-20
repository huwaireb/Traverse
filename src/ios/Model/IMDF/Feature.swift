import Foundation
import Turf

enum IMDFError: Error {
    case invalidType
    case invalidData
}

enum AccessibilityProperty: String, Codable {
    case assistedListening = "assisted.listening"
    case braille = "braille"
    case hearing = "hearing"
    case hearingLoop = "hearingloop"
    case signlangInterpreter = "signlanginterpreter"
    case tactilePaving = "tactilepaving"
    case tdd = "tdd"
    case trs = "trs"
    case volume = "volume"
    case wheelchair = "wheelchair"
}

enum RestrictionCategory: String, Codable {
    case employeesOnly = "employeesOnly"
    case restricted = "restricted"
}

enum AccessControlCategory: String, Codable {
    case badgeReader = "badgereader"
    case fingerPrintReader = "fingerprintreader"
    case `guard` = "guard"
    case keyAccess = "keyaccess"
    case outOfService = "outofservice"
    case passwordAccess = "passwordaccess"
    case retinaScanner = "retinascanner"
    case voiceRecognition = "voicerecognition"
}

enum FeatureType: String, Codable {
    case address = "address"
    case anchor = "anchor"
    case building = "building"
    case detail = "detail"
    case fixture = "fixture"
    case footprint = "footprint"
    case geofence = "geofence"
    case kiosk = "kiosk"
    case level = "level"
    case manifest = "manifest"
    case occupant = "occupant"
    case opening = "opening"
    case relationship = "relationship"
    case section = "section"
    case unit = "unit"
    case venue = "venue"
    case amenity = "amenity"
}

class Feature<Properties: Codable>: NSObject, IMDFDecodableFeature {
    let id: UUID
    let properties: Properties
    let geometry: Geometry?

    required init(feature: Turf.Feature) throws {
        guard let idString = feature.identifier?.string,
            let idUUID = UUID(uuidString: idString)
        else {
            throw IMDFError.invalidData
        }

        self.id = idUUID
        self.geometry = feature.geometry

        if let propertiesData = try? JSONEncoder().encode(
            feature.properties
        ) {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.properties = try decoder.decode(
                Properties.self,
                from: propertiesData
            )
        } else {
            throw IMDFError.invalidData
        }
    }
}

struct FeatureReference: Codable {
    let id: String
    let featureType: FeatureType
}

struct LocalizedName: Codable {
    private let localizations: [String: String]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.localizations = try container.decode([String: String].self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(localizations)
    }

    var bestLocalizedValue: String? {
        for languageCode in NSLocale.preferredLanguages {
            if let localizedValue = localizations[languageCode] {
                return localizedValue
            }
        }
        return localizations["en"]
    }
}

struct DisplayPoint: Codable {
    let type: String
    let coordinates: [Double]
}

struct Door: Codable {
    let type: Kind?
    let automatic: Bool?
    let material: Material?

    enum Kind: String, Codable {
        case door = "door"
        case movablePartition = "movablepartition"
        case open = "open"
        case revolving = "revolving"
        case shutter = "shutter"
        case sliding = "sliding"
        case swinging = "swinging"
        case turnstile = "turnstile"
        case turnstileFullheight = "turnstile.fullheight"
        case turnstileWaistheight = "turnstile.waistheight"
        case unspecified = "unspecified"
    }

    enum Material: String, Codable {
        case wood = "wood"
        case glass = "glass"
        case metal = "metal"
        case gate = "gate"
    }
}
