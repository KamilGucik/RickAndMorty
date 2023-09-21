import SwiftUI
import DesignKit

public struct EpisodeListView: View {
    @StateObject private var viewModel = EpisodeListViewModel()

    public init() {}

    public var body: some View {
        PaginatedList(
            canFetchNextPage: $viewModel.isNextPageAvailable,
            elements: viewModel.episodes,
            header: { searchBars },
            content: { EpisodeView(episode: $0) },
            nextPageAction: { await viewModel.nextPage() }
        )
        .refreshable { Task { await viewModel.refresh() }}
        .didLoad { await viewModel.observeInputs() }
    }

    private var searchBars: some View {
        GeometryReader { proxy in
            HStack(spacing: 8) {
                TextField("Name", text: $viewModel.nameFilterText)
                    .frame(width: proxy.size.width * 0.8)
                TextField("Episode", text: $viewModel.episodeFilterText)
                    .frame(width: proxy.size.width * 0.2)
            }
        }
    }
}

struct EpisodeListView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeListView()
    }
}
