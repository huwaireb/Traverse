import SwiftUI

@MainActor
@Observable
final class LocationDetailViewModel {
    let display: CampusLocationDisplay
    var rootViewModel: RootViewModel

    init(display: CampusLocationDisplay, rootViewModel: RootViewModel) {
        self.display = display
        self.rootViewModel = rootViewModel
    }

    func computePathForGoButton() {
        guard display.coordinate != nil else {
            print("No coordinate for location: \(display.name)")
            return
        }

        let entranceAId = "737220f5-9b8f-4ca6-b2fb-cd0b9731c51b"
        let restroomId = "428d90ea-0cae-4861-b8b7-087c57c35848"

        if display.name.lowercased() == "entrance a"
            || display.id.uuidString == entranceAId
        {
            rootViewModel.currentPath = []
            if let path = rootViewModel.computePath(
                from: entranceAId,
                to: restroomId
            ) {
                rootViewModel.currentPath = path
                print("Path computed: \(path.count) coordinates")
            } else {
                print("Failed to compute path from Entrance A to Restroom")
            }
        }
    }
}
