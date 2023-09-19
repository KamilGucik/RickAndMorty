import XCTest
import SerializationKit
@testable import NetworkKit

final class NetworkKitTests: XCTestCase {
    private var sut: NetworkManager!
    private var session: SessionMock!
    private var jsonSerializer: JSONSerializerMock!

    override func setUp() {
        super.setUp()
        self.session = .init()
        self.jsonSerializer = .init()
        self.sut = .init(
            session: session,
            jsonSerializer: jsonSerializer
        )
    }

    override func tearDown() {
        self.session = nil
        self.jsonSerializer = nil
        self.sut = nil
        super.tearDown()
    }

    func test_runRequest_ShouldSuccess() async throws {
        struct TestRequest: Request {
            typealias ResultType = MockObject
            var url: URL = .init(string: "www.test.com")!
            var httpMethod: HTTPMethod = .get
            var body: Data? = nil
            var timeout: TimeInterval = 30
        }

        session.runRequestDataToReturn = .init()
        session.runRequestStatusCodeToReturn = 200
        let expectedObject = MockObject()
        jsonSerializer.decodeResult = expectedObject

        let testRequest = TestRequest()
        let result: MockObject = try await sut.runRequest(testRequest)

        XCTAssertEqual(session.runRequestCalls, 1)
        XCTAssertEqual(session.runRequestPassedRequest?.url, testRequest.url)
        XCTAssertEqual(session.runRequestPassedRequest?.httpBody, testRequest.body)
        XCTAssertEqual(session.runRequestPassedRequest?.timeoutInterval, testRequest.timeout)
        XCTAssertEqual(session.runRequestPassedRequest?.httpMethod, testRequest.httpMethod.rawValue)
        XCTAssertEqual(jsonSerializer.decodeCalls, 1)
        XCTAssertEqual(result.name, expectedObject.name)
    }

    func test_runRequest_ShouldThrowWhenInvalidStatus() async throws {
        struct TestRequest: Request {
            typealias ResultType = MockObject
            var url: URL = .init(string: "www.test.com")!
            var httpMethod: HTTPMethod = .get
            var body: Data? = nil
            var timeout: TimeInterval = 30
        }

        session.runRequestDataToReturn = .init()
        session.runRequestStatusCodeToReturn = 401
        let expectedObject = MockObject()
        jsonSerializer.decodeResult = expectedObject

        let testRequest = TestRequest()
        do {
            _ = try await sut.runRequest(testRequest)
            XCTFail("Should throw")
        } catch {
            XCTAssertEqual(session.runRequestCalls, 1)
            XCTAssertEqual(session.runRequestPassedRequest?.url, testRequest.url)
            XCTAssertEqual(session.runRequestPassedRequest?.httpBody, testRequest.body)
            XCTAssertEqual(session.runRequestPassedRequest?.timeoutInterval, testRequest.timeout)
            XCTAssertEqual(session.runRequestPassedRequest?.httpMethod, testRequest.httpMethod.rawValue)
            XCTAssertEqual(jsonSerializer.decodeCalls, 0)
            XCTAssertEqual(error.localizedDescription, NetworkError.requestFailed(NetworkError.invalidStatusCode(401)).localizedDescription)
        }
    }

    func test_runRequest_ShouldThrowWhenMissingStatus() async throws {
        struct TestRequest: Request {
            typealias ResultType = MockObject
            var url: URL = .init(string: "www.test.com")!
            var httpMethod: HTTPMethod = .get
            var body: Data? = nil
            var timeout: TimeInterval = 30
        }

        session.runRequestErrorToThrow = SessionError.missingStatusCode
        session.runRequestDataToReturn = .init()
        let expectedObject = MockObject()
        jsonSerializer.decodeResult = expectedObject

        let testRequest = TestRequest()
        do {
            _ = try await sut.runRequest(testRequest)
            XCTFail("Should throw")
        } catch {
            XCTAssertEqual(session.runRequestCalls, 1)
            XCTAssertEqual(session.runRequestPassedRequest?.url, testRequest.url)
            XCTAssertEqual(session.runRequestPassedRequest?.httpBody, testRequest.body)
            XCTAssertEqual(session.runRequestPassedRequest?.timeoutInterval, testRequest.timeout)
            XCTAssertEqual(session.runRequestPassedRequest?.httpMethod, testRequest.httpMethod.rawValue)
            XCTAssertEqual(jsonSerializer.decodeCalls, 0)
            XCTAssertEqual(error.localizedDescription, NetworkError.requestFailed(SessionError.missingStatusCode).localizedDescription)
        }
    }
}

private class SessionMock: Session {
    var runRequestCalls: Int = 0
    var runRequestDataToReturn: Data?
    var runRequestStatusCodeToReturn: Int?
    var runRequestErrorToThrow: Error?
    var runRequestPassedRequest: URLRequest?

    func run(request: URLRequest) async throws -> (Data, Int) {
        runRequestCalls += 1
        runRequestPassedRequest = request
        if let runRequestDataToReturn, let runRequestStatusCodeToReturn {
            return (runRequestDataToReturn, runRequestStatusCodeToReturn)
        } else {
            throw runRequestErrorToThrow ?? NSError(domain: "", code: 0)
        }
    }
}

private class JSONSerializerMock: JSONSerializerProtocol {
    var decodeCalls: Int = 0
    var decodeErrorToThrow: Error?
    var decodeResult: MockObject?

    func decode<T: Codable>(data: Data, type: T.Type) throws -> T {
        decodeCalls += 1
        if let decodeErrorToThrow { throw decodeErrorToThrow }
        if let decodeResult = decodeResult as? T {
            return decodeResult
        } else {
            throw NSError(domain: "", code: 0)
        }
    }
}

struct MockObject: Codable {
    var name = "test"
}
