import Foundation
import NetworkKit

protocol EpisodesRepositoryProtocol {
    func getEpisodeList(
        page: Int?,
        filters: EpisodeFilterParameters?
    ) async throws -> PaginatedEpisodesResult
}

class EpisodesRepository: EpisodesRepositoryProtocol {
    let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getEpisodeList(
        page: Int?,
        filters: EpisodeFilterParameters?
    ) async throws -> PaginatedEpisodesResult {
        try await networkManager.runRequest(EpisodeRequest(
            page: page,
            filters: filters
        ))
    }
}

struct EpisodeRequest: Request {
    typealias ResultType = PaginatedEpisodesResult
    var urlPath: String { "episode" }
    var httpMethod: HTTPMethod { .get }
    var body: Data? { nil }
    var timeout: TimeInterval { 10 }
    var parameters: [String : String] {
        var params: [String : String] = [:]
        if let page { params["page"] = page.formatted() }
        if let name = filters?.name, !name.isEmpty { params["name"] = name }
        if let episode = filters?.episode, !episode.isEmpty { params["episode"] = episode }
        return params
    }

    var page: Int?
    var filters: EpisodeFilterParameters?

    init(
        page: Int? = nil,
        filters: EpisodeFilterParameters? = nil
    ) {
        self.page = page
        self.filters = filters
    }
}

struct EpisodeFilterParameters: Equatable {
    var name: String = ""
    var episode: String = ""

    var areFiltersSelected: Bool {
        [name, episode].contains(where: { !$0.isEmpty })
    }
}

struct PaginatedEpisodesResult: Codable {
    let info: PaginationInfo
    let results: [Episode]
}
