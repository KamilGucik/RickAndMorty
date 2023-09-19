import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol Request {
    associatedtype ResultType: Codable
    var urlPath: String { get }
    var httpMethod: HTTPMethod { get }
    var timeout: TimeInterval { get }
    var parameters: [String: String] { get }
    var body: Data? { get }
}
