import Foundation

public enum Images {
    public enum System {
        case exclamationMark
        case filters
        case errorImage

        public var imageName: String {
            switch self {
            case .exclamationMark: return "exclamationmark.triangle.fill"
            case .filters: return "slider.vertical.3"
            case .errorImage: return "person.fill"
            }
        }
    }
}
