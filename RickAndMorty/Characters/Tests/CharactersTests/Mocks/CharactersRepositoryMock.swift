import Foundation
@testable import Characters

class CharactersRepositoryMock: CharactersRepositoryProtocol {
    var getCharacterListCalls = 0
    var getCharacterListPassedPage: Int?
    var getCharacterListPassedFilters: CharacterFilterParameters?
    var getCharacterListErrorToThrow: Error?
    var getCharacterListResultToReturn: PaginatedCharacterResult?

    func getCharacterList(
        page: Int?,
        filters: CharacterFilterParameters?
    ) async throws -> PaginatedCharacterResult {
        getCharacterListCalls += 1
        getCharacterListPassedPage = page
        getCharacterListPassedFilters = filters

        if let getCharacterListResultToReturn {
            return getCharacterListResultToReturn
        }

        if let getCharacterListErrorToThrow {
            throw getCharacterListErrorToThrow
        }

        fatalError("Wrong mock configuration")
    }
}
