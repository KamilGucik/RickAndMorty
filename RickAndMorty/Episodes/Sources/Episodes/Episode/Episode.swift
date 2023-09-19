import Foundation

struct Episode: Codable, Identifiable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}

extension Episode {
    static func mockList(size: Int) -> [Self] {
        (0...size).map { index in
            Episode(
                id: index,
                name: "The Ricklantis Mixup \(index)",
                air_date: "September \(index), 2017",
                episode: "S03E07",
                characters: [
                    "https://rickandmortyapi.com/api/character/1",
                    "https://rickandmortyapi.com/api/character/2",
                ],
                url: "https://rickandmortyapi.com/api/episode/28",
                created: "2017-11-10T12:56:36.618Z"
            )
        }
    }
}
