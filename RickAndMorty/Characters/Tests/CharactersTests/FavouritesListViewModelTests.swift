import XCTest
@testable import Characters

@MainActor
final class FavouritesListViewModelTests: XCTestCase {
    private var sut: FavouritesListViewModel!
    private var coreDataManager: CoreDataManagerMock!

    override func setUp() {
        super.setUp()
        self.coreDataManager = .init()
        self.sut = .init(coreDataManager: coreDataManager)
    }

    override func tearDown() {
        self.coreDataManager = nil
        self.sut = nil
        super.tearDown()
    }

    func test_fetchCharacters_ShouldFetchData() {
        sut.fetchCharacters()

        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(coreDataManager.fetchCalls, 1)
    }

    func test_fetchCharacters_ShouldShowError() async {
        coreDataManager.fetchErrorToThrow = NSError(domain: "", code: 0)

        sut.fetchCharacters()

        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(coreDataManager.fetchCalls, 1)
    }
}
