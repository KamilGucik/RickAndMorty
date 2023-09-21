import Foundation
import LocalStorageKit

@MainActor
class FavouritesListViewModel: ObservableObject {
    let coreDataManager: CoreDataManagerProtocol
    @Published var characters: [Character] = []
    @Published var filteredCharacters: [Character] = []
    @Published var searchText: String = ""

    @Published var isLoading = false
    @Published var showError = false

    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }

    func fetchCharacters() {
        isLoading = true
        do {
            characters = try coreDataManager.fetch().map {
                .init(
                    id: Int($0.id),
                    name: $0.name,
                    status: .init(rawValue: $0.status) ?? .unknown,
                    species: $0.species,
                    type: $0.type,
                    gender: .init(rawValue: $0.gender) ?? .unknown,
                    location: .init(
                        name: $0.locationName,
                        url: $0.locationURL
                    ),
                    image: $0.image,
                    episode: $0.episode
                )
            }
            isLoading = false
        } catch {
            isLoading = false
            showError = true
        }
    }
}
