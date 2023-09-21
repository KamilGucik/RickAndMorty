import SwiftUI

public enum Colors {
    case surface
    
    public var rgbColor: (r: Double, g: Double, b: Double) {
        switch self {
        case .surface: return (r: 232/255, g: 232/255, b: 185/255)
        }
    }
}
