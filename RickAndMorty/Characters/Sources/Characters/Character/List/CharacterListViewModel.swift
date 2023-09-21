import Foundation
import Combine

@MainActor
class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var isNextPageAvailable = true
    @Published var presentFilters = false

    @Published var filters: CharacterFilterParameters = .init()
    @Published var areFiltersSelected: Bool = false

    @Published var isLoading = false
    @Published var showError = false

    @Published var isLoadingNextPage = false
    @Published var showNextPageError = false

    private var page: Int = 1
    private let charactersRepository: CharactersRepositoryProtocol

    init(charactersRepository: CharactersRepositoryProtocol = CharactersRepository()) {
        self.charactersRepository = charactersRepository
    }

    func nextPage() async {
        do {
            isLoadingNextPage = true
            showNextPageError = false
            page += 1
            characters += try await getPaginatedCharacters()
            isLoadingNextPage = false
        } catch {
            isLoadingNextPage = false
            showNextPageError = true
        }
    }

    func refresh() async {
        do {
            isLoading = true
            showError = false
            page = 1
            characters = try await getPaginatedCharacters()
            isLoading = false
        } catch {
            showError = true
            isLoading = false
        }
    }

    func clearFilters() {
        filters.name = ""
        filters.status = nil
        filters.species = ""
        filters.type = ""
        filters.gender = nil
        areFiltersSelected = false
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

    private func getPaginatedCharacters() async throws -> [Character] {
        let paginatedResult = try await charactersRepository.getCharacterList(
            page: page,
            filters: filters
        )
        self.isNextPageAvailable = paginatedResult.info.isNextPageAvailable
        return paginatedResult.results
    }
}
