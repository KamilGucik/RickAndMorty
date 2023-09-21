import Foundation

struct Location: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: URL
    let created: String

    var formattedResidents: [Int] {
        return residents.compactMap { urlString in
            urlString.split(separator: "/")
                .last
                .flatMap { Int($0) }
        }
    }
}
