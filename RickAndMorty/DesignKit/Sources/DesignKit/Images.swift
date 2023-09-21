import Foundation

public enum Images {
    public enum System {
        case exclamationMark
        case filters
        case errorImage
        case heart(filled: Bool)
        case episodes
        case characters
        case favourites

        public var imageName: String {
            switch self {
            case .exclamationMark: return "exclamationmark.triangle.fill"
            case .filters: return "slider.vertical.3"
            case .errorImage: return "person.fill"
            case let .heart(filled: filled): return filled ? "heart.fill" : "heart"
            case .episodes: return "tv"
            case .characters: return "person.crop.circle"
            case .favourites: return "heart.circle"
            }
        }
    }
}
