import Foundation
import Combine

@MainActor
class EpisodeListViewModel: ObservableObject {
    @Published var episodes: [Episode] = []
    @Published var isNextPageAvailable = true
    @Published var isNameFilterVisible: Bool = true
    @Published var nameFilterText: String = ""
    @Published var episodeFilterText: String = ""

    private var page = 1
    private let episodesRepository: EpisodesRepositoryProtocol

    init(episodesRepository: EpisodesRepositoryProtocol = EpisodesRepository()) {
        self.episodesRepository = episodesRepository
    }

    func nextPage() async {
        self.episodes += await fetchEpisodes(page: page)
    }

    func refresh() async {
        self.episodes = await fetchEpisodes(page: 1)
    }

    func observeInputs() async {
        let stream = Publishers.CombineLatest(
            $nameFilterText.removeDuplicates(),
            $episodeFilterText.removeDuplicates()
        )
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .values

        for await (_, _) in stream {
            self.episodes = await fetchEpisodes(page: 1)
        }
    }

    private func fetchEpisodes(page: Int) async -> [Episode] {
        do {
            let paginatedResult = try await episodesRepository.getEpisodeList(
                page: page,
                name: nameFilterText,
                episode: episodeFilterText
            )
            isNextPageAvailable = paginatedResult.info.isNextPageAvailable
            self.page = page + 1
            return paginatedResult.results
        } catch {
            print(error)
            isNextPageAvailable = false
            return []
        }
    }
}
