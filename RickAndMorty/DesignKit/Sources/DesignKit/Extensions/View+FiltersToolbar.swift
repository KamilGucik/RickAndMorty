import SwiftUI

public extension View {
    func addFiltersItem(
        areSelected: Binding<Bool>,
        action: @escaping () -> Void
    ) -> some View {
        self
            .modifier(FiltersToolbarModifier(
                areSelected: areSelected,
                action: action
            ))
    }
}

struct FiltersToolbarModifier: ViewModifier {
    @Binding var areSelected: Bool
    var action: () -> Void

    init(areSelected: Binding<Bool>, action: @escaping () -> Void) {
        self._areSelected = areSelected
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    filtersButton
                }
            }
    }

    private var filtersButton: some View {
        Button(
            action: { action() },
            label: {
                Image(.filters)
            }
        )
        .overlay(alignment: .topTrailing) {
            if areSelected {
                Image(.exclamationMark)
                    .resizable()
                    .frame(width: 15, height: 15)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red)
            }
        }
    }
}

struct FiltersToolbarModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, world!")
            .modifier(FiltersToolbarModifier(
                areSelected: .constant(true),
                action: {}
            ))
    }
}
