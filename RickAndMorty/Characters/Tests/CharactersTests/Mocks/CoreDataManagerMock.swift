import LocalStorageKit

class CoreDataManagerMock: CoreDataManagerProtocol {
    var addCharacterCalls = 0
    var addedCharacter: Character?
    var addCharacterErrorToThrow: Error?

    func addCharacter(
        id: Int,
        name: String,
        status: String,
        species: String,
        type: String?,
        gender: String,
        locationName: String,
        locationURL: String,
        image: String,
        episode: [String]
    ) throws {
        addCharacterCalls += 1
        if let addCharacterErrorToThrow {
            throw addCharacterErrorToThrow
        }
    }

    var removeCharacterCalls = 0
    var removedCharacterID: Int?
    var removeCharacterErrorToThrow: Error?
    
    func removeCharacter(id: Int) throws {
        removeCharacterCalls += 1
        if let removeCharacterErrorToThrow {
            throw removeCharacterErrorToThrow
        }
    }

    var fetchCalls = 0
    var fetchResultToReturn: [Character]?
    var fetchErrorToThrow: Error?

    func fetch() throws -> [Character] {
        fetchCalls += 1
        if let fetchErrorToThrow {
            throw fetchErrorToThrow
        }
        return fetchResultToReturn ?? []
    }

    var checkIfCharacterExistsCalls = 0
    var checkIfCharacterExistsPassedID: Int?
    var checkIfCharacterExistsResultToReturn: Bool = false

    func checkIfCharacterExists(id: Int) -> Bool {
        checkIfCharacterExistsCalls += 1
        if let checkIfCharacterExistsPassedID {
            return checkIfCharacterExistsPassedID == id
        }
        return checkIfCharacterExistsResultToReturn
    }
}
