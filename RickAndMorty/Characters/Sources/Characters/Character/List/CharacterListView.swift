import SwiftUI
import DesignKit

public struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()

    public init() {}

    public var body: some View {
        PaginatedList(
            canFetchNextPage: $viewModel.isNextPageAvailable,
            isLoading: $viewModel.isLoadingNextPage,
            elements: viewModel.characters,
            content: { character in
                NavigationLink(
                    destination: { CharacterDetailView(character) },
                    label: { CharacterView(character) }
                )
            },
            nextPageAction: { await viewModel.nextPage() }
        )
        .loadable(
            isLoading: $viewModel.isLoading,
            showError: $viewModel.showError,
            refreshAction: { await viewModel.refresh() }
        )
        .didLoad { await viewModel.observeInputs() }
        .sheet(isPresented: $viewModel.presentFilters) {
            CharactersFiltersView(
                filters: $viewModel.filters,
                clearAction: { viewModel.clearFilters() }
            )
                .presentationDetents([.medium])
        }
        .addFiltersItem(
            areSelected: $viewModel.areFiltersSelected,
            action: { viewModel.presentFilters.toggle() }
        )
        .scrollIndicators(.hidden)
        .refreshable { Task { await viewModel.refresh() }}
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
        //TODO: MOCK
    }
}

