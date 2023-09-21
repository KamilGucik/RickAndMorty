import Foundation
@testable import Episodes

class EpisodesRepositoryMock: EpisodesRepositoryProtocol {
    var getEpisodeListCalls = 0
    var getEpisodeListPassedPage: Int?
    var getEpisodeListPassedFilters: EpisodeFilterParameters?
    var getEpisodeListErrorToThrow: Error?
    var getEpisodeListResultToReturn: PaginatedEpisodesResult?

    func getEpisodeList(
        page: Int?,
        filters: EpisodeFilterParameters?
    ) async throws -> PaginatedEpisodesResult {
        getEpisodeListCalls += 1
        getEpisodeListPassedPage = page
        getEpisodeListPassedFilters = filters

        if let getEpisodeListResultToReturn {
            return getEpisodeListResultToReturn
        }

        if let getEpisodeListErrorToThrow {
            throw getEpisodeListErrorToThrow
        }

        fatalError("Wrong mock configuration")
    }
}
