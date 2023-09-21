import XCTest
import NetworkKit
@testable import Characters

@MainActor
final class CharacterListViewModelTests: XCTestCase {
    private var sut: CharacterListViewModel!
    private var repository: CharactersRepositoryMock!

    override func setUp() {
        super.setUp()
        self.repository = .init()
        self.sut = .init(charactersRepository: repository)
    }

    override func tearDown() {
        self.repository = nil
        self.sut = nil
        super.tearDown()
    }

    func test_nextPage_ShouldIncrementPage() async {
        repository.getCharacterListResultToReturn = .mock

        XCTAssertEqual(sut.page, 1)
        await sut.nextPage()

        XCTAssertEqual(sut.page, 2)
        XCTAssertFalse(sut.isLoadingNextPage)
        XCTAssertEqual(repository.getCharacterListCalls, 1)
        XCTAssertEqual(repository.getCharacterListPassedPage, 2)
    }

    func test_nextPage_ShouldShowError() async {
        repository.getCharacterListErrorToThrow = NSError(domain: "", code: 0)

        XCTAssertEqual(sut.page, 1)
        await sut.nextPage()

        XCTAssertEqual(sut.page, 1)
        XCTAssertFalse(sut.isLoadingNextPage)
        XCTAssertTrue(sut.showNextPageError)
        XCTAssertEqual(repository.getCharacterListCalls, 1)
        XCTAssertEqual(repository.getCharacterListPassedPage, 2)
    }

    func test_refresh_ShouldResetData() async {
        repository.getCharacterListResultToReturn = .mock
        sut.page = 2

        await sut.refresh()

        XCTAssertEqual(sut.page, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(repository.getCharacterListCalls, 1)
        XCTAssertEqual(repository.getCharacterListPassedPage, 1)
    }

    func test_refresh_ShouldShowError() async {
        repository.getCharacterListErrorToThrow = NSError(domain: "", code: 0)
        sut.page = 2

        await sut.refresh()

        XCTAssertEqual(sut.page, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(repository.getCharacterListCalls, 1)
        XCTAssertEqual(repository.getCharacterListPassedPage, 1)
    }

    func test_clearFilters_ShouldResetFilters() async {
        sut.filters = .init(name: "TEST")
        XCTAssertTrue(sut.filters.areFiltersSelected)

        sut.clearFilters()
        XCTAssertFalse(sut.filters.areFiltersSelected)
    }
}
