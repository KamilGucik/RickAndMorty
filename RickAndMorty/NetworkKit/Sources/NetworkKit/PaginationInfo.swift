import Foundation

public struct PaginationInfo: Codable {
    public var next: URL?

    public var isNextPageAvailable: Bool { next != nil }

    public init(next: URL? = nil) {
        self.next = next
    }
}
