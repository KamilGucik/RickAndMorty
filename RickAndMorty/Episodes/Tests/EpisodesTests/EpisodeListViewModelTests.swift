import XCTest
import NetworkKit
@testable import Episodes

@MainActor
final class EpisodeListViewModelTests: XCTestCase {
    private var sut: EpisodeListViewModel!
    private var repository: EpisodesRepositoryMock!

    override func setUp() {
        super.setUp()
        self.repository = .init()
        self.sut = .init(episodesRepository: repository)
    }

    override func tearDown() {
        self.repository = nil
        self.sut = nil
        super.tearDown()
    }

    func test_nextPage_ShouldIncrementPage() async {
        repository.getEpisodeListResultToReturn = .mock

        XCTAssertEqual(sut.page, 1)
        await sut.nextPage()

        XCTAssertEqual(sut.page, 2)
        XCTAssertFalse(sut.isLoadingNextPage)
        XCTAssertEqual(repository.getEpisodeListCalls, 1)
        XCTAssertEqual(repository.getEpisodeListPassedPage, 2)
    }

    func test_nextPage_ShouldShowError() async {
        repository.getEpisodeListErrorToThrow = NSError(domain: "", code: 0)

        XCTAssertEqual(sut.page, 1)
        await sut.nextPage()

        XCTAssertEqual(sut.page, 1)
        XCTAssertFalse(sut.isLoadingNextPage)
        XCTAssertTrue(sut.showNextPageError)
        XCTAssertEqual(repository.getEpisodeListCalls, 1)
        XCTAssertEqual(repository.getEpisodeListPassedPage, 2)
    }

    func test_refresh_ShouldResetData() async {
        repository.getEpisodeListResultToReturn = .mock
        sut.page = 2

        await sut.refresh()

        XCTAssertEqual(sut.page, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(repository.getEpisodeListCalls, 1)
        XCTAssertEqual(repository.getEpisodeListPassedPage, 1)
    }

    func test_refresh_ShouldShowError() async {
        repository.getEpisodeListErrorToThrow = NSError(domain: "", code: 0)
        sut.page = 2

        await sut.refresh()

        XCTAssertEqual(sut.page, 1)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(repository.getEpisodeListCalls, 1)
        XCTAssertEqual(repository.getEpisodeListPassedPage, 1)
    }

    func test_clearFilters_ShouldResetFilters() async {
        sut.filters = .init(name: "TEST")
        XCTAssertTrue(sut.filters.areFiltersSelected)

        sut.clearFilters()
        XCTAssertFalse(sut.filters.areFiltersSelected)
    }
}
