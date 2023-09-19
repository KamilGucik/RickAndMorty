import Foundation
import SerializationKit

public protocol NetworkManagerProtocol {
    func runRequest<R: Request>(_ request: R) async throws -> R.ResultType
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
        else { throw NetworkError.incorrectURL(base: baseURLPath, injected: request.urlPath) }
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
