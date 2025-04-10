import CoreLocation
import MapKit
import SwiftUI

struct Map: View {
    @Binding var selection: MapFeature?

    var body: some View {
        MapKit.Map(
            initialPosition: .camera(
                .init(
                    centerCoordinate: .audCampus,
                    distance: 1560.2978166671044,
                    heading: 316.79702669211,
                    pitch: 0.0
                )
            ),
            bounds: .init(centerCoordinateBounds: .audCampusRegion),
            interactionModes: .all,
            selection: $selection,
        ) {
            Marker("Hi", coordinate: .audCampus)
        }
        .mapStyle(.hybrid(elevation: .realistic))
        .mapFeatureSelectionContent { feature in
            print(feature.coordinate)
            return EmptyMapContent()
        }
    }
}

extension CLLocationCoordinate2D {
    static let audCampus: Self = .init(
        latitude: 25.09194225614878,
        longitude: 55.155550667114056
    )
}

extension MKCoordinateRegion {
    static let audCampusRegion: Self = .init(
        center: CLLocationCoordinate2D(latitude: 25.092, longitude: 55.156),
        span: MKCoordinateSpan(
            latitudeDelta: 0.008280193626831078,
            longitudeDelta: 0.008955682498630324
        )
    )
}

#Preview {
    Map(selection: .constant(nil))
}
