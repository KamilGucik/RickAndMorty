import SwiftUI

@MainActor
class EpisodeListViewModel: ObservableObject {
    @Published var episodes: [Episode] = []
    @Published var isNextPageAvailable = true
    @Published var page = 1

    let episodesRepository: EpisodesRepositoryProtocol

    init(episodesRepository: EpisodesRepositoryProtocol = EpisodesRepository()) {
        self.episodesRepository = episodesRepository
    }

    func fetchEpisodes() async {
        do {
            let paginatedResult = try await episodesRepository.getEpisodeList(page: page)
            episodes += paginatedResult.results
            isNextPageAvailable = paginatedResult.info.isNextPageAvailable
            page += 1
        } catch {
            print(error)
        }
    }

    func refresh() async {
        do {
            let paginatedResult = try await episodesRepository.getEpisodeList(page: 1)
            episodes = paginatedResult.results
            isNextPageAvailable = paginatedResult.info.isNextPageAvailable
            page = 2
        } catch {
            print(error)
        }
    }
}

public struct EpisodeListView: View {
    @StateObject private var viewModel = EpisodeListViewModel()

    public init() {}
    
    public var body: some View {
        PaginatedList(
            canFetchNextPage: $viewModel.isNextPageAvailable,
            elements: viewModel.episodes,
            content: { EpisodeView(episode: $0) },
            nextPageAction: { Task { await viewModel.fetchEpisodes() }}
        )
        .refreshable {
            Task { await viewModel.refresh() }
        }
    }
}

struct PaginatedList<ListElement: Identifiable, Content: View>: View {
    @Binding var canFetchNextPage: Bool
    var listElements: [ListElement]
    var nextPageAction: () -> Void
    var content: (ListElement) -> Content

    public init(
        canFetchNextPage: Binding<Bool>,
        elements: [ListElement],
        @ViewBuilder content: @escaping (ListElement) -> Content,
        nextPageAction: @escaping () -> Void
    ) {
        self._canFetchNextPage = canFetchNextPage
        self.listElements = elements
        self.content = content
        self.nextPageAction = nextPageAction
    }

    var body: some View {
        List {
            ForEach(listElements) {
                content($0)
            }
            if canFetchNextPage {
                ProgressView()
                    .onAppear { nextPageAction() }
            }
        }
        .listStyle(.plain)
    }
}

struct EpisodeListView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeListView()
    }
}
