import Foundation
import NetworkKit

protocol EpisodesRepositoryProtocol {
    func getEpisodeList(page: Int) async throws -> PaginatedEpisodesResult
}

class EpisodesRepository: EpisodesRepositoryProtocol {
    let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getEpisodeList(page: Int) async throws -> PaginatedEpisodesResult {
        try await networkManager.runRequest(EpisodesRequest(page: page))
    }
}

struct EpisodesRequest: Request {
    typealias ResultType = PaginatedEpisodesResult
    var urlPath: String { "episode" }
    var httpMethod: HTTPMethod { .get }
    var body: Data? { nil }
    var timeout: TimeInterval { 30 }
    var parameters: [String : String] { ["page": page.formatted()] }

    var page: Int

    init(page: Int) {
        self.page = page
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
