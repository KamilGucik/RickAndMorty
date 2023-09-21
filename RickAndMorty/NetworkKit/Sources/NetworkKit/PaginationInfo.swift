import Foundation

public struct PaginationInfo: Codable {
    public var count: Int
    public var pages: Int
    public var next: URL?
    public var prev: URL?

    public var isNextPageAvailable: Bool { next != nil }
}
