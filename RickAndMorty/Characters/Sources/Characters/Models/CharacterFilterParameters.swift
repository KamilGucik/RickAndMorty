import Foundation

struct CharacterFilterParameters: Equatable {
    var name: String = ""
    var status: Character.Status?
    var species: String = ""
    var type: String = ""
    var gender: Character.Gender?

    var areFiltersSelected: Bool {
        [name, species, type].contains(where: { !$0.isEmpty }) ||
        status != nil || gender != nil
    }

    var parameters: [String: String] {
        var params: [String : String] = [:]
        if !name.isEmpty { params["name"] = name }
        if let status = status?.rawValue, !status.isEmpty { params["status"] = status }
        if !species.isEmpty { params["species"] = species }
        if !type.isEmpty { params["type"] = type }
        if let gender = gender?.rawValue, !gender.isEmpty { params["gender"] = gender }
        return params
    }
}
