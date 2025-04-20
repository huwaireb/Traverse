import Turf

extension Geometry {
    var asPolygon: Turf.Polygon? {
        switch self {
        case .polygon(let polygon):
            return polygon
        case .multiPolygon(let multiPolygon):
            return multiPolygon.polygons.first
        default:
            return nil
        }
    }

    var asPoint: Turf.Point? {
        switch self {
        case .point(let point):
            return point
        default:
            return nil
        }
    }
}
