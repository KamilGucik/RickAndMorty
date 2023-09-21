import XCTest
@testable import Characters

@MainActor
final class CharacterDetailViewModelTests: XCTestCase {
    private var sut: CharacterDetailViewModel!
    private var coreDataManager: CoreDataManagerMock!
    private var locationRepository: LocationRepositoryMock!
    private var character: Character!

    override func setUp() {
        super.setUp()
        self.character = .mock(id: 1)
        self.coreDataManager = .init()
        self.locationRepository = .init()
        self.sut = .init(
            character: character,
            locationRepository: locationRepository,
            coreDataManager: coreDataManager
        )
    }

    override func tearDown() {
        self.character = nil
        self.locationRepository = nil
        self.coreDataManager = nil
        self.sut = nil
        super.tearDown()
    }

    func test_fetchCharactersInLocation() async {
        let mockCharacters = Character.mockList(size: 5).filter { $0.id != character.id }
        locationRepository.getResidentsResultToReturn = mockCharacters

        await sut.fetchCharactersInLocation()

        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.charactersInLocation.map { $0.id }, mockCharacters.map { $0.id })
        XCTAssertFalse(sut.showError)
        XCTAssertEqual(locationRepository.getResidentsInLocationCalls, 1)
    }

    func test_fetchCharactersInLocation_ShouldShowError() async {
        locationRepository.getResidentsErrorToThrow = NSError(domain: "", code: 0)

        await sut.fetchCharactersInLocation()

        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.charactersInLocation.isEmpty)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(locationRepository.getResidentsInLocationCalls, 1)
    }

    func test_TapFavourite() {
        coreDataManager.checkIfCharacterExistsResultToReturn = true
        XCTAssertFalse(sut.isCharacterFavourite)
        sut.tapFavourite()

        XCTAssertTrue(sut.isCharacterFavourite)
        XCTAssertEqual(coreDataManager.addCharacterCalls, 1)

        coreDataManager.checkIfCharacterExistsResultToReturn = false
        sut.tapFavourite()

        XCTAssertFalse(sut.isCharacterFavourite)
        XCTAssertEqual(coreDataManager.removeCharacterCalls, 1)
    }

    func test_checkIfIsFavourite() {
        coreDataManager.checkIfCharacterExistsResultToReturn = true
        XCTAssertFalse(sut.isCharacterFavourite)

        sut.checkIfIsFavourite()
        XCTAssertTrue(sut.isCharacterFavourite)
    }
}
