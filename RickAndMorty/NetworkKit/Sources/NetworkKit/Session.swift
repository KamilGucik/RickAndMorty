import Foundation

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
