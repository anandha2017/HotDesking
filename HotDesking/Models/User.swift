import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String
    @NSManaged public var name: String?
    @NSManaged public var role: String?
    @NSManaged public var bookings: Set<Booking>?
}

extension User {
    static func create(email: String, name: String?, role: String?, context: NSManagedObjectContext) -> User {
        let user = User(context: context)
        user.email = email
        user.name = name
        user.role = role
        return user
    }
}
