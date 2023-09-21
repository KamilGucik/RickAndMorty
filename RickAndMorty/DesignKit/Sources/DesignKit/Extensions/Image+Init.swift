import SwiftUI

public extension Image {
    init(_ systemImages: Images.System) {
        self.init(systemName: systemImages.imageName)
    }
}
