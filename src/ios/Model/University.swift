import struct CoreLocation.CLLocationCoordinate2D
import struct MapboxMaps.Polygon
import struct MapboxMaps.Viewport

enum University: String, CaseIterable, Identifiable {
    case aud = "AUD"

    var id: String { rawValue }

    var name: String {
        switch self {
        case .aud: return "American University in Dubai"
        }
    }

    var viewport: Viewport {
        switch self {
        case .aud: return .americanUniversityDubai
        }
    }

    var isEnabled: Bool { true }
}

extension Viewport {
    static let americanUniversityDubai = Viewport.overview(
        geometry:
            Polygon([
                [
                    CLLocationCoordinate2D(
                        latitude: 25.091570308206983,
                        longitude: 55.15364503416242
                    ),
                    CLLocationCoordinate2D(
                        latitude: 25.089541323607833,
                        longitude: 55.15563389280547
                    ),
                    CLLocationCoordinate2D(
                        latitude: 25.091379595682596,
                        longitude: 55.15790353149154
                    ),
                    CLLocationCoordinate2D(
                        latitude: 25.0934190240756,
                        longitude: 55.155797802942004
                    ),
                    CLLocationCoordinate2D(
                        latitude: 25.091570308206983,
                        longitude: 55.15364503416242
                    ),
                ]
            ]),
        bearing: 319.049,
        pitch: 0.0,
        geometryPadding: .init(
            top: 59.0,
            leading: 0.0,
            bottom: 34.0,
            trailing: 0.0
        ),
        maxZoom: 16.271
    )

    static let nyuAbuDhabi = Viewport.camera(
        center: CLLocationCoordinate2D(latitude: 24.5239, longitude: 54.4347),
        zoom: 15,
        bearing: 0,
        pitch: 0
    )
    static let heriotWattUniversity = Viewport.camera(
        center: CLLocationCoordinate2D(latitude: 25.1341, longitude: 55.3023),
        zoom: 15,
        bearing: 0,
        pitch: 0
    )
}
