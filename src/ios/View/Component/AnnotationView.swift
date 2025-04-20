import SwiftUI

struct AnnotationView: View {
    let title: String
    let levels: [Level]
    @Binding var selectedLevel: Level?
    let onClose: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
            }

            Image(systemName: "building")
                .foregroundColor(.black)
                .font(.system(size: 14))

            Text(title)
                .font(.caption)
                .foregroundColor(.black)
                .lineLimit(1)

            Picker("Level", selection: $selectedLevel) {
                Text("All Levels").tag(nil as Level?)
                ForEach(levels, id: \.id) { level in
                    Text(level.properties.shortName.bestLocalizedValue ?? "Level \(level.properties.ordinal)")
                        .tag(level as Level?)
                }
            }
            .pickerStyle(.menu)
            .font(.caption)
            .tint(.blue)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
