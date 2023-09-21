import Foundation
@testable import Characters

class LocationRepositoryMock: LocationRepositoryProtocol {
    var getResidentsInLocationCalls = 0
    var getResidentsInLocationPassedID: Int?
    var getResidentsErrorToThrow: Error?
    var getResidentsResultToReturn: [Character]?

    func getResidentsInLocation(id: Int) async throws -> [Character] {
        getResidentsInLocationCalls += 1
        getResidentsInLocationPassedID = id

        if let getResidentsResultToReturn {
            return getResidentsResultToReturn
        }

        if let getResidentsErrorToThrow {
            throw getResidentsErrorToThrow
        }

        fatalError("Wrong mock configuration")
    }
}
