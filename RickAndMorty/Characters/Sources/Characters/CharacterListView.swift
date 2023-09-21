import SwiftUI
import DesignKit

public struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()

    public init() {}

    public var body: some View {
        PaginatedList(
            canFetchNextPage: $viewModel.isNextPageAvailable,
            elements: viewModel.characters,
            content: { character in
                NavigationLink(
                    destination: { CharacterDetailView(character: character) },
                    label: { CharacterView(character: character) }
                )
            },
            nextPageAction: { await viewModel.nextPage() }
        )
        .refreshable { Task { await viewModel.refresh() }}
        .didLoad { await viewModel.observeInputs() }
        .sheet(isPresented: $viewModel.presentFilters, content: {
            CharactersFiltersView(filters: $viewModel.filters)
                .presentationDetents([.medium])
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                filtersButton
            }
        }
    }

    private var filtersButton: some View {
        Button(
            action: { viewModel.presentFilters.toggle() },
            label: {
                Image(.filters)
            }
        )
        .overlay(alignment: .topTrailing) {
            if viewModel.filters.areFiltersSelected {
                Image(.exclamationMark)
                    .resizable()
                    .frame(width: 15, height: 15)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red)
            }
        }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
        //TODO: MOCK
    }
}

