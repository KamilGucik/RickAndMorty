import SwiftUI

public struct ClearButton: View {
    var action: () -> Void

    public init(_ action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(
            action: { action() },
            label: {
                Text("Clear")
                    .font(.title)
                    .padding()
                    .background(.bar)
                    .cornerRadius(16)
            }
        )
    }
}

struct ClearButton_Previews: PreviewProvider {
    static var previews: some View {
        ClearButton {}
    }
}
