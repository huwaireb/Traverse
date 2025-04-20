@_spi(Experimental) import MapboxMaps
import SwiftUI

struct RootScreen: View {
    @State private var viewModel = RootViewModel()
    @State private var viewport: Viewport = .styleDefault

    var body: some View {
        initialView
            .sheet(isPresented: .constant(true)) {
                NavigationStack(path: $viewModel.navigationPath) {
                    sheetContentView
                        .navigationDestination(for: LocationRoute.self) {
                            route in
                            LocationDetailView(
                                display: route.location.toDisplay(),
                                rootViewModel: $viewModel,
                                viewport: $viewport
                            )
                        }
                }
                .presentationBackgroundInteraction(.enabled)
                .presentationBackground(.thinMaterial)
                .presentationCornerRadius(10)
                .presentationDragIndicator(
                    viewModel.selectedUniversity != nil ? .visible : .hidden
                )
                .presentationDetents(
                    [.trSmall, .trMedium, .trFull],
                    selection: $viewModel.selectedDetent
                )
                .interactiveDismissDisabled(true)
            }
    }

    @ViewBuilder
    private var initialView: some View {
        if let selectedUniversity = viewModel.selectedUniversity,
            let imdfData = viewModel.venues[selectedUniversity]
        {
            VenueView(
                imdfData: imdfData,
                viewport: Binding(
                    get: { selectedUniversity.viewport },
                    set: { _ in }  // Read-only binding
                ),
                rootViewModel: $viewModel
            )
        } else {
            Map(viewport: $viewport)
        }
    }

    @ViewBuilder
    private var sheetContentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            universityPickerView
                .padding(.bottom, 5)
            if viewModel.selectedUniversity != nil {
                locationListView
            }
        }
    }

    @ViewBuilder
    private var universityPickerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: -5) {
                Text("Traverse")
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.cyan)
                    .shadow(color: .cyan.opacity(0.7), radius: 8, x: 0, y: 0)
                Picker(
                    "University",
                    selection: Binding(
                        get: { viewModel.selectedUniversity },
                        set: { viewModel.selectUniversity($0) }
                    )
                ) {
                    Text("Select a University").tag(nil as University?)
                        .font(.caption)
                    Divider()
                    ForEach(University.allCases) { university in
                        Text(university.name).tag(university as University?)
                            .disabled(!university.isEnabled)
                    }
                }
                .font(.headline)
                .tint(.primary)
                .pickerStyle(.menu)
                .padding(.leading, -10)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, viewModel.selectedDetent == .trSmall ? 40 : 20)
    }

    @ViewBuilder
    private var locationListView: some View {
        VStack(alignment: .leading, spacing: 0) {
            SearchBarView(text: $viewModel.searchText)
                .padding(.horizontal)
                .padding(.bottom, 8)
            List(viewModel.filteredLocations, id: \.id) { location in
                Button {
                    viewModel.navigateToLocation(.init(location))
                } label: {
                    locationRow(for: location)
                }
                .buttonStyle(.plain)
                .padding(.vertical, 4)
                .listRowInsets(
                    EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
                )
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }

    @ViewBuilder
    private func locationRow(for location: any CampusLocation) -> some View {
        let display = location.toDisplay()
        HStack(spacing: 12) {
            Image(systemName: display.iconName)
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(display.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                HStack(spacing: 8) {
                    if !(location is BuildingLocation) {
                        if !display.buildingAltName.isEmpty {
                            HStack(spacing: 2) {
                                Image(systemName: "building.2")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(display.buildingAltName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        if !display.levelShortName.isEmpty {
                            HStack(spacing: 2) {
                                Image(systemName: "figure.stairs")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("Level \(display.levelShortName)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            if let timeToReach = display.timeToReach {
                                HStack(spacing: 2) {
                                    Image(systemName: "clock")
                                        .font(.caption)
                                        .foregroundColor(
                                            display.timeColors.foreground
                                        )
                                    Text(timeToReach)
                                        .font(.caption)
                                        .foregroundColor(
                                            display.timeColors.foreground
                                        )
                                }
                            }
                        }
                    }
                    if display.isWheelchairAccessible {
                        Image(systemName: "figure.roll")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }

            Spacer()

            if let distance = display.distanceInMeters {
                Text("\(distance)m")
                    .font(.caption)
                    .foregroundColor(display.timeColors.foreground)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(display.timeColors.background.opacity(0.1))
                    .cornerRadius(4)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

#Preview { RootScreen() }
