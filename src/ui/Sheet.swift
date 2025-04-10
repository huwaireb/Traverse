import SwiftUI

struct University: Codable {
    let abbrev: String
    let name: String
}

struct Campus: Codable {
    let name: String
    let university: University
    let lat: Double
    let long: Double
}

struct Sheet: View {
    @State var searchText: String = ""
    @State var selectedCampus: String = "AUD"

    let availableCampuses: [String] = ["AUD", "AUS", "NYU"]
    let locations: [CampusLocation] = sampleLocations
    let filteredLocations: [CampusLocation] = []

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Text("Traverse")
                    .font(.title)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "plus")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                }
            }
            .padding()
            .frame(height: 40)

            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)

                        TextField("Search locations...", text: $searchText)
                            .font(.subheadline)

                        Spacer()

                        Menu {
                            ForEach(availableCampuses, id: \.self) { campus in
                                Button(action: { selectedCampus = campus }) {
                                    HStack {
                                        Text(campus)
                                        if campus == selectedCampus {
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "building.2")
                                    .foregroundColor(.accentColor)
                                
                                Text(selectedCampus)
                                    .fontWeight(.medium)
                                
                                Image(systemName: "chevron.down")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                        }
                    }
                }
                .padding(8)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .background(.ultraThickMaterial)
                .clipShape(Capsule())
                .padding(.top, 10)
                .padding(.leading, 10)
                .padding(.trailing, 10)


                // Locations list - no "Locations" title
                ScrollView {
                    if filteredLocations.isEmpty {
                        ContentUnavailableView(
                            "No Locations Found",
                            systemImage: "mappin.slash",
                            description: Text("Try adjusting your search")
                        )
                        .padding(.top, 40)
                    } else {
                        LazyVStack(spacing: 1) {
                            ForEach(filteredLocations) { location in
                                LocationRow(location: location)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemBackground))
                                    .contentShape(Rectangle())
                            }
                        }
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                }
                .background(Color(.systemBackground))
            }
        }
    }
}

struct CampusLocation: Identifiable {
    let id = UUID()
    let building: String
    let floor: Int
    let room: String
    let distanceMeters: Int
    let timeMinutes: Int
}

struct LocationRow: View {
    let location: CampusLocation

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.circle.fill")
                .font(.body)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(location.building) • \(location.floor)")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.medium)
                Text(location.room)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 8) {
                Label {
                    Text("\(location.distanceMeters)m")
                        .font(.system(.caption, design: .rounded))
                } icon: {
                    Image(systemName: "arrow.forward")
                        .font(.system(.caption))
                }
                .foregroundStyle(.secondary)

                Label {
                    Text("\(location.timeMinutes)m")
                        .font(.system(.caption, design: .rounded))
                } icon: {
                    Image(systemName: "clock")
                        .font(.system(.caption))
                }
                .foregroundStyle(.secondary)
            }
        }
    }
}

// Sample data
let sampleLocations = [
    CampusLocation(
        building: "A",
        floor: 2,
        room: "A201",
        distanceMeters: 150,
        timeMinutes: 2
    ),
    CampusLocation(
        building: "A",
        floor: 3,
        room: "A305",
        distanceMeters: 200,
        timeMinutes: 3
    ),
    CampusLocation(
        building: "B",
        floor: 1,
        room: "B104",
        distanceMeters: 350,
        timeMinutes: 5
    ),
    CampusLocation(
        building: "B",
        floor: 4,
        room: "B402",
        distanceMeters: 500,
        timeMinutes: 7
    ),
    CampusLocation(
        building: "C",
        floor: 2,
        room: "C210",
        distanceMeters: 275,
        timeMinutes: 4
    ),
    CampusLocation(
        building: "C",
        floor: 5,
        room: "C505",
        distanceMeters: 600,
        timeMinutes: 8
    ),
    CampusLocation(
        building: "D",
        floor: 1,
        room: "D101",
        distanceMeters: 425,
        timeMinutes: 6
    ),
    CampusLocation(
        building: "D",
        floor: 3,
        room: "D312",
        distanceMeters: 550,
        timeMinutes: 7
    ),
    CampusLocation(
        building: "E",
        floor: 2,
        room: "E203",
        distanceMeters: 300,
        timeMinutes: 4
    ),
    CampusLocation(
        building: "E",
        floor: 4,
        room: "E410",
        distanceMeters: 450,
        timeMinutes: 6
    ),
]

#Preview {
    Sheet()
}
