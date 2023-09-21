import Foundation
import NetworkKit

protocol EpisodesRepositoryProtocol {
    func getEpisodeList(
        page: Int?,
        name: String?,
        episode: String?
    ) async throws -> PaginatedEpisodesResult
}

extension EpisodesRepositoryProtocol {
    func getEpisodeList(
        page: Int?,
        name: String? = nil,
        episode: String? = nil
    ) async throws -> PaginatedEpisodesResult {
        try await getEpisodeList(page: page, name: name, episode: episode)
    }
}

class EpisodesRepository: EpisodesRepositoryProtocol {
    let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getEpisodeList(page: Int?, name: String?, episode: String?) async throws -> PaginatedEpisodesResult {
        try await networkManager.runRequest(EpisodeRequest(
            page: page,
            name: name,
            episode: episode
        ))
    }
}

struct EpisodeRequest: Request {
    typealias ResultType = PaginatedEpisodesResult
    var urlPath: String { "episode" }
    var httpMethod: HTTPMethod { .get }
    var body: Data? { nil }
    var timeout: TimeInterval { 30 }
    var parameters: [String : String] {
        var params: [String : String] = [:]
        if let page { params["page"] = page.formatted() }
        if let name, !name.isEmpty { params["name"] = name }
        if let episode, !episode.isEmpty { params["episode"] = episode }
        return params
    }

    var page: Int?
    var name: String?
    var episode: String?

    init(
        page: Int? = nil,
        name: String? = nil,
        episode: String? = nil
    ) {
        self.page = page
        self.name = name
        self.episode = episode
    }
}

struct PaginatedEpisodesResult: Codable {
    let info: PaginationInfo
    let results: [Episode]
}

struct PaginationInfo: Codable {
    var count: Int
    var pages: Int
    var next: URL?
    var prev: URL?

    var isNextPageAvailable: Bool { next != nil }
}
