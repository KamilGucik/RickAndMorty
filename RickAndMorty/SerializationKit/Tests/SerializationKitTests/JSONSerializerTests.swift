import XCTest
import Foundation
@testable import SerializationKit

final class JSONSerializerTests: XCTestCase {
    var sut: JSONSerializer!
    fileprivate var decoder: JSONDecoderMock!

    override func setUp() {
        super.setUp()
        decoder = .init()
        sut = .init(decoder: decoder)
    }

    override func tearDown() {
        decoder = nil
        sut = nil
        super.tearDown()
    }

    func test_decode_ShouldSuccess() throws {
        let testObject = TestObject()
        let encodedObject = try JSONEncoder().encode(testObject)
        let decodedObject = try sut.decode(data: encodedObject, type: TestObject.self)
        XCTAssertEqual(testObject, decodedObject)
    }

    func test_decode_ShouldThrow() throws {
        decoder.decodeError = MockError()
        let testObject = TestObject()
        do {
            let encodedObject = try JSONEncoder().encode(testObject)
            let decodedObject = try sut.decode(data: encodedObject, type: TestObject.self)
            XCTFail("Should throw")
        } catch {
            XCTAssertEqual(error.localizedDescription, JSONSerializerError.decoding(error).localizedDescription)
        }
    }
}

private struct MockError: Error {}
private struct TestObject: Codable, Equatable {
    var name = "TEST"
}

private class JSONDecoderMock: JSONDecoder {
    var decodeError: Error?
    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        if let decodeError {
            throw decodeError
        } else {
            return try super.decode(type, from: data)
        }
    }
}
