import ARKit
import RealityKit
import RoomPlan
import SwiftUI

struct Scanner: View {
    @State var roomController = RoomController()

    var body: some View {
        RoomCaptureViewRepresentable(
            roomCaptureView: roomController.roomCaptureView
        )
        .onAppear {
            self.roomController.startSession()
        }
        .onDisappear {
            self.roomController.stopSession()
        }
    }
}

struct RoomCaptureViewRepresentable: UIViewRepresentable {
    let roomCaptureView: RoomCaptureView

    func makeUIView(context: Context) -> some UIView {
        return roomCaptureView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

@Observable
@MainActor
class RoomController: NSObject, RoomCaptureSessionDelegate {
    let roomCaptureView = RoomCaptureView()
    var configuration = RoomCaptureSession.Configuration()

    override init() {
        super.init()
        configuration.isCoachingEnabled = true
        roomCaptureView.isModelEnabled = true
        roomCaptureView.captureSession?.delegate = self
    }

    func startSession() {
        roomCaptureView.captureSession?.run(
            configuration: self.configuration
        )
    }

    func stopSession() {
        roomCaptureView.captureSession?.stop()
    }

    // Handle session end
    func captureSession(_ session: RoomCaptureSession, didEndWith error: Error?)
    {
        if let error = error {
            print("Scanning failed with error: \(error.localizedDescription)")
        } else {
            print("Success")
        }
    }
}
