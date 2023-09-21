import Foundation
import LocalStorageKit

@MainActor
class CharacterDetailViewModel: ObservableObject {
    let coreDataManager: CoreDataManagerProtocol
    let locationRepository: LocationRepositoryProtocol
    let character: Character

    @Published var isCharacterFavourite: Bool = false
    @Published var charactersInLocation: [Character] = []
    @Published var isLoading = false
    @Published var showError = false

    init(
        character: Character,
        locationRepository: LocationRepositoryProtocol = LocationRepository(),
        coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared
    ) {
        self.character = character
        self.locationRepository = locationRepository
        self.coreDataManager = coreDataManager
    }

    func fetchCharactersInLocation() async {
        guard let locationID = character.location.id else { return }
        do {
            isLoading = true
            showError = false
            charactersInLocation = try await locationRepository.getResidentsInLocation(id: locationID)
                .filter { $0.id != character.id }
            isLoading = false
        } catch {
            isLoading = false
            showError = true
        }
    }

    func tapFavourite() {
        if isCharacterFavourite {
            try? coreDataManager.removeCharacter(id: character.id)
        } else {
            try? addCharacterToStorage()
        }
        checkIfIsFavourite()
    }

    func checkIfIsFavourite() {
        isCharacterFavourite = coreDataManager.checkIfCharacterExists(id: character.id)
    }

    private func addCharacterToStorage() throws {
        try coreDataManager.addCharacter(
            id: character.id,
            name: character.name,
            status: character.status.rawValue,
            species: character.species,
            type: character.type,
            gender: character.gender.rawValue,
            locationName: character.location.name,
            locationURL: character.location.url,
            image: character.image,
            episode: character.episode
        )
    }
}
