import Foundation
import SwiftUI
import CoreData

public class CoreDataManager {
    public static let shared = CoreDataManager()
    let modelName = "Model"

    lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle.module
        let modelURL = bundle.url(forResource: modelName, withExtension: ".momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentCloudKitContainer(name: modelName, managedObjectModel: model)
        container.loadPersistentStores { (storeDescription, error) in
            if let error {
                print("Loading of store failed:\(error)")
            }
        }
        return container
    }()

    public func addCharacter(
        id: Int,
        name: String,
        status: String,
        species: String,
        type: String?,
        gender: String,
        locationName: String,
        locationURL: String,
        image: String,
        episode: [String]
    ) {
        let context = persistentContainer.viewContext
        if let character = NSEntityDescription.insertNewObject(
            forEntityName: "Character",
            into: context
        )
            as? Character {
            character.id = Int64(id)
            character.name = name
            character.status = status
            character.species = species
            character.type = type
            character.gender = gender
            character.locationName = locationName
            character.locationURL = locationURL
            character.image = image
            character.episode = episode
            do {
                context.insert(character)
                try context.save()
            } catch {
                print("❌ Failed to create Character: \(error.localizedDescription)")
            }
        }
    }

    public func removeCharacter(id: Int) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Character>(entityName: "Character")
        do {
            let characters = try context.fetch(fetchRequest).filter { $0.id == id }
            characters.forEach { character in
                context.delete(character)
            }
            try context.save()
        } catch {
            print("❌ Failed to fetch Person:", error)
        }
    }

    public func fetch() -> [Character] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Character>(entityName: "Character")
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("❌ Failed to fetch Person:", error)
            return []
        }
    }

    public func checkIfCharacterExists(id: Int) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Character>(entityName: "Character")
        do {
            let characters = try context.fetch(fetchRequest)
            return characters.contains(where: { $0.id == id })
        } catch {
            print("❌ Failed to fetch Person:", error)
            return false
        }
    }
}
