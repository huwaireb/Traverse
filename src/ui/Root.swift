import RealityKit
import SwiftUI

struct Root: View {
    var body: some View = RealityView { _ in
    }.edgesIgnoringSafeArea(.all)
}

#Preview {
    Root()
}
