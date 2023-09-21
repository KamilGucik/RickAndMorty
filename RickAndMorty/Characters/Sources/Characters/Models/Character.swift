import Foundation

struct Character: Codable, Identifiable {
    enum Status: String, Codable, CaseIterable, Identifiable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown

        var id: Self { self }
    }
    enum Gender: String, Codable, CaseIterable, Identifiable {
        case female = "Female"
        case male = "Male"
        case genderless = "Genderless"
        case unknown

        var id: Self { self }
    }
    struct Location: Codable {
        let name: String
        let url: String

        var id: Int? {
            url.split(separator: "/")
                .last
                .flatMap { Int($0) }
        }
    }

    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String?
    let gender: Gender
    let location: Location
    let image: String
    let episode: [String]
}

extension Character {
    static func mock(id: Int) -> Self {
        Character(
            id: id,
            name: "Morty Smith \(id)",
            status: .alive,
            species: "Human",
            type: "",
            gender: .male,
            location: Location(name: "Earth", url: "https://rickandmortyapi.com/api/location/20"),
            image: "https://rickandmortyapi.com/api/character/avatar/\(id).jpeg",
            episode: [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
            ]
        )
    }

    static func mockList(size: Int) -> [Self] {
        (0...size).map { Character.mock(id: $0) }
    }
}
