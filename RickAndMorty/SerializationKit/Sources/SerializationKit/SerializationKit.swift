import Foundation
public protocol JSONSerializerProtocol {
    func decode<T: Codable>(data: Data, type: T.Type) throws -> T
}

public enum JSONSerializerError: LocalizedError {
    case decoding(Error)
}

public class JSONSerializer: JSONSerializerProtocol {
    let decoder: JSONDecoder

    public init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    public func decode<T: Codable>(data: Data, type: T.Type) throws -> T {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw JSONSerializerError.decoding(error)
        }
    }
}
