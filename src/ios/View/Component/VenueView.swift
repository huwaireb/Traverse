@_spi(Experimental) import MapboxMaps
import SwiftUI

struct VenueView: View {
    @State private var viewModel: VenueViewModel
    @Binding private var viewport: Viewport
    @Binding private var rootViewModel: RootViewModel

    init(
        imdfData: DecodedIMDF,
        viewport: Binding<Viewport>,
        rootViewModel: Binding<RootViewModel>
    ) {
        _viewModel = State(wrappedValue: VenueViewModel(imdfData: imdfData))
        self._viewport = viewport
        self._rootViewModel = rootViewModel
    }

    var body: some View {
        Map(viewport: $viewport) {
            if let venuePolygon = viewModel.venuePolygon {
                PolygonAnnotation(
                    id: viewModel.venue.id.uuidString,
                    polygon: venuePolygon
                )
                .fillColor(.blue)
                .fillOpacity(0.3)
            }

            ForEvery(viewModel.buildings, id: \.id) { building in
                if let polygon = building.geometry?.asPolygon {
                    PolygonAnnotation(
                        id: building.id.uuidString,
                        polygon: polygon
                    )
                    .fillColor(.yellow)
                    .fillOpacity(0.5)
                }
            }

            ForEvery(viewModel.visibleUnits, id: \.id) { unit in
                if let polygon = unit.geometry?.asPolygon,
                    viewModel.isUnitOnSelectedLevel(unit)
                {
                    PolygonAnnotation(
                        id: unit.id.uuidString,
                        polygon: polygon
                    )
                    .fillColor(.green)
                    .fillOpacity(0.4)
                }
            }

            ForEvery(viewModel.buildingAnnotations, id: \.id) { annotation in
                PointAnnotation(
                    id: annotation.id,
                    coordinate: annotation.coordinate
                )
                .iconImage("dest-pin")
                .iconAnchor(.bottom)
                .iconOffset(x: 0, y: 12)

                MapViewAnnotation(coordinate: annotation.coordinate) {
                    AnnotationView(
                        title: annotation.title,
                        levels: annotation.levels,
                        selectedLevel: $viewModel.selectedLevel,
                        onClose: {
                            viewModel.removeAnnotation(withId: annotation.id)
                        }
                    )
                    .frame(width: 200, height: 60)
                }
            }

            ForEvery(viewModel.amenities, id: \.id) { amenity in
                if let coordinate = viewModel.getAmenityCoordinate(amenity) {
                    PointAnnotation(
                        id: amenity.id.uuidString,
                        coordinate: coordinate
                    )
                    .iconImage("dest-pin")
                    .iconSize(0.8)
                    .iconAnchor(.bottom)
                    .iconOffset(x: 0, y: 12)
                }
            }

            ForEvery(viewModel.openingAnnotations, id: \.id) { opening in
                if let lineString = opening.lineString {
                    PolylineAnnotation(
                        lineString: lineString
                    )
                    .lineColor(.red)
                    .lineWidth(3)
                }
            }

            PointAnnotation(
                id: "start-point",
                coordinate: CLLocationCoordinate2D(
                    latitude: 25.091397,
                    longitude: 55.155822
                )
            )
            .image(.init(image: UIImage(named: "dest-pin")!, name: "dest-pin"))
            .iconSize(1.2)
            .iconAnchor(.bottom)
            .iconOffset(x: 0, y: 12)


            
            PolylineAnnotation(lineCoordinates: [
                CLLocationCoordinate2D(
                    latitude: 55.157240840765525,
                    longitude: 25.091279230579843
                ),
                CLLocationCoordinate2D(
                    latitude: 55.156877331839695,
                    longitude: 25.091261467675423
                ),
                CLLocationCoordinate2D(
                    latitude: 55.15688386976953,
                    longitude: 25.09130173025555
                ),
            ])
            .lineColor(.white)
            .lineWidth(30)
        }
        .mapStyle(.standardSatellite(lightPreset: .day))
        .onAppear {
            viewModel.loadMap()
        }
    }
}
