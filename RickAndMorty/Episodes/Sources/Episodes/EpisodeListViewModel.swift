import Foundation
import Combine

@MainActor
class EpisodeListViewModel: ObservableObject {
    @Published var episodes: [Episode] = []
    @Published var isNextPageAvailable = true
    @Published var presentFilters = false

    @Published var filters: EpisodeFilterParameters = .init()
    @Published var areFiltersSelected = false

    @Published var isLoading = false
    @Published var showError = false

    @Published var isLoadingNextPage = false
    @Published var showNextPageError = false

    var page = 1
    let episodesRepository: EpisodesRepositoryProtocol

    init(episodesRepository: EpisodesRepositoryProtocol = EpisodesRepository()) {
        self.episodesRepository = episodesRepository
    }

    func nextPage() async {
        do {
            isLoadingNextPage = true
            showNextPageError = false
            self.page += 1
            self.episodes += try await getPaginatedEpisodes()
            isLoadingNextPage = false
        } catch {
            isLoadingNextPage = false
            showNextPageError = true
            self.page -= 1
        }
    }

    func refresh() async {
        do {
            isLoading = true
            showError = false
            page = 1
            self.episodes = try await getPaginatedEpisodes()
            isLoading = false
        } catch {
            showError = true
            isLoading = false
        }
    }

    func observeInputs() async {
        for await input in $filters
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .values {
            areFiltersSelected = input.areFiltersSelected
            await refresh()
        }
    }

    func clearFilters() {
        filters.name = ""
        filters.episode = ""
        areFiltersSelected = false
    }

    private func getPaginatedEpisodes() async throws -> [Episode] {
        let paginatedResult = try await episodesRepository.getEpisodeList(
            page: page,
            filters: filters
        )
        self.isNextPageAvailable = paginatedResult.info.isNextPageAvailable
        return paginatedResult.results
    }
}
