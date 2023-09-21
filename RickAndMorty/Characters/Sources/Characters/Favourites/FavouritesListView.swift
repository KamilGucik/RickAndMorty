import SwiftUI
import DesignKit

public struct FavouritesListView: View {
    @StateObject var viewModel: FavouritesListViewModel = .init()

    public init() {}
    public var body: some View {
        List(filteredCharacters) { character in
            NavigationLink(
                destination: { CharacterDetailView(character: character) },
                label: { CharacterView(character: character) }
            )
        }
        .searchable(text: $viewModel.searchText)
        .listStyle(.plain)
        .refreshable { viewModel.fetchCharacters() }
        .loadable(
            isLoading: $viewModel.isLoading,
            showError: $viewModel.showError,
            refreshAction: { viewModel.fetchCharacters() }
        )
        .onAppear { viewModel.fetchCharacters()}
    }

    private var filteredCharacters: [Character] {
        if !viewModel.searchText.isEmpty {
            return viewModel.characters.filter {
                $0.name.contains(viewModel.searchText)
            }
        } else {
            return viewModel.characters
        }
    }
}

struct FavouritesListView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesListView()
    }
}
