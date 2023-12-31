import SwiftUI
import DesignKit

public struct EpisodeListView: View {
    @StateObject private var viewModel = EpisodeListViewModel()

    public init() {}

    public var body: some View {
        PaginatedList(
            canFetchNextPage: $viewModel.isNextPageAvailable,
            isLoading: $viewModel.isLoadingNextPage,
            elements: viewModel.episodes,
            content: { EpisodeView($0) },
            nextPageAction: { await viewModel.nextPage() }
        )
        .loadable(
            isLoading: $viewModel.isLoading,
            showError: $viewModel.showError,
            refreshAction: { await viewModel.refresh() }
        )
        .didLoad { await viewModel.observeInputs() }
        .sheet(isPresented: $viewModel.presentFilters) {
            filters
                .presentationDetents([.medium])
        }
        .addFiltersItem(
            areSelected: $viewModel.areFiltersSelected,
            action: { viewModel.presentFilters.toggle() }
        )
        .scrollIndicators(.hidden)
        .refreshable { Task { await viewModel.refresh() }}
    }

    private var filters: some View {
        VStack(spacing: 32) {
            ClearButton { viewModel.clearFilters() }
            GroupBox {
                VStack(spacing: 16) {
                    TextField("Name", text: $viewModel.filters.name)
                    TextField("Episode", text: $viewModel.filters.episode)
                }
            }
        }
        .padding(24)
    }
}

struct EpisodeListView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeListView()
    }
}
