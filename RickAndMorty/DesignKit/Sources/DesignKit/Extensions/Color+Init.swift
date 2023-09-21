import SwiftUI

public extension Color {
    init(_ colors: Colors) {
        self.init(red: colors.rgbColor.r, green: colors.rgbColor.g, blue: colors.rgbColor.b)
    }
}
