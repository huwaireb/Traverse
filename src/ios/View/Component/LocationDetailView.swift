import MapboxMaps
import SwiftUI

struct LocationDetailView: View {
    @State private var viewModel: LocationDetailViewModel
    @Binding var rootViewModel: RootViewModel
    @Binding var viewport: Viewport
    @Environment(\.dismiss) private var dismiss
    @State private var selectedImageIndex = 0

    init(display: CampusLocationDisplay, rootViewModel: Binding<RootViewModel>, viewport: Binding<Viewport>) {
        _viewModel = State(wrappedValue: LocationDetailViewModel(display: display, rootViewModel: rootViewModel.wrappedValue))
        self._rootViewModel = rootViewModel
        self._viewport = viewport
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                imageGalleryView
                locationInfoView
                Spacer(minLength: 20)
            }
            .padding(.top)
        }
        .background(.clear)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if let coordinate = viewModel.display.coordinate {
                        viewModel.computePathForGoButton()
                        withAnimation {
                            viewport = Viewport.camera(
                                center: coordinate,
                                zoom: viewport.camera?.zoom ?? 15
                            )
                        }
                        dismiss()
                    } else {
                        print("No coordinate available for location: \(viewModel.display.name)")
                    }
                }) {
                    Text("Go")
                        .bold()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }

    @ViewBuilder
    private var imageGalleryView: some View {
        TabView(selection: $selectedImageIndex) {
            Rectangle()
                .fill(.clear)
                .frame(height: 200)
                .overlay(
                    Image(systemName: viewModel.display.iconName)
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                )
                .cornerRadius(8)
                .tag(0)
        }
        .tabViewStyle(.page)
        .frame(height: 130)
        .padding(.horizontal)
        .padding(.top, 8)
        .background(.clear)
    }

    @ViewBuilder
    private var locationInfoView: some View {
        VStack(alignment: .leading, spacing: 12) {
            locationTitleView
            accessibilityAndBusynessView
            Divider()
            Text(viewModel.display.description)
                .font(.body)
            peakTimesView
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var locationTitleView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.display.name)
                .font(.title2.bold())
            HStack(spacing: 12) {
                Label(viewModel.display.building, systemImage: "building.2")
                Label("Level \(viewModel.display.level)", systemImage: "figure.stairs")
                if let distance = viewModel.display.distanceInMeters {
                    Label(
                        "\(distance)m",
                        systemImage: "figure.walk.diamond.fill"
                    )
                }
                Spacer()
                if let timeToReach = viewModel.display.timeToReach {
                    distanceTimeView(timeToReach: timeToReach)
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
    }

    @ViewBuilder
    private func distanceTimeView(timeToReach: String) -> some View {
        let colors = viewModel.display.timeColors
        Text(timeToReach)
            .font(.subheadline.weight(.medium))
            .foregroundColor(colors.foreground)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(colors.background.opacity(0.8))
            .cornerRadius(6)
    }

    @ViewBuilder
    private var accessibilityAndBusynessView: some View {
        HStack(spacing: 16) {
            Label(
                viewModel.display.isWheelchairAccessible
                    ? "Accessible" : "Not Accessible",
                systemImage: viewModel.display.isWheelchairAccessible
                    ? "figure.roll" : "figure.roll.runningpace"
            )
            .font(.callout)
            .foregroundColor(viewModel.display.isWheelchairAccessible ? .green : .red)
            Spacer()
            BusynessIndicatorView(
                currentLevel: viewModel.display.currentBusyness.rawValue,
                description: "NOTHING"
            )
        }
    }

    @ViewBuilder
    private var peakTimesView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Peak Times")
                .font(.headline)
            if viewModel.display.peakTimes.isEmpty {
                Text("No peak time data available.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.display.peakTimes) { peak in
                    HStack {
                        Text("\(peak.day), \(peak.hour)")
                            .font(.subheadline)
                        Spacer()
                        BusynessIndicatorView(
                            currentLevel: peak.busyness.rawValue,
                            description: ""
                        )
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .cornerRadius(8)
    }
}
