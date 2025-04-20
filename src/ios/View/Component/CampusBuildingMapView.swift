import SwiftUI

struct CampusBuildingMapView: View {
    let buildingName: String
    let levels: [(id: String, displayName: String)]
    @Binding var selectedLevel: String

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "building.2")
                    .foregroundColor(.accentColor)
                Text(buildingName)
                    .italic()
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 8)

            VStack(spacing: 8) {
                ForEach(levels, id: \.id) { level in
                    Button(action: {
                        selectedLevel = level.id
                    }) {
                        Text(level.displayName)
                            .fontWeight(
                                selectedLevel == level.id ? .bold : .regular
                            )
                            .foregroundColor(
                                selectedLevel == level.id ? .white : .primary
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                selectedLevel == level.id
                                    ? Color.accentColor : Color(.systemGray6)
                            )
                            .cornerRadius(8)
                            .shadow(
                                color: selectedLevel == level.id
                                    ? .accentColor.opacity(0.2) : .clear,
                                radius: 4,
                                x: 0,
                                y: 2
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(14)
        .shadow(radius: 8)
    }
}

#Preview {
    CampusBuildingMapView(
        buildingName: "Main Building",
        levels: [("B_level_0", "Level 0"), ("B_level_1", "Level 1")],
        selectedLevel: .constant("B_level_0")
    )
}
