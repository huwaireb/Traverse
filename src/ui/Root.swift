import CoreLocation
import MapKit
import RoomPlan
import SwiftUI

struct Root: View {
    @State private var markerSelection: MapFeature?
    
    var body: some View {
        Map(selection: $markerSelection).sheet(
            isPresented: .constant(true),
            content: {
                Sheet()
                    .padding(.top, 20)
                    .interactiveDismissDisabled()
                    .presentationDragIndicator(.hidden)
                    .presentationBackgroundInteraction(.enabled)
                    .presentationDetents([
                        .fraction(0.18), .medium, .fraction(0.99),
                    ])

            }
        )
    }
}

#Preview {
    Root()
}
