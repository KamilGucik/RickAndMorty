import Foundation
import CoreData

@objc(Character)
public class Character: NSManagedObject {

}

extension Character {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Character> {
        return NSFetchRequest<Character>(entityName: "Character")
    }

    @NSManaged public var episode: [String]
    @NSManaged public var gender: String
    @NSManaged public var id: Int64
    @NSManaged public var image: String
    @NSManaged public var locationName: String
    @NSManaged public var locationURL: String
    @NSManaged public var name: String
    @NSManaged public var species: String
    @NSManaged public var status: String
    @NSManaged public var type: String?
}
