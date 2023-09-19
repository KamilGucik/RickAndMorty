import Foundation

enum NetworkError: LocalizedError {
    case invalidStatusCode(Int)
    case requestFailed(Error)
    case incorrectURL(base: String, injected: String)

    var errorDescription: String? {
        switch self {
        case .invalidStatusCode(let code): return "Invalid status code: \(code)"
        case .requestFailed(let error): return "Request failed: \(error)"
        case let .incorrectURL(base, injected): return "Requested with wrong URL. Base URL: \(base) and \(injected)"
        }
    }
}
