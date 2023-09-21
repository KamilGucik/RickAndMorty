import Foundation
import LocalStorageKit

@MainActor
class CharacterDetailViewModel: ObservableObject {
    let coreDataManager = CoreDataManager.shared
    let locationRepository: LocationRepositoryProtocol
    let character: Character

    @Published var isCharacterFavourite: Bool = false
    @Published var charactersInLocation: [Character] = []
    @Published var isLoading = false
    @Published var showError = false

    init(
        character: Character,
        locationRepository: LocationRepositoryProtocol = LocationRepository()
    ) {
        self.character = character
        self.locationRepository = locationRepository
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
            print(error)
        }
    }

    func tapFavourite() {
        if isCharacterFavourite {
            coreDataManager.removeCharacter(id: character.id)
        } else {
            addCharacterToStorage()
        }
        checkIfIsFavourite()
    }

    func checkIfIsFavourite() {
        isCharacterFavourite = coreDataManager.checkIfCharacterExists(id: character.id)
    }

    private func addCharacterToStorage() {
        coreDataManager.addCharacter(
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
