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
    var timeout: TimeInterval { 30 }
    var parameters: [String : String] {
        var params: [String : String] = [:]
        if let page { params["page"] = page.formatted() }
        if let name = filters?.name, !name.isEmpty { params["name"] = name }
        if let status = filters?.status?.rawValue, !status.isEmpty { params["status"] = status }
        if let species = filters?.species, !species.isEmpty { params["species"] = species }
        if let type = filters?.type, !type.isEmpty { params["type"] = type }
        if let gender = filters?.gender?.rawValue, !gender.isEmpty { params["gender"] = gender }
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

struct CharacterFilterParameters: Equatable {
    var name: String = ""
    var status: Character.Status?
    var species: String = ""
    var type: String = ""
    var gender: Character.Gender?

    var areFiltersSelected: Bool {
        [name, species, type].contains(where: { !$0.isEmpty }) ||
        status != nil || gender != nil
    }
}

struct PaginatedCharacterResult: Codable {
    let info: PaginationInfo
    let results: [Character]
}

struct PaginationInfo: Codable {
    var count: Int
    var pages: Int
    var next: URL?
    var prev: URL?

    var isNextPageAvailable: Bool { next != nil }
}
