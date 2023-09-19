import Foundation

struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String?
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Origin: Codable {
    let name: String
    let url: String
}

struct Location: Codable {
    let name: String
    let url: String
}

extension Character {
        static func mockList(size: Int) -> [Self] {
            (0...size).map { index in
                Character(
                    id: index,
                    name: "Morty Smith \(index)",
                    status: "Alive",
                    species: "Human",
                    type: "",
                    gender: "Male",
                    origin: Origin(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
                    location: Location(name: "Earth", url: "https://rickandmortyapi.com/api/location/20"),
                    image: "https://rickandmortyapi.com/api/character/avatar/\(index).jpeg",
                    episode: [
                        "https://rickandmortyapi.com/api/episode/1",
                        "https://rickandmortyapi.com/api/episode/2"
                    ],
                    url: "https://rickandmortyapi.com/api/character/2",
                    created: "2017-11-04T18:50:21.651Z"
                )
            }
        }
}
