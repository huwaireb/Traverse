import CoreLocation
import Foundation

@MainActor @Observable
class NavigationManager {
    var graph: Graph
    private var _nodeCoordinates: [String: CLLocationCoordinate2D]

    init() {
        graph = Graph()
        _nodeCoordinates = [:]
    }

    func addNode(name: String, coordinate: CLLocationCoordinate2D) {
        _nodeCoordinates[name] = coordinate
        graph.addNode(std.string(name))
    }

    func addEdge(from: String, to: String, weight: Double) {
        graph.addEdge(std.string(from), std.string(to), weight)
    }

    func getShortestPath(from: String, to: String) -> [CLLocationCoordinate2D]?
    {
        let path = graph.shortestPath(
            std.string(from),
            std.string(to)
        )

        return path.compactMap { node in
            _nodeCoordinates[String(node)]
        }
    }
}
