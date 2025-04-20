import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(14)
            .shadow(radius: 8)
    }
}

extension Color {
    static let traverseAccent = Color.accentColor
    static let traverseRoom = Color.orange
    static let traverseHallway = Color.cyan
    static let traverseStaircase = Color.purple
    static let traverseFootprint = Color.gray.opacity(0.3)
}

extension Font {
    static let traverseHeadline = Font.headline
    static let traverseSubheadline = Font.subheadline.italic()
}

extension PresentationDetent {
    static let trSmall = PresentationDetent.fraction(0.1)
    static let trMedium = PresentationDetent.fraction(0.42)
    static let trFull = PresentationDetent.fraction(0.99)
}
