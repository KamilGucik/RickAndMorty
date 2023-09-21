import SwiftUI

public extension View {
    func loadable(isLoading: Binding<Bool>, showError: Binding<Bool>, refreshAction: @escaping () -> Void) -> some View {
        self
            .modifier(LoadableViewModifier(
                isLoading: isLoading,
                showError: showError,
                refreshAction: refreshAction
            ))
    }

    func loadable(isLoading: Binding<Bool>, showError: Binding<Bool>, refreshAction: @escaping () async -> Void) -> some View {
        self
            .modifier(LoadableViewModifier(
                isLoading: isLoading,
                showError: showError,
                refreshAction: { Task { await refreshAction() }}
            ))
    }
}

struct LoadableViewModifier: ViewModifier {
    @Binding var isLoading: Bool
    @Binding var showError: Bool
    var refreshAction: () -> Void

    init(isLoading: Binding<Bool>, showError: Binding<Bool>, refreshAction: @escaping () -> Void) {
        self._isLoading = isLoading
        self._showError = showError
        self.refreshAction = refreshAction
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            if showError {
                error
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.primary.opacity(0.9))
            } else if isLoading {
                loading
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.primary.opacity(0.9))
            }
        }
    }

    private var loading: some View {
        ProgressView()
            .padding()
            .background(.bar)
            .cornerRadius(16)
    }

    private var error: some View {
        VStack {
            Text("Error occurred !")
            Button(
                action: { refreshAction() },
                label: {
                    Text("Retry")
                        .font(.title)
                }
            )
            .buttonStyle(.borderedProminent)
        }
        .font(.largeTitle)
        .padding()
        .background(.bar)
        .cornerRadius(16)
    }
}

struct LoadableViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, world!")
            .modifier(LoadableViewModifier(
                isLoading: .constant(true),
                showError: .constant(false),
                refreshAction: {})
            )

        Text("Hello, world!")
            .modifier(LoadableViewModifier(
                isLoading: .constant(false),
                showError: .constant(true),
                refreshAction: {})
            )

        Text("Hello, world!")
            .modifier(LoadableViewModifier(
                isLoading: .constant(false),
                showError: .constant(false),
                refreshAction: {})
            )
    }
}
