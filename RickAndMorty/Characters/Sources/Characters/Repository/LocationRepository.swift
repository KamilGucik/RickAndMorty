import Foundation
import NetworkKit

protocol LocationRepositoryProtocol {
    func getResidentsInLocation(id: Int) async throws -> [Character]
}

class LocationRepository: LocationRepositoryProtocol {
    let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getResidentsInLocation(id: Int) async throws -> [Character] {
        let location = try await networkManager.runRequest(LocationRequest(id: id))
        let residents = location.formattedResidents
        if residents.count == 1 {
            return [try await networkManager.runRequest(MultipleCharacterRequest<Character>(
                ids: location.formattedResidents
            ))]
        } else {
            return try await networkManager.runRequest(MultipleCharacterRequest<[Character]>(
                ids: location.formattedResidents
            ))
        }
    }
}

struct LocationRequest: Request {
    typealias ResultType = Location
    var urlPath: String { "location/\(id.formatted())" }
    var httpMethod: HTTPMethod { .get }
    var body: Data? { nil }
    var timeout: TimeInterval { 10 }
    var parameters: [String : String] { [:] }

    var id: Int

    init(id: Int) {
        self.id = id
    }
}

struct MultipleCharacterRequest<Result: Codable>: Request {
    typealias ResultType = Result
    var urlPath: String { "character/\(ids)" }
    var httpMethod: HTTPMethod { .get }
    var body: Data? { nil }
    var timeout: TimeInterval { 10 }
    var parameters: [String : String] { [:] }

    var ids: String

    init(ids: [Int]) {
        self.ids = ids.map { String($0) }.joined(separator: ",")
    }
}
