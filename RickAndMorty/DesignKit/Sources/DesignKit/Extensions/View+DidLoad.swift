import SwiftUI

public extension View {
    func didLoad(action: @escaping () async -> Void) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }
}

struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let action: () async -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    Task { await action() }
                }
            }
    }
}
