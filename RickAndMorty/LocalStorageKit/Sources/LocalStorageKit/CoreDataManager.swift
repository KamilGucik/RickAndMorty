import Foundation
import SwiftUI
import CoreData

public protocol CoreDataManagerProtocol {
    func addCharacter(
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
    ) throws
    func removeCharacter(id: Int) throws
    func fetch() throws -> [Character]
    func checkIfCharacterExists(id: Int) -> Bool
}

public enum CoreDataManagerError: String, LocalizedError {
    case insert
    case remove
    case save
    case fetch

    public var errorDescription: String? {
        return "Error occurred while running: \(self.rawValue) operation"
    }
}

public class CoreDataManager: CoreDataManagerProtocol {
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
    ) throws {
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
                throw CoreDataManagerError.insert
            }
        }
    }

    public func removeCharacter(id: Int) throws {
        let context = persistentContainer.viewContext
        do {
            try fetch()
                .filter { $0.id == id }
                .forEach { character in
                context.delete(character)
            }
            try context.save()
        } catch {
            throw CoreDataManagerError.remove
        }
    }

    public func fetch() throws -> [Character] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Character>(entityName: "Character")
        do {
            return try context.fetch(fetchRequest)
        } catch {
            throw CoreDataManagerError.fetch
        }
    }

    public func checkIfCharacterExists(id: Int) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Character>(entityName: "Character")
        do {
            return try fetch().contains(where: { $0.id == id })
        } catch {
            return false
        }
    }
}
