import Foundation
import Combine

@MainActor
class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var isNextPageAvailable = true
    @Published var presentFilters = false
    @Published var filters: CharacterFilterParameters = .init()

    private var page: Int = 1
    private let charactersRepository: CharactersRepositoryProtocol

    init(charactersRepository: CharactersRepositoryProtocol = CharactersRepository()) {
        self.charactersRepository = charactersRepository
    }

    func nextPage() async {
        self.characters += await fetchCharacters(page: page)
    }

    func refresh() async {
        self.characters = await fetchCharacters(page: 1)
    }

    func observeInputs() async {
        for await _ in $filters
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .values {
            let characters = await fetchCharacters(page: 1)
            self.characters = characters
        }
    }

    private func fetchCharacters(page: Int) async -> [Character] {
        do {
            let paginatedResult = try await charactersRepository.getCharacterList(
                page: page,
                filters: filters
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
