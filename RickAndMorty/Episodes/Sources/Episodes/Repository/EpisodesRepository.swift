import Foundation
import NetworkKit

protocol EpisodesRepositoryProtocol {
    func getEpisode(id: Int) async throws -> Episode
    func getEpisodeList() async throws -> [Episode]
}

class EpisodesRepository: EpisodesRepositoryProtocol {
    let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getEpisode(id: Int) async throws -> Episode {
        try await networkManager.runRequest(EpisodesRequest()).results[0]
    }

    func getEpisodeList() async throws -> [Episode] {
        try await networkManager.runRequest(EpisodesRequest()).results
    }
}

struct EpisodesRequest: Request {
    typealias ResultType = EpisodesResult
    var urlPath: String { "episode" }
    var httpMethod: HTTPMethod { .get }
    var body: Data? { nil }
    var timeout: TimeInterval { 30 }
}

struct EpisodesResult: Codable {
    let results: [Episode]
}
