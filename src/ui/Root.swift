import RealityKit
import SwiftUI

struct Root: View {
    var body: some View = RealityView { scene in
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(
            color: .systemBlue,
            roughness: 0.15,
            isMetallic: true
        )

        let component = ModelComponent(mesh: mesh, materials: [material])
        let model = Entity(components: [component])

        model.position = [0, 0.05, 0]
        let anchor = AnchorEntity(
            .plane(
                .horizontal,
                classification: .any,
                minimumBounds: SIMD2<Float>(0.2, 0.22)
            )
        )

        anchor.addChild(model)

        scene.add(anchor)
        scene.camera = .spatialTracking
    }.edgesIgnoringSafeArea(.all)
}

#Preview {
    Root()
}
