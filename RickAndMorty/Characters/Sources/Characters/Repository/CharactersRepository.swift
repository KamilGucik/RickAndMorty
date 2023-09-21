import Foundation
import NetworkKit

protocol CharactersRepositoryProtocol {
    func getCharacterList(
        page: Int?,
        filters: CharacterFilterParameters?
    ) async throws -> PaginatedCharacterResult
}

class CharactersRepository: CharactersRepositoryProtocol {
    let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getCharacterList(
        page: Int?,
        filters: CharacterFilterParameters?
    ) async throws -> PaginatedCharacterResult {
        try await networkManager.runRequest(CharacterRequest(
            page: page,
            filters: filters
        ))
    }
}

struct CharacterRequest: Request {
    typealias ResultType = PaginatedCharacterResult
    var urlPath: String { "character" }
    var httpMethod: HTTPMethod { .get }
    var body: Data? { nil }
    var timeout: TimeInterval { 10 }
    var parameters: [String : String] {
        var params: [String : String] = [:]
        if let page { params["page"] = page.formatted() }
        filters?.parameters.forEach { params[$0.key] = $0.value }
        return params
    }

    var page: Int?
    var filters: CharacterFilterParameters?

    init(
        page: Int? = nil,
        filters: CharacterFilterParameters? = nil
    ) {
        self.page = page
        self.filters = filters
    }
}

struct PaginatedCharacterResult: Codable {
    let info: PaginationInfo
    let results: [Character]
}
