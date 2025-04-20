import SwiftUI

struct BusynessIndicatorView: View {
    let currentLevel: Int
    let description: String
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { level in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(
                        level <= currentLevel ? .orange : .gray.opacity(0.3)
                    )
            }
            if !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
