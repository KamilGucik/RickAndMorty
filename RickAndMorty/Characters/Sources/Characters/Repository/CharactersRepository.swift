import Foundation
import NetworkKit

protocol CharactersRepositoryProtocol {
    func getCharacters(id: Int) async throws -> Character
    func getCharactersList() async throws -> [Character]
}

class CharactersRepository: CharactersRepositoryProtocol {
    let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getCharacters(id: Int) async throws -> Character {
        try await networkManager.runRequest(CharactersRequest()).results[0]
    }

    func getCharactersList() async throws -> [Character] {
        try await networkManager.runRequest(CharactersRequest()).results
    }
}

struct CharactersRequest: Request {
    typealias ResultType = CharactersResult
    var urlPath: String { "character" }
    var httpMethod: HTTPMethod { .get }
    var body: Data? { nil }
    var timeout: TimeInterval { 30 }
    var parameters: [String : String] { [:] }
}

struct CharactersResult: Codable {
    let results: [Character]
}
