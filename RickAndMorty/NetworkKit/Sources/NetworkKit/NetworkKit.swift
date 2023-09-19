import Foundation
import SerializationKit

public protocol NetworkManagerProtocol {
    func runRequest<R: Request>(_ request: R) async throws -> R.ResultType
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: LocalizedError {
    case invalidStatusCode(Int)
    case requestFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidStatusCode(let code): return "Invalid status code: \(code)"
        case .requestFailed(let error): return "Request failed: \(error)"
        }
    }
}

public protocol Request {
    associatedtype ResultType: Codable
    var urlPath: String { get }
    var httpMethod: HTTPMethod { get }
    var timeout: TimeInterval { get }
    var body: Data? { get }
}

public class NetworkManager: NetworkManagerProtocol {
    let session: Session
    let jsonSerializer: JSONSerializerProtocol
    let baseURLPath: String

    public init(
        session: Session = URLSession.shared,
        jsonSerializer: JSONSerializerProtocol = JSONSerializer(),
        baseURLPath: String = "https://rickandmortyapi.com/api/"
    ) {
        self.session = session
        self.jsonSerializer = jsonSerializer
        self.baseURLPath = baseURLPath
    }

    public func runRequest<R: Request>(_ request: R) async throws -> R.ResultType {
        guard
            let url = URL(string: baseURLPath + request.urlPath)
        else { fatalError() }
        var urlRequest = URLRequest(
            url: url,
            timeoutInterval: request.timeout
        )
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.httpBody = request.body

        do {
            let (data, statusCode) = try await session.run(request: urlRequest)
            if statusCode == 200 {
                return try jsonSerializer.decode(data: data, type: R.ResultType.self)
            } else {
                throw NetworkError.invalidStatusCode(statusCode)
            }
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}

enum SessionError: LocalizedError {
    case missingStatusCode
}

public protocol Session {
    func run(request: URLRequest) async throws -> (Data, Int)
}

extension URLSession: Session {
    public func run(request: URLRequest) async throws -> (Data, Int) {
        let (data, response) = try await self.data(for: request)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode
        else { throw SessionError.missingStatusCode }
        return (data, statusCode)
    }
}
