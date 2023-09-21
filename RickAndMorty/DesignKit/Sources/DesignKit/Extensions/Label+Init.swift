import SwiftUI

public extension Label where Title == Text, Icon == Image {
    init(_ title: String, image: Images.System) {
        self.init(title, systemImage: image.imageName)
    }
}
