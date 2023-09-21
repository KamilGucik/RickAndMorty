import Foundation
import LocalStorageKit

@MainActor
class FavouritesListViewModel: ObservableObject {
    let coreDataManager = CoreDataManager.shared
    @Published var characters: [Character] = []
    @Published var filteredCharacters: [Character] = []
    @Published var searchText: String = ""

    @Published var isLoading = false
    @Published var showError = false

    func fetchCharacters() {
        isLoading = true
        characters = coreDataManager.fetch().map {
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
    }
}
