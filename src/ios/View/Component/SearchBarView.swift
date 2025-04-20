import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var placeholder: String = "Search locations"

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)

            TextField(placeholder, text: $text)
                .focused($isFocused)
                .foregroundColor(.primary)
                .submitLabel(.search)

            if !text.isEmpty {
                Button {
                    text = ""
                    isFocused = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
        .background(.thinMaterial)
        .cornerRadius(10)
    }
}

#Preview {
    SearchBarView(text: .constant("Sample"))
        .padding()
}
